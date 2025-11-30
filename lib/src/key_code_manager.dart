import 'dart:io';

import 'package:bixat_key_mouse/bixat_key_mouse.dart';

/// Cross-platform key code interface
abstract class PlatformKeyCode {
  /// Get the platform-specific key code for a universal key
  int getKeyCode(UniversalKey key);

  /// Get the universal key from a platform-specific code
  UniversalKey? getUniversalKey(int code);

  /// Check if the current platform supports this key
  bool isKeySupported(UniversalKey key);
}

/// macOS implementation
class MacOSKeyCode implements PlatformKeyCode {
  static final Map<UniversalKey, KeyCode> _keyMap = {
    // Letters
    UniversalKey.a: KeyCode.ansiA,
    UniversalKey.s: KeyCode.ansiS,
    UniversalKey.d: KeyCode.ansiD,
    UniversalKey.f: KeyCode.ansiF,
    UniversalKey.h: KeyCode.ansiH,
    UniversalKey.g: KeyCode.ansiG,
    UniversalKey.z: KeyCode.ansiZ,
    UniversalKey.x: KeyCode.ansiX,
    UniversalKey.c: KeyCode.ansiC,
    UniversalKey.v: KeyCode.ansiV,
    UniversalKey.b: KeyCode.ansiB,
    UniversalKey.q: KeyCode.ansiQ,
    UniversalKey.w: KeyCode.ansiW,
    UniversalKey.e: KeyCode.ansiE,
    UniversalKey.r: KeyCode.ansiR,
    UniversalKey.y: KeyCode.ansiY,
    UniversalKey.t: KeyCode.ansiT,
    UniversalKey.i: KeyCode.ansiI,
    UniversalKey.o: KeyCode.ansiO,
    UniversalKey.u: KeyCode.ansiU,
    UniversalKey.p: KeyCode.ansiP,
    UniversalKey.l: KeyCode.ansiL,
    UniversalKey.j: KeyCode.ansiJ,
    UniversalKey.k: KeyCode.ansiK,
    UniversalKey.n: KeyCode.ansiN,
    UniversalKey.m: KeyCode.ansiM,

    // Numbers
    UniversalKey.num1: KeyCode.ansi1,
    UniversalKey.num2: KeyCode.ansi2,
    UniversalKey.num3: KeyCode.ansi3,
    UniversalKey.num4: KeyCode.ansi4,
    UniversalKey.num5: KeyCode.ansi5,
    UniversalKey.num6: KeyCode.ansi6,
    UniversalKey.num7: KeyCode.ansi7,
    UniversalKey.num8: KeyCode.ansi8,
    UniversalKey.num9: KeyCode.ansi9,
    UniversalKey.num0: KeyCode.ansi0,

    // Symbols
    UniversalKey.equal: KeyCode.ansiEqual,
    UniversalKey.minus: KeyCode.ansiMinus,
    UniversalKey.rightBracket: KeyCode.ansiRightBracket,
    UniversalKey.leftBracket: KeyCode.ansiLeftBracket,
    UniversalKey.quote: KeyCode.ansiQuote,
    UniversalKey.semicolon: KeyCode.ansiSemicolon,
    UniversalKey.backslash: KeyCode.ansiBackslash,
    UniversalKey.comma: KeyCode.ansiComma,
    UniversalKey.slash: KeyCode.ansiSlash,
    UniversalKey.period: KeyCode.ansiPeriod,
    UniversalKey.grave: KeyCode.ansiGrave,

    // Numpad
    UniversalKey.numPadDecimal: KeyCode.ansiKeypadDecimal,
    UniversalKey.numPadMultiply: KeyCode.ansiKeypadMultiply,
    UniversalKey.numPadAdd: KeyCode.ansiKeypadPlus,
    UniversalKey.numPadDivide: KeyCode.ansiKeypadDivide,
    UniversalKey.numPadEnter: KeyCode.ansiKeypadEnter,
    UniversalKey.numPadSubtract: KeyCode.ansiKeypadMinus,
    UniversalKey.numPad0: KeyCode.ansiKeypad0,
    UniversalKey.numPad1: KeyCode.ansiKeypad1,
    UniversalKey.numPad2: KeyCode.ansiKeypad2,
    UniversalKey.numPad3: KeyCode.ansiKeypad3,
    UniversalKey.numPad4: KeyCode.ansiKeypad4,
    UniversalKey.numPad5: KeyCode.ansiKeypad5,
    UniversalKey.numPad6: KeyCode.ansiKeypad6,
    UniversalKey.numPad7: KeyCode.ansiKeypad7,
    UniversalKey.numPad8: KeyCode.ansiKeypad8,
    UniversalKey.numPad9: KeyCode.ansiKeypad9,

    // Special keys
    UniversalKey.returnKey: KeyCode.returnKey,
    UniversalKey.tab: KeyCode.tabKey,
    UniversalKey.space: KeyCode.spaceKey,
    UniversalKey.delete: KeyCode.deleteKey,
    UniversalKey.escape: KeyCode.escapeKey,

    // Modifiers
    UniversalKey.leftControl: KeyCode.controlKey,
    UniversalKey.leftShift: KeyCode.shiftKey,
    UniversalKey.leftAlt: KeyCode.optionKey,
    UniversalKey.leftCommand: KeyCode.commandKey,
    UniversalKey.rightControl: KeyCode.rightControl,
    UniversalKey.rightShift: KeyCode.rightShift,
    UniversalKey.rightAlt: KeyCode.rightOption,
    UniversalKey.rightCommand: KeyCode.rightCommand,
    UniversalKey.capsLock: KeyCode.capsLock,
    UniversalKey.function: KeyCode.functionKey,

    // Function keys
    UniversalKey.f1: KeyCode.f1,
    UniversalKey.f2: KeyCode.f2,
    UniversalKey.f3: KeyCode.f3,
    UniversalKey.f4: KeyCode.f4,
    UniversalKey.f5: KeyCode.f5,
    UniversalKey.f6: KeyCode.f6,
    UniversalKey.f7: KeyCode.f7,
    UniversalKey.f8: KeyCode.f8,
    UniversalKey.f9: KeyCode.f9,
    UniversalKey.f10: KeyCode.f10,
    UniversalKey.f11: KeyCode.f11,
    UniversalKey.f12: KeyCode.f12,
    UniversalKey.f13: KeyCode.f13,
    UniversalKey.f14: KeyCode.f14,
    UniversalKey.f15: KeyCode.f15,
    UniversalKey.f16: KeyCode.f16,
    UniversalKey.f17: KeyCode.f17,
    UniversalKey.f18: KeyCode.f18,
    UniversalKey.f19: KeyCode.f19,
    UniversalKey.f20: KeyCode.f20,

    // Arrow keys
    UniversalKey.arrowLeft: KeyCode.leftArrow,
    UniversalKey.arrowRight: KeyCode.rightArrow,
    UniversalKey.arrowUp: KeyCode.upArrow,
    UniversalKey.arrowDown: KeyCode.downArrow,

    // Navigation
    UniversalKey.home: KeyCode.homeKey,
    UniversalKey.end: KeyCode.endKey,
    UniversalKey.pageUp: KeyCode.pageUp,
    UniversalKey.pageDown: KeyCode.pageDown,
    UniversalKey.help: KeyCode.helpKey,
    UniversalKey.forwardDelete: KeyCode.forwardDelete,

    // Media
    UniversalKey.volumeUp: KeyCode.volumeUp,
    UniversalKey.volumeDown: KeyCode.volumeDown,
    UniversalKey.mute: KeyCode.muteKey,
  };

  static final Map<int, UniversalKey> _reverseMap = {
    for (var entry in _keyMap.entries) entry.value.code: entry.key,
  };

  @override
  int getKeyCode(UniversalKey key) {
    final keyCode = _keyMap[key];
    if (keyCode == null) {
      throw UnsupportedError('Key $key is not supported on macOS');
    }
    return keyCode.code;
  }

  @override
  UniversalKey? getUniversalKey(int code) {
    return _reverseMap[code];
  }

  @override
  bool isKeySupported(UniversalKey key) {
    return _keyMap.containsKey(key);
  }
}

/// Windows implementation
class WindowsKeyCode implements PlatformKeyCode {
  static final Map<UniversalKey, KeyCodeWindows> _keyMap = {
    // Letters
    UniversalKey.a: KeyCodeWindows.vkA,
    UniversalKey.s: KeyCodeWindows.vkS,
    UniversalKey.d: KeyCodeWindows.vkD,
    UniversalKey.f: KeyCodeWindows.vkF,
    UniversalKey.h: KeyCodeWindows.vkH,
    UniversalKey.g: KeyCodeWindows.vkG,
    UniversalKey.z: KeyCodeWindows.vkZ,
    UniversalKey.x: KeyCodeWindows.vkX,
    UniversalKey.c: KeyCodeWindows.vkC,
    UniversalKey.v: KeyCodeWindows.vkV,
    UniversalKey.b: KeyCodeWindows.vkB,
    UniversalKey.q: KeyCodeWindows.vkQ,
    UniversalKey.w: KeyCodeWindows.vkW,
    UniversalKey.e: KeyCodeWindows.vkE,
    UniversalKey.r: KeyCodeWindows.vkR,
    UniversalKey.y: KeyCodeWindows.vkY,
    UniversalKey.t: KeyCodeWindows.vkT,
    UniversalKey.i: KeyCodeWindows.vkI,
    UniversalKey.o: KeyCodeWindows.vkO,
    UniversalKey.u: KeyCodeWindows.vkU,
    UniversalKey.p: KeyCodeWindows.vkP,
    UniversalKey.l: KeyCodeWindows.vkL,
    UniversalKey.j: KeyCodeWindows.vkJ,
    UniversalKey.k: KeyCodeWindows.vkK,
    UniversalKey.n: KeyCodeWindows.vkN,
    UniversalKey.m: KeyCodeWindows.vkM,

    // Numbers
    UniversalKey.num1: KeyCodeWindows.vk1,
    UniversalKey.num2: KeyCodeWindows.vk2,
    UniversalKey.num3: KeyCodeWindows.vk3,
    UniversalKey.num4: KeyCodeWindows.vk4,
    UniversalKey.num5: KeyCodeWindows.vk5,
    UniversalKey.num6: KeyCodeWindows.vk6,
    UniversalKey.num7: KeyCodeWindows.vk7,
    UniversalKey.num8: KeyCodeWindows.vk8,
    UniversalKey.num9: KeyCodeWindows.vk9,
    UniversalKey.num0: KeyCodeWindows.vk0,

    // Symbols
    UniversalKey.equal: KeyCodeWindows.vkEqual,
    UniversalKey.minus: KeyCodeWindows.vkMinus,
    UniversalKey.rightBracket: KeyCodeWindows.vkRightBracket,
    UniversalKey.leftBracket: KeyCodeWindows.vkLeftBracket,
    UniversalKey.quote: KeyCodeWindows.vkQuote,
    UniversalKey.semicolon: KeyCodeWindows.vkSemicolon,
    UniversalKey.backslash: KeyCodeWindows.vkBackslash,
    UniversalKey.comma: KeyCodeWindows.vkComma,
    UniversalKey.slash: KeyCodeWindows.vkSlash,
    UniversalKey.period: KeyCodeWindows.vkPeriod,
    UniversalKey.grave: KeyCodeWindows.vkGrave,

    // Numpad
    UniversalKey.numPadDecimal: KeyCodeWindows.vkNumPadDecimal,
    UniversalKey.numPadMultiply: KeyCodeWindows.vkNumPadMultiply,
    UniversalKey.numPadAdd: KeyCodeWindows.vkNumPadAdd,
    UniversalKey.numPadDivide: KeyCodeWindows.vkNumPadDivide,
    UniversalKey.numPadEnter: KeyCodeWindows.vkNumPadEnter,
    UniversalKey.numPadSubtract: KeyCodeWindows.vkNumPadSubtract,
    UniversalKey.numPad0: KeyCodeWindows.vkNumPad0,
    UniversalKey.numPad1: KeyCodeWindows.vkNumPad1,
    UniversalKey.numPad2: KeyCodeWindows.vkNumPad2,
    UniversalKey.numPad3: KeyCodeWindows.vkNumPad3,
    UniversalKey.numPad4: KeyCodeWindows.vkNumPad4,
    UniversalKey.numPad5: KeyCodeWindows.vkNumPad5,
    UniversalKey.numPad6: KeyCodeWindows.vkNumPad6,
    UniversalKey.numPad7: KeyCodeWindows.vkNumPad7,
    UniversalKey.numPad8: KeyCodeWindows.vkNumPad8,
    UniversalKey.numPad9: KeyCodeWindows.vkNumPad9,

    // Special keys
    UniversalKey.returnKey: KeyCodeWindows.vkReturn,
    UniversalKey.tab: KeyCodeWindows.vkTab,
    UniversalKey.space: KeyCodeWindows.vkSpace,
    UniversalKey.delete: KeyCodeWindows.vkDelete,
    UniversalKey.escape: KeyCodeWindows.vkEscape,

    // Modifiers
    UniversalKey.leftControl: KeyCodeWindows.vkLeftControl,
    UniversalKey.leftShift: KeyCodeWindows.vkLeftShift,
    UniversalKey.leftAlt: KeyCodeWindows.vkLeftAlt,
    UniversalKey.leftCommand: KeyCodeWindows.vkLeftWin,
    UniversalKey.rightControl: KeyCodeWindows.vkRightControl,
    UniversalKey.rightShift: KeyCodeWindows.vkRightShift,
    UniversalKey.rightAlt: KeyCodeWindows.vkRightAlt,
    UniversalKey.rightCommand: KeyCodeWindows.vkRightWin,
    UniversalKey.capsLock: KeyCodeWindows.vkCapsLock,
    UniversalKey.function: KeyCodeWindows.vkFunction,

    // Function keys
    UniversalKey.f1: KeyCodeWindows.vkF1,
    UniversalKey.f2: KeyCodeWindows.vkF2,
    UniversalKey.f3: KeyCodeWindows.vkF3,
    UniversalKey.f4: KeyCodeWindows.vkF4,
    UniversalKey.f5: KeyCodeWindows.vkF5,
    UniversalKey.f6: KeyCodeWindows.vkF6,
    UniversalKey.f7: KeyCodeWindows.vkF7,
    UniversalKey.f8: KeyCodeWindows.vkF8,
    UniversalKey.f9: KeyCodeWindows.vkF9,
    UniversalKey.f10: KeyCodeWindows.vkF10,
    UniversalKey.f11: KeyCodeWindows.vkF11,
    UniversalKey.f12: KeyCodeWindows.vkF12,
    UniversalKey.f13: KeyCodeWindows.vkF13,
    UniversalKey.f14: KeyCodeWindows.vkF14,
    UniversalKey.f15: KeyCodeWindows.vkF15,
    UniversalKey.f16: KeyCodeWindows.vkF16,
    UniversalKey.f17: KeyCodeWindows.vkF17,
    UniversalKey.f18: KeyCodeWindows.vkF18,
    UniversalKey.f19: KeyCodeWindows.vkF19,
    UniversalKey.f20: KeyCodeWindows.vkF20,

    // Arrow keys
    UniversalKey.arrowLeft: KeyCodeWindows.vkArrowLeft,
    UniversalKey.arrowRight: KeyCodeWindows.vkArrowRight,
    UniversalKey.arrowUp: KeyCodeWindows.vkArrowUp,
    UniversalKey.arrowDown: KeyCodeWindows.vkArrowDown,

    // Navigation
    UniversalKey.home: KeyCodeWindows.vkHome,
    UniversalKey.end: KeyCodeWindows.vkEnd,
    UniversalKey.pageUp: KeyCodeWindows.vkPageUp,
    UniversalKey.pageDown: KeyCodeWindows.vkPageDown,
    UniversalKey.help: KeyCodeWindows.vkHelp,
    UniversalKey.forwardDelete: KeyCodeWindows.vkForwardDelete,

    // Media
    UniversalKey.volumeUp: KeyCodeWindows.vkVolumeUp,
    UniversalKey.volumeDown: KeyCodeWindows.vkVolumeDown,
    UniversalKey.mute: KeyCodeWindows.vkMute,
  };

  static final Map<int, UniversalKey> _reverseMap = {
    for (var entry in _keyMap.entries) entry.value.code: entry.key,
  };

  @override
  int getKeyCode(UniversalKey key) {
    final keyCode = _keyMap[key];
    if (keyCode == null) {
      throw UnsupportedError('Key $key is not supported on Windows');
    }
    return keyCode.code;
  }

  @override
  UniversalKey? getUniversalKey(int code) {
    return _reverseMap[code];
  }

  @override
  bool isKeySupported(UniversalKey key) {
    return _keyMap.containsKey(key);
  }
}

/// Linux implementation
class LinuxKeyCode implements PlatformKeyCode {
  static final Map<UniversalKey, KeyCodeLinux> _keyMap = {
    // Letters
    UniversalKey.a: KeyCodeLinux.xkA,
    UniversalKey.s: KeyCodeLinux.xkS,
    UniversalKey.d: KeyCodeLinux.xkD,
    UniversalKey.f: KeyCodeLinux.xkF,
    UniversalKey.h: KeyCodeLinux.xkH,
    UniversalKey.g: KeyCodeLinux.xkG,
    UniversalKey.z: KeyCodeLinux.xkZ,
    UniversalKey.x: KeyCodeLinux.xkX,
    UniversalKey.c: KeyCodeLinux.xkC,
    UniversalKey.v: KeyCodeLinux.xkV,
    UniversalKey.b: KeyCodeLinux.xkB,
    UniversalKey.q: KeyCodeLinux.xkQ,
    UniversalKey.w: KeyCodeLinux.xkW,
    UniversalKey.e: KeyCodeLinux.xkE,
    UniversalKey.r: KeyCodeLinux.xkR,
    UniversalKey.y: KeyCodeLinux.xkY,
    UniversalKey.t: KeyCodeLinux.xkT,
    UniversalKey.i: KeyCodeLinux.xkI,
    UniversalKey.o: KeyCodeLinux.xkO,
    UniversalKey.u: KeyCodeLinux.xkU,
    UniversalKey.p: KeyCodeLinux.xkP,
    UniversalKey.l: KeyCodeLinux.xkL,
    UniversalKey.j: KeyCodeLinux.xkJ,
    UniversalKey.k: KeyCodeLinux.xkK,
    UniversalKey.n: KeyCodeLinux.xkN,
    UniversalKey.m: KeyCodeLinux.xkM,

    // Numbers
    UniversalKey.num1: KeyCodeLinux.xk1,
    UniversalKey.num2: KeyCodeLinux.xk2,
    UniversalKey.num3: KeyCodeLinux.xk3,
    UniversalKey.num4: KeyCodeLinux.xk4,
    UniversalKey.num5: KeyCodeLinux.xk5,
    UniversalKey.num6: KeyCodeLinux.xk6,
    UniversalKey.num7: KeyCodeLinux.xk7,
    UniversalKey.num8: KeyCodeLinux.xk8,
    UniversalKey.num9: KeyCodeLinux.xk9,
    UniversalKey.num0: KeyCodeLinux.xk0,

    // Symbols
    UniversalKey.equal: KeyCodeLinux.xkEqual,
    UniversalKey.minus: KeyCodeLinux.xkMinus,
    UniversalKey.rightBracket: KeyCodeLinux.xkRightBracket,
    UniversalKey.leftBracket: KeyCodeLinux.xkLeftBracket,
    UniversalKey.quote: KeyCodeLinux.xkQuote,
    UniversalKey.semicolon: KeyCodeLinux.xkSemicolon,
    UniversalKey.backslash: KeyCodeLinux.xkBackslash,
    UniversalKey.comma: KeyCodeLinux.xkComma,
    UniversalKey.slash: KeyCodeLinux.xkSlash,
    UniversalKey.period: KeyCodeLinux.xkPeriod,
    UniversalKey.grave: KeyCodeLinux.xkGrave,

    // Numpad
    UniversalKey.numPadDecimal: KeyCodeLinux.xkNumPadDecimal,
    UniversalKey.numPadMultiply: KeyCodeLinux.xkNumPadMultiply,
    UniversalKey.numPadAdd: KeyCodeLinux.xkNumPadAdd,
    UniversalKey.numPadDivide: KeyCodeLinux.xkNumPadDivide,
    UniversalKey.numPadEnter: KeyCodeLinux.xkNumPadEnter,
    UniversalKey.numPadSubtract: KeyCodeLinux.xkNumPadSubtract,
    UniversalKey.numPad0: KeyCodeLinux.xkNumPad0,
    UniversalKey.numPad1: KeyCodeLinux.xkNumPad1,
    UniversalKey.numPad2: KeyCodeLinux.xkNumPad2,
    UniversalKey.numPad3: KeyCodeLinux.xkNumPad3,
    UniversalKey.numPad4: KeyCodeLinux.xkNumPad4,
    UniversalKey.numPad5: KeyCodeLinux.xkNumPad5,
    UniversalKey.numPad6: KeyCodeLinux.xkNumPad6,
    UniversalKey.numPad7: KeyCodeLinux.xkNumPad7,
    UniversalKey.numPad8: KeyCodeLinux.xkNumPad8,
    UniversalKey.numPad9: KeyCodeLinux.xkNumPad9,

    // Special keys
    UniversalKey.returnKey: KeyCodeLinux.xkReturn,
    UniversalKey.tab: KeyCodeLinux.xkTab,
    UniversalKey.space: KeyCodeLinux.xkSpace,
    UniversalKey.delete: KeyCodeLinux.xkDelete,
    UniversalKey.escape: KeyCodeLinux.xkEscape,

    // Modifiers
    UniversalKey.leftControl: KeyCodeLinux.xkLeftControl,
    UniversalKey.leftShift: KeyCodeLinux.xkLeftShift,
    UniversalKey.leftAlt: KeyCodeLinux.xkLeftAlt,
    UniversalKey.leftCommand: KeyCodeLinux.xkLeftWin,
    UniversalKey.rightControl: KeyCodeLinux.xkRightControl,
    UniversalKey.rightShift: KeyCodeLinux.xkRightShift,
    UniversalKey.rightAlt: KeyCodeLinux.xkRightAlt,
    UniversalKey.rightCommand: KeyCodeLinux.xkRightWin,
    UniversalKey.capsLock: KeyCodeLinux.xkCapsLock,
    UniversalKey.function: KeyCodeLinux.xkFunction,

    // Function keys
    UniversalKey.f1: KeyCodeLinux.xkF1,
    UniversalKey.f2: KeyCodeLinux.xkF2,
    UniversalKey.f3: KeyCodeLinux.xkF3,
    UniversalKey.f4: KeyCodeLinux.xkF4,
    UniversalKey.f5: KeyCodeLinux.xkF5,
    UniversalKey.f6: KeyCodeLinux.xkF6,
    UniversalKey.f7: KeyCodeLinux.xkF7,
    UniversalKey.f8: KeyCodeLinux.xkF8,
    UniversalKey.f9: KeyCodeLinux.xkF9,
    UniversalKey.f10: KeyCodeLinux.xkF10,
    UniversalKey.f11: KeyCodeLinux.xkF11,
    UniversalKey.f12: KeyCodeLinux.xkF12,
    UniversalKey.f13: KeyCodeLinux.xkF13,
    UniversalKey.f14: KeyCodeLinux.xkF14,
    UniversalKey.f15: KeyCodeLinux.xkF15,
    UniversalKey.f16: KeyCodeLinux.xkF16,
    UniversalKey.f17: KeyCodeLinux.xkF17,
    UniversalKey.f18: KeyCodeLinux.xkF18,
    UniversalKey.f19: KeyCodeLinux.xkF19,
    UniversalKey.f20: KeyCodeLinux.xkF20,

    // Arrow keys
    UniversalKey.arrowLeft: KeyCodeLinux.xkArrowLeft,
    UniversalKey.arrowRight: KeyCodeLinux.xkArrowRight,
    UniversalKey.arrowUp: KeyCodeLinux.xkArrowUp,
    UniversalKey.arrowDown: KeyCodeLinux.xkArrowDown,

    // Navigation
    UniversalKey.home: KeyCodeLinux.xkHome,
    UniversalKey.end: KeyCodeLinux.xkEnd,
    UniversalKey.pageUp: KeyCodeLinux.xkPageUp,
    UniversalKey.pageDown: KeyCodeLinux.xkPageDown,
    UniversalKey.help: KeyCodeLinux.xkHelp,
    UniversalKey.forwardDelete: KeyCodeLinux.xkForwardDelete,

    // Media
    UniversalKey.volumeUp: KeyCodeLinux.xkVolumeUp,
    UniversalKey.volumeDown: KeyCodeLinux.xkVolumeDown,
    UniversalKey.mute: KeyCodeLinux.xkMute,
  };

  static final Map<int, UniversalKey> _reverseMap = {
    for (var entry in _keyMap.entries) entry.value.code: entry.key,
  };

  @override
  int getKeyCode(UniversalKey key) {
    final keyCode = _keyMap[key];
    if (keyCode == null) {
      throw UnsupportedError('Key $key is not supported on Linux');
    }
    return keyCode.code;
  }

  @override
  UniversalKey? getUniversalKey(int code) {
    return _reverseMap[code];
  }

  @override
  bool isKeySupported(UniversalKey key) {
    return _keyMap.containsKey(key);
  }
}

/// Factory class to get the appropriate platform-specific implementation
class KeyCodeManager {
  static PlatformKeyCode? _instance;

  /// Get the platform-specific key code implementation
  static PlatformKeyCode get instance {
    _instance ??= _createPlatformInstance();
    return _instance!;
  }

  static PlatformKeyCode _createPlatformInstance() {
    if (Platform.isMacOS) {
      return MacOSKeyCode();
    } else if (Platform.isWindows) {
      return WindowsKeyCode();
    } else if (Platform.isLinux) {
      return LinuxKeyCode();
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  /// Reset the instance (useful for testing)
  static void reset() {
    _instance = null;
  }
}

/// Convenience extension for easier usage
extension UniversalKeyExtension on UniversalKey {
  /// Get the platform-specific key code for this key
  int get code => KeyCodeManager.instance.getKeyCode(this);

  /// Check if this key is supported on the current platform
  bool get isSupported => KeyCodeManager.instance.isKeySupported(this);
}

/// Usage examples and utility functions
class KeyCodeUtils {
  /// Convert a platform-specific key code to universal key
  static UniversalKey? fromPlatformCode(int code) {
    return KeyCodeManager.instance.getUniversalKey(code);
  }

  /// Get all supported keys for the current platform
  static List<UniversalKey> getSupportedKeys() {
    final keys = <UniversalKey>[];
    for (final key in UniversalKey.values) {
      if (key.isSupported) {
        keys.add(key);
      }
    }
    return keys;
  }

  /// Check if a key combination is valid for the current platform
  static bool isKeyCombinationSupported(List<UniversalKey> keys) {
    return keys.every((key) => key.isSupported);
  }

  /// Get key name for display purposes
  /// Aligned with Flutter's LogicalKeyboardKey labels
  static String getKeyDisplayName(UniversalKey key) {
    switch (key) {
      // Letters (lowercase keys)
      case UniversalKey.a:
        return 'Key A';
      case UniversalKey.b:
        return 'Key B';
      case UniversalKey.c:
        return 'Key C';
      case UniversalKey.d:
        return 'Key D';
      case UniversalKey.e:
        return 'Key E';
      case UniversalKey.f:
        return 'Key F';
      case UniversalKey.g:
        return 'Key G';
      case UniversalKey.h:
        return 'Key H';
      case UniversalKey.i:
        return 'Key I';
      case UniversalKey.j:
        return 'Key J';
      case UniversalKey.k:
        return 'Key K';
      case UniversalKey.l:
        return 'Key L';
      case UniversalKey.m:
        return 'Key M';
      case UniversalKey.n:
        return 'Key N';
      case UniversalKey.o:
        return 'Key O';
      case UniversalKey.p:
        return 'Key P';
      case UniversalKey.q:
        return 'Key Q';
      case UniversalKey.r:
        return 'Key R';
      case UniversalKey.s:
        return 'Key S';
      case UniversalKey.t:
        return 'Key T';
      case UniversalKey.u:
        return 'Key U';
      case UniversalKey.v:
        return 'Key V';
      case UniversalKey.w:
        return 'Key W';
      case UniversalKey.x:
        return 'Key X';
      case UniversalKey.y:
        return 'Key Y';
      case UniversalKey.z:
        return 'Key Z';

      // Numbers
      case UniversalKey.num0:
        return 'Digit 0';
      case UniversalKey.num1:
        return 'Digit 1';
      case UniversalKey.num2:
        return 'Digit 2';
      case UniversalKey.num3:
        return 'Digit 3';
      case UniversalKey.num4:
        return 'Digit 4';
      case UniversalKey.num5:
        return 'Digit 5';
      case UniversalKey.num6:
        return 'Digit 6';
      case UniversalKey.num7:
        return 'Digit 7';
      case UniversalKey.num8:
        return 'Digit 8';
      case UniversalKey.num9:
        return 'Digit 9';

      // Symbols
      case UniversalKey.space:
        return 'Space';
      case UniversalKey.quote:
        return 'Quote Single';
      case UniversalKey.comma:
        return 'Comma';
      case UniversalKey.minus:
        return 'Minus';
      case UniversalKey.period:
        return 'Period';
      case UniversalKey.slash:
        return 'Slash';
      case UniversalKey.semicolon:
        return 'Semicolon';
      case UniversalKey.equal:
        return 'Equal';
      case UniversalKey.leftBracket:
        return 'Bracket Left';
      case UniversalKey.backslash:
        return 'Backslash';
      case UniversalKey.rightBracket:
        return 'Bracket Right';
      case UniversalKey.grave:
        return 'Backquote';

      // Special keys
      case UniversalKey.returnKey:
        return 'Enter';
      case UniversalKey.tab:
        return 'Tab';
      case UniversalKey.delete:
        return 'Backspace';
      case UniversalKey.escape:
        return 'Escape';
      case UniversalKey.forwardDelete:
        return 'Delete';

      // Modifiers
      case UniversalKey.leftControl:
        return 'Control Left';
      case UniversalKey.rightControl:
        return 'Control Right';
      case UniversalKey.leftShift:
        return 'Shift Left';
      case UniversalKey.rightShift:
        return 'Shift Right';
      case UniversalKey.leftAlt:
        return 'Alt Left';
      case UniversalKey.rightAlt:
        return 'Alt Right';
      case UniversalKey.leftCommand:
        return Platform.isMacOS ? 'Meta Left' : 'Meta Left';
      case UniversalKey.rightCommand:
        return Platform.isMacOS ? 'Meta Right' : 'Meta Right';
      case UniversalKey.capsLock:
        return 'Caps Lock';
      case UniversalKey.function:
        return 'Fn';

      // Function keys
      case UniversalKey.f1:
        return 'F1';
      case UniversalKey.f2:
        return 'F2';
      case UniversalKey.f3:
        return 'F3';
      case UniversalKey.f4:
        return 'F4';
      case UniversalKey.f5:
        return 'F5';
      case UniversalKey.f6:
        return 'F6';
      case UniversalKey.f7:
        return 'F7';
      case UniversalKey.f8:
        return 'F8';
      case UniversalKey.f9:
        return 'F9';
      case UniversalKey.f10:
        return 'F10';
      case UniversalKey.f11:
        return 'F11';
      case UniversalKey.f12:
        return 'F12';
      case UniversalKey.f13:
        return 'F13';
      case UniversalKey.f14:
        return 'F14';
      case UniversalKey.f15:
        return 'F15';
      case UniversalKey.f16:
        return 'F16';
      case UniversalKey.f17:
        return 'F17';
      case UniversalKey.f18:
        return 'F18';
      case UniversalKey.f19:
        return 'F19';
      case UniversalKey.f20:
        return 'F20';

      // Arrow keys
      case UniversalKey.arrowDown:
        return 'Arrow Down';
      case UniversalKey.arrowLeft:
        return 'Arrow Left';
      case UniversalKey.arrowRight:
        return 'Arrow Right';
      case UniversalKey.arrowUp:
        return 'Arrow Up';

      // Navigation
      case UniversalKey.end:
        return 'End';
      case UniversalKey.home:
        return 'Home';
      case UniversalKey.pageDown:
        return 'Page Down';
      case UniversalKey.pageUp:
        return 'Page Up';
      case UniversalKey.help:
        return 'Help';

      // Numpad
      case UniversalKey.numPadEnter:
        return 'Numpad Enter';
      case UniversalKey.numPadMultiply:
        return 'Numpad Multiply';
      case UniversalKey.numPadAdd:
        return 'Numpad Add';
      case UniversalKey.numPadSubtract:
        return 'Numpad Subtract';
      case UniversalKey.numPadDecimal:
        return 'Numpad Decimal';
      case UniversalKey.numPadDivide:
        return 'Numpad Divide';
      case UniversalKey.numPad0:
        return 'Numpad 0';
      case UniversalKey.numPad1:
        return 'Numpad 1';
      case UniversalKey.numPad2:
        return 'Numpad 2';
      case UniversalKey.numPad3:
        return 'Numpad 3';
      case UniversalKey.numPad4:
        return 'Numpad 4';
      case UniversalKey.numPad5:
        return 'Numpad 5';
      case UniversalKey.numPad6:
        return 'Numpad 6';
      case UniversalKey.numPad7:
        return 'Numpad 7';
      case UniversalKey.numPad8:
        return 'Numpad 8';
      case UniversalKey.numPad9:
        return 'Numpad 9';

      // Media
      case UniversalKey.volumeDown:
        return 'Audio Volume Down';
      case UniversalKey.volumeUp:
        return 'Audio Volume Up';
      case UniversalKey.mute:
        return 'Audio Volume Mute';
    }
  }
}
