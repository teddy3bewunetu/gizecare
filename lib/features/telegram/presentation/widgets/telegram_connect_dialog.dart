import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/widgets/app_snackbar.dart';
import 'package:gizecare/features/telegram/domain/entities/telegram_entities.dart';
import 'package:gizecare/features/telegram/domain/telegram_config.dart';
import 'package:gizecare/features/telegram/presentation/providers/telegram_providers.dart';
import 'package:gizecare/features/telegram/presentation/widgets/telegram_country_dials.dart';

/// Phone / code / password flow for Telegram Client API.
Future<bool> showTelegramConnectDialog(BuildContext context, WidgetRef ref) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const _TelegramConnectDialog(),
  ).then((v) => v ?? false);
}

class _TelegramConnectDialog extends ConsumerStatefulWidget {
  const _TelegramConnectDialog();

  @override
  ConsumerState<_TelegramConnectDialog> createState() =>
      _TelegramConnectDialogState();
}

class _TelegramConnectDialogState
    extends ConsumerState<_TelegramConnectDialog> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  var _busy = false;
  String? _error;
  /// Last non-error step so recoverable failures still show the right field.
  TelegramAuthStep _formStep = TelegramAuthStep.idle;
  /// Preferred first delivery when requesting a code.
  TelegramCodeDelivery _preferredDelivery = TelegramCodeDelivery.telegramApp;
  var _didAutoResendForSms = false;
  TelegramCountryDial _country = kDefaultTelegramCountry;
  String? _submittedPhone;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
    _phone.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    if (!TelegramConfig.hasCredentials) {
      setState(() {
        _error =
            'Telegram is not configured in this build. '
            'Developers: set TELEGRAM_API_ID / TELEGRAM_API_HASH (.env or CI secrets). '
            'See docs/telegram_setup.md / docs/snap_setup.md';
      });
      return;
    }
    setState(() => _busy = true);
    final client = ref.read(tdjsonClientProvider);
    if (client.isReady) {
      if (!mounted) return;
      Navigator.of(context).pop(true);
      AppSnackBar.show(context, 'Telegram connected');
      return;
    }
    final result = await ref.read(telegramRepositoryProvider).startClient();
    if (!mounted) return;
    if (client.isReady) {
      Navigator.of(context).pop(true);
      AppSnackBar.show(context, 'Telegram connected');
      return;
    }
    setState(() {
      _busy = false;
      _formStep = client.currentAuthStep;
    });
    client.publishAuthStep();
    result.when(
      onSuccess: (_) {},
      onFailure: (f) => setState(() => _error = _friendlyError(f.message)),
    );
  }

  String _fullPhone() {
    var local = _phone.text.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (local.startsWith('+')) {
      // User pasted a full international number — use as-is.
      return local;
    }
    // Strip leading 0 from national format (e.g. 09… → 9…).
    if (local.startsWith('0')) {
      local = local.substring(1);
    }
    return '${_country.dialCode}$local';
  }

  Future<void> _pickCountry() async {
    final picked = await showDialog<TelegramCountryDial>(
      context: context,
      builder: (context) => _CountryPickerDialog(selected: _country),
    );
    if (picked != null && mounted) {
      setState(() => _country = picked);
    }
  }

  Future<void> _submitPhone() async {
    final local = _phone.text.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (local.isEmpty) {
      setState(() => _error = 'Enter your phone number');
      return;
    }
    final client = ref.read(tdjsonClientProvider);
    if (client.isReady) {
      Navigator.of(context).pop(true);
      AppSnackBar.show(context, 'Telegram connected');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (client.currentAuthStep != TelegramAuthStep.waitPhone) {
        await client.ensureStarted();
      }
      if (!mounted) return;
      if (client.isReady) {
        Navigator.of(context).pop(true);
        AppSnackBar.show(context, 'Telegram connected');
        return;
      }
      if (client.currentAuthStep != TelegramAuthStep.waitPhone) {
        setState(() {
          _busy = false;
          _formStep = client.currentAuthStep;
          _error =
              'Telegram is still starting (${client.currentAuthStep.name}). '
              'Wait for Send code to enable, then try again.';
        });
        return;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = _friendlyError('$e');
      });
      return;
    }

    final phone = _fullPhone();
    setState(() {
      _didAutoResendForSms = false;
      _submittedPhone = phone;
    });
    final result =
        await ref.read(telegramRepositoryProvider).submitPhone(phone);
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) {},
      onFailure: (f) => setState(() => _error = _friendlyError(f.message)),
    );
  }

  Future<void> _submitCode() async {
    final code = _code.text.trim();
    if (code.isEmpty) {
      setState(() => _error = 'Enter the login code from Telegram/SMS');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final result =
        await ref.read(telegramRepositoryProvider).submitCode(code);
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) {},
      onFailure: (f) => setState(() => _error = f.message),
    );
  }

  Future<void> _submitPassword() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(telegramRepositoryProvider)
        .submitPassword(_password.text);
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) {},
      onFailure: (f) => setState(() => _error = f.message),
    );
  }

  Future<void> _resendCode() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(telegramRepositoryProvider).resendCode();
    if (!mounted) return;
    setState(() => _busy = false);
    result.when(
      onSuccess: (_) {
        AppSnackBar.show(context, 'New code requested');
      },
      onFailure: (f) => setState(() => _error = f.message),
    );
  }

  Future<void> _maybeAutoResendForSmsPreference(TelegramCodeInfo? info) async {
    if (_didAutoResendForSms) return;
    if (_preferredDelivery != TelegramCodeDelivery.sms) return;
    if (info == null) return;
    if (info.delivery == TelegramCodeDelivery.sms) return;
    if (info.nextDelivery != TelegramCodeDelivery.sms &&
        info.nextDelivery == null) {
      // Still try resend — Telegram often offers SMS as next type.
    }
    _didAutoResendForSms = true;
    await _resendCode();
  }

  String _friendlyError(String raw) {
    if (raw.contains('already in use') ||
        raw.contains("Can't lock") ||
        raw.contains('session is locked')) {
      return 'Telegram session was locked by a previous hot restart. '
          'Cancel, wait a second, and try Connect again — or quit the app fully once.';
    }
    if (raw.contains('PHONE_CODE_INVALID')) {
      return 'That login code is wrong or expired. Check Telegram (or SMS) and try again.';
    }
    if (raw.contains('PHONE_CODE_EXPIRED')) {
      return 'Login code expired. Use Resend, or Cancel and connect again.';
    }
    if (raw.contains('PHONE_NUMBER_INVALID')) {
      return 'Invalid phone number. Use international format like +2519…';
    }
    if (raw.contains('PHONE_NUMBER_FLOOD') || raw.contains('FLOOD')) {
      return 'Too many attempts. Wait a bit, then try again.';
    }
    if (raw.contains('PASSWORD_HASH_INVALID')) {
      return 'Wrong 2FA password. Try again.';
    }
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final stepAsync = ref.watch(telegramAuthStepProvider);
    final step = stepAsync.valueOrNull ?? TelegramAuthStep.idle;
    final codeInfo = ref.watch(telegramCodeInfoProvider).valueOrNull ??
        ref.read(tdjsonClientProvider).codeInfo;

    ref.listen(telegramAuthStepProvider, (prev, next) {
      final s = next.valueOrNull;
      if (s == null || !mounted) return;

      if (s == TelegramAuthStep.ready) {
        Navigator.of(context).pop(true);
        AppSnackBar.show(context, 'Telegram connected');
        return;
      }

      if (s != TelegramAuthStep.error) {
        setState(() {
          _formStep = s;
          if (s == TelegramAuthStep.waitCode ||
              s == TelegramAuthStep.waitPassword ||
              s == TelegramAuthStep.waitPhone) {
            final err = ref.read(tdjsonClientProvider).lastError;
            if (err != null && err.isNotEmpty) {
              _error = _friendlyError(err);
              ref.read(tdjsonClientProvider).lastError = null;
            }
          }
        });
      }

      final err = ref.read(tdjsonClientProvider).lastError;
      if (err != null && err.isNotEmpty) {
        setState(() => _error = _friendlyError(err));
      }
    });

    ref.listen(telegramCodeInfoProvider, (prev, next) {
      final info = next.valueOrNull;
      if (info != null) {
        unawaited(_maybeAutoResendForSmsPreference(info));
      }
    });

    final showStep =
        step == TelegramAuthStep.error ? _formStep : step;

    return AlertDialog(
      title: const Text('Connect Telegram'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 12),
            ],
            if (_busy ||
                showStep == TelegramAuthStep.waitTdlib ||
                showStep == TelegramAuthStep.idle)
              const LinearProgressIndicator(),
            const SizedBox(height: 8),
            if (showStep == TelegramAuthStep.waitTdlib ||
                showStep == TelegramAuthStep.idle)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Initializing Telegram…',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            if (showStep == TelegramAuthStep.waitPhone ||
                showStep == TelegramAuthStep.waitTdlib ||
                showStep == TelegramAuthStep.idle) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 128,
                    child: OutlinedButton(
                      onPressed: _busy ? null : _pickCountry,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              _country.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: '912345678',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _submitPhone(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Send login code via',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              SegmentedButton<TelegramCodeDelivery>(
                segments: const [
                  ButtonSegment(
                    value: TelegramCodeDelivery.telegramApp,
                    label: Text('Telegram'),
                    icon: Icon(Icons.send_outlined, size: 18),
                  ),
                  ButtonSegment(
                    value: TelegramCodeDelivery.sms,
                    label: Text('SMS'),
                    icon: Icon(Icons.sms_outlined, size: 18),
                  ),
                ],
                selected: {_preferredDelivery},
                onSelectionChanged: (s) {
                  setState(() => _preferredDelivery = s.first);
                },
              ),
            ],
            if (showStep == TelegramAuthStep.waitCode) ...[
              Text(
                codeInfo == null
                    ? 'Enter the login code sent to your phone'
                    : 'Code sent via ${codeInfo.deliveryLabel}'
                        '${_submittedPhone == null ? '' : ' · $_submittedPhone'}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _code,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Login code',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submitCode(),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _busy ? null : _resendCode,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: Text(
                    codeInfo?.nextDeliveryLabel == null
                        ? 'Resend code'
                        : 'Resend via ${codeInfo!.nextDeliveryLabel}',
                  ),
                ),
              ),
            ],
            if (showStep == TelegramAuthStep.waitPassword) ...[
              TextField(
                controller: _password,
                obscureText: true,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: '2FA password',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _submitPassword(),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        if (showStep == TelegramAuthStep.waitPhone ||
            showStep == TelegramAuthStep.waitTdlib ||
            showStep == TelegramAuthStep.idle)
          FilledButton(
            onPressed: (_busy ||
                    ref.read(tdjsonClientProvider).currentAuthStep !=
                        TelegramAuthStep.waitPhone)
                ? null
                : _submitPhone,
            child: Text(
              ref.read(tdjsonClientProvider).currentAuthStep ==
                      TelegramAuthStep.waitPhone
                  ? 'Send code'
                  : 'Please wait…',
            ),
          ),
        if (showStep == TelegramAuthStep.waitCode)
          FilledButton(
            onPressed: _busy ? null : _submitCode,
            child: const Text('Verify'),
          ),
        if (showStep == TelegramAuthStep.waitPassword)
          FilledButton(
            onPressed: _busy ? null : _submitPassword,
            child: const Text('Unlock'),
          ),
      ],
    );
  }
}

class _CountryPickerDialog extends StatefulWidget {
  const _CountryPickerDialog({required this.selected});

  final TelegramCountryDial selected;

  @override
  State<_CountryPickerDialog> createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<_CountryPickerDialog> {
  final _query = TextEditingController();
  late List<TelegramCountryDial> _filtered = List.of(kTelegramCountryDials);

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  void _filter(String q) {
    final needle = q.trim().toLowerCase();
    setState(() {
      if (needle.isEmpty) {
        _filtered = List.of(kTelegramCountryDials);
      } else {
        _filtered = kTelegramCountryDials
            .where((c) => c.searchText.contains(needle))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Country code'),
      content: SizedBox(
        width: 360,
        height: 420,
        child: Column(
          children: [
            TextField(
              controller: _query,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search country or code',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filter,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final c = _filtered[index];
                  final selected = c.iso2 == widget.selected.iso2 &&
                      c.dialCode == widget.selected.dialCode;
                  return ListTile(
                    selected: selected,
                    leading: Text(c.flag, style: const TextStyle(fontSize: 22)),
                    title: Text(c.name),
                    trailing: Text(
                      c.dialCode,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onTap: () => Navigator.pop(context, c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
