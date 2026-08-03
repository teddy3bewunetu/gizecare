import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'package:gizecare/features/slack/data/slack_token_store.dart';

/// Thin Slack Web API client using a stored user token.
class SlackApiClient {
  SlackApiClient({
    required SlackTokenStore tokenStore,
    http.Client? httpClient,
  })  : _tokenStore = tokenStore,
        _http = httpClient ?? http.Client();

  final SlackTokenStore _tokenStore;
  final http.Client _http;

  Future<String?> _accessToken() async {
    final tokens = await _tokenStore.read();
    return tokens?.accessToken;
  }

  Future<Map<String, dynamic>> post(
    String method, {
    Map<String, String>? form,
    Map<String, dynamic>? jsonBody,
  }) async {
    final token = await _accessToken();
    if (token == null || token.isEmpty) {
      throw StateError('Not connected to Slack');
    }
    final uri = Uri.parse('https://slack.com/api/$method');
    late http.Response response;
    if (jsonBody != null) {
      response = await _http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(jsonBody),
      );
    } else {
      response = await _http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: form ?? const <String, String>{},
      );
    }
    final map = jsonDecode(response.body) as Map<String, dynamic>;
    if (map['ok'] != true) {
      throw StateError(map['error'] as String? ?? 'Slack API error ($method)');
    }
    return map;
  }

  Future<Map<String, dynamic>> authTest() => post('auth.test');

  Future<Map<String, dynamic>> usersConversations({
    String? cursor,
    int limit = 200,
  }) {
    return post(
      'users.conversations',
      form: {
        'types': 'public_channel,private_channel,mpim,im',
        'exclude_archived': 'true',
        'limit': '$limit',
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
      },
    );
  }

  Future<Map<String, dynamic>> conversationsInfo(String channel) {
    return post(
      'conversations.info',
      form: {
        'channel': channel,
        'include_num_members': 'false',
      },
    );
  }

  Future<Map<String, dynamic>> conversationsHistory({
    required String channel,
    int limit = 50,
    String? oldest,
  }) {
    return post(
      'conversations.history',
      form: {
        'channel': channel,
        'limit': '$limit',
        if (oldest != null && oldest.isNotEmpty) 'oldest': oldest,
      },
    );
  }

  Future<Map<String, dynamic>> conversationsReplies({
    required String channel,
    required String ts,
    int limit = 100,
  }) {
    return post(
      'conversations.replies',
      form: {
        'channel': channel,
        'ts': ts,
        'limit': '$limit',
      },
    );
  }

  Future<Map<String, dynamic>> chatPostMessage({
    required String channel,
    required String text,
    String? threadTs,
  }) {
    return post(
      'chat.postMessage',
      jsonBody: {
        'channel': channel,
        'text': text,
        if (threadTs != null) 'thread_ts': threadTs,
      },
    );
  }

  Future<Map<String, dynamic>> chatUpdate({
    required String channel,
    required String ts,
    required String text,
  }) {
    return post(
      'chat.update',
      jsonBody: {
        'channel': channel,
        'ts': ts,
        'text': text,
      },
    );
  }

  Future<Map<String, dynamic>> chatDelete({
    required String channel,
    required String ts,
  }) {
    return post(
      'chat.delete',
      jsonBody: {
        'channel': channel,
        'ts': ts,
      },
    );
  }

  Future<Map<String, dynamic>> reactionsAdd({
    required String channel,
    required String timestamp,
    required String name,
  }) {
    return post(
      'reactions.add',
      form: {
        'channel': channel,
        'timestamp': timestamp,
        'name': name,
      },
    );
  }

  Future<Map<String, dynamic>> reactionsRemove({
    required String channel,
    required String timestamp,
    required String name,
  }) {
    return post(
      'reactions.remove',
      form: {
        'channel': channel,
        'timestamp': timestamp,
        'name': name,
      },
    );
  }

  Future<Map<String, dynamic>> conversationsMark({
    required String channel,
    required String ts,
  }) {
    return post(
      'conversations.mark',
      form: {
        'channel': channel,
        'ts': ts,
      },
    );
  }

  Future<Map<String, dynamic>> usersInfo(String userId) {
    return post('users.info', form: {'user': userId});
  }

  /// Modern 3-step upload: get URL → PUT bytes → complete.
  Future<Map<String, dynamic>> uploadFile({
    required String channel,
    required String filePath,
    String? caption,
    String? threadTs,
  }) async {
    final token = await _accessToken();
    if (token == null || token.isEmpty) {
      throw StateError('Not connected to Slack');
    }
    final file = File(filePath);
    if (!await file.exists()) {
      throw StateError('File not found: $filePath');
    }
    final bytes = await file.readAsBytes();
    final filename = p.basename(filePath);

    final prep = await post(
      'files.getUploadURLExternal',
      form: {
        'filename': filename,
        'length': '${bytes.length}',
      },
    );
    final uploadUrl = prep['upload_url'] as String?;
    final fileId = prep['file_id'] as String?;
    if (uploadUrl == null || fileId == null) {
      throw StateError('Slack did not return an upload URL');
    }

    final put = await _http.put(
      Uri.parse(uploadUrl),
      headers: {'Content-Type': 'application/octet-stream'},
      body: bytes,
    );
    if (put.statusCode < 200 || put.statusCode >= 300) {
      throw StateError('Slack file upload failed (${put.statusCode})');
    }

    return post(
      'files.completeUploadExternal',
      jsonBody: {
        'files': [
          {
            'id': fileId,
            'title': filename,
          },
        ],
        'channel_id': channel,
        if (caption != null && caption.isNotEmpty) 'initial_comment': caption,
        if (threadTs != null) 'thread_ts': threadTs,
      },
    );
  }

  Future<List<int>> downloadPrivateUrl(String url) async {
    final token = await _accessToken();
    if (token == null || token.isEmpty) {
      throw StateError('Not connected to Slack');
    }
    final response = await _http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('Failed to download Slack file (${response.statusCode})');
    }
    return response.bodyBytes;
  }

  void close() {
    _http.close();
  }
}
