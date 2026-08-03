import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/features/slack/presentation/providers/slack_providers.dart';

/// Foreground live sync while Slack page is open.
class SlackLiveSyncController extends StateNotifier<bool> {
  SlackLiveSyncController(this._ref) : super(false);

  final Ref _ref;
  Timer? _messagesTimer;
  Timer? _listTimer;
  String? _conversationId;
  var _running = false;

  bool get isLive => state;

  void start({String? conversationId}) {
    _conversationId = conversationId;
    if (_running) return;
    _running = true;
    state = true;
    _messagesTimer?.cancel();
    _listTimer?.cancel();
    _messagesTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      unawaited(_tickMessages());
    });
    _listTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      unawaited(_tickList());
    });
    unawaited(_tickMessages());
  }

  void setConversation(String? conversationId) {
    _conversationId = conversationId;
  }

  void stop() {
    _running = false;
    _messagesTimer?.cancel();
    _listTimer?.cancel();
    _messagesTimer = null;
    _listTimer = null;
    if (state) state = false;
  }

  Future<void> _tickMessages() async {
    final id = _conversationId;
    if (!_running || id == null) return;
    final repo = _ref.read(slackRepositoryProvider);
    await repo.syncMessages(id, soft: true, limit: 30);
    await repo.refreshConversationUnread(id);
  }

  Future<void> _tickList() async {
    if (!_running) return;
    await _ref.read(slackRepositoryProvider).syncConversations();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}

final slackLiveSyncControllerProvider =
    StateNotifierProvider<SlackLiveSyncController, bool>((ref) {
  final controller = SlackLiveSyncController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});
