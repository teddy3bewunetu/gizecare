import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

/// X11 XScreenSaver idle query via libXss (system-wide mouse/keyboard idle).
///
/// Returns idle duration, or `null` when X11 / libXss is unavailable.
Duration? queryX11IdleDuration() {
  if (!Platform.isLinux) return null;
  if (Platform.environment['DISPLAY'] == null ||
      Platform.environment['DISPLAY']!.isEmpty) {
    return null;
  }

  DynamicLibrary? x11;
  DynamicLibrary? xss;
  try {
    x11 = DynamicLibrary.open('libX11.so.6');
    xss = DynamicLibrary.open('libXss.so.1');
  } catch (_) {
    return null;
  }

  final xOpenDisplay = x11.lookupFunction<
      Pointer<Void> Function(Pointer<Utf8>),
      Pointer<Void> Function(Pointer<Utf8>)>('XOpenDisplay');
  final xDefaultRootWindow = x11.lookupFunction<
      UnsignedLong Function(Pointer<Void>),
      int Function(Pointer<Void>)>('XDefaultRootWindow');
  final xCloseDisplay = x11.lookupFunction<
      Int Function(Pointer<Void>),
      int Function(Pointer<Void>)>('XCloseDisplay');
  final xScreenSaverAllocInfo = xss.lookupFunction<
      Pointer<XScreenSaverInfoNative> Function(),
      Pointer<XScreenSaverInfoNative> Function()>('XScreenSaverAllocInfo');
  final xScreenSaverQueryInfo = xss.lookupFunction<
      Int Function(
        Pointer<Void>,
        UnsignedLong,
        Pointer<XScreenSaverInfoNative>,
      ),
      int Function(
        Pointer<Void>,
        int,
        Pointer<XScreenSaverInfoNative>,
      )>('XScreenSaverQueryInfo');
  final xFree = x11.lookupFunction<
      Int Function(Pointer<Void>),
      int Function(Pointer<Void>)>('XFree');

  final displayName = nullptr;
  final display = xOpenDisplay(displayName);
  if (display == nullptr) return null;

  try {
    final root = xDefaultRootWindow(display);
    final info = xScreenSaverAllocInfo();
    if (info == nullptr) return null;
    try {
      final ok = xScreenSaverQueryInfo(display, root, info);
      if (ok == 0) return null;
      return Duration(milliseconds: info.ref.idle);
    } finally {
      xFree(info.cast());
    }
  } finally {
    xCloseDisplay(display);
  }
}

/// Mirrors `XScreenSaverInfo` from X11/extensions/scrnsaver.h.
final class XScreenSaverInfoNative extends Struct {
  @UnsignedLong()
  external int window;

  @Int()
  external int state;

  @Int()
  external int kind;

  @UnsignedLong()
  external int tilOrSince;

  @UnsignedLong()
  external int idle;

  @UnsignedLong()
  external int eventMask;
}
