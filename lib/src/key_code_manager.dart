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

    // Special keys
    UniversalKey.returnKey: KeyCode.returnKey,
    UniversalKey.tab: KeyCode.tabKey,
    UniversalKey.space: KeyCode.spaceKey,
    UniversalKey.delete: KeyCode.deleteKey,
    UniversalKey.escape: KeyCode.escapeKey,
    UniversalKey.numPadEnter: KeyCode.ansiKeypadEnter,
    UniversalKey.numPadDivide: KeyCode.ansiKeypadDivide,
    UniversalKey.numPadMultiply: KeyCode.ansiKeypadMultiply,
    UniversalKey.leftControl: KeyCode.rightControl,
    UniversalKey.rightControl: KeyCode.rightControl,
    UniversalKey.rightCommand: KeyCode.rightCommand,
    UniversalKey.leftCommand: KeyCode.commandKey,

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

    // Arrow keys
    UniversalKey.arrowLeft: KeyCode.leftArrow,
    UniversalKey.arrowRight: KeyCode.rightArrow,
    UniversalKey.arrowUp: KeyCode.upArrow,
    UniversalKey.arrowDown: KeyCode.downArrow,
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

    // Special keys
    UniversalKey.returnKey: KeyCodeWindows.vkReturn,
    UniversalKey.tab: KeyCodeWindows.vkTab,
    UniversalKey.space: KeyCodeWindows.vkSpace,
    UniversalKey.delete: KeyCodeWindows.vkDelete,
    UniversalKey.escape: KeyCodeWindows.vkEscape,

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

    // Arrow keys
    UniversalKey.arrowLeft: KeyCodeWindows.vkArrowLeft,
    UniversalKey.arrowRight: KeyCodeWindows.vkArrowRight,
    UniversalKey.arrowUp: KeyCodeWindows.vkArrowUp,
    UniversalKey.arrowDown: KeyCodeWindows.vkArrowDown,
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

    // Special keys
    UniversalKey.returnKey: KeyCodeLinux.xkReturn,
    UniversalKey.tab: KeyCodeLinux.xkTab,
    UniversalKey.space: KeyCodeLinux.xkSpace,
    UniversalKey.delete: KeyCodeLinux.xkDelete,
    UniversalKey.escape: KeyCodeLinux.xkEscape,

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

    // Arrow keys
    UniversalKey.arrowLeft: KeyCodeLinux.xkArrowLeft,
    UniversalKey.arrowRight: KeyCodeLinux.xkArrowRight,
    UniversalKey.arrowUp: KeyCodeLinux.xkArrowUp,
    UniversalKey.arrowDown: KeyCodeLinux.xkArrowDown,
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
  static String getKeyDisplayName(UniversalKey key) {
    switch (key) {
      // Letters
      case UniversalKey.a:
        return 'A';
      case UniversalKey.s:
        return 'S';
      case UniversalKey.d:
        return 'D';
      // Add more as needed...

      // Numbers
      case UniversalKey.num1:
        return '1';
      case UniversalKey.num2:
        return '2';
      case UniversalKey.num3:
        return '3';
      // Add more as needed...

      // Special keys
      case UniversalKey.returnKey:
        return 'Enter';
      case UniversalKey.tab:
        return 'Tab';
      case UniversalKey.space:
        return 'Space';
      case UniversalKey.delete:
        return 'Delete';
      case UniversalKey.escape:
        return 'Escape';

      // Arrow keys
      case UniversalKey.arrowLeft:
        return '←';
      case UniversalKey.arrowRight:
        return '→';
      case UniversalKey.arrowUp:
        return '↑';
      case UniversalKey.arrowDown:
        return '↓';

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

      // Modifiers
      case UniversalKey.leftControl:
        return Platform.isMacOS ? '⌃' : 'Ctrl';
      case UniversalKey.leftShift:
        return Platform.isMacOS ? '⇧' : 'Shift';
      case UniversalKey.leftAlt:
        return Platform.isMacOS ? '⌥' : 'Alt';
      case UniversalKey.leftCommand:
        return Platform.isMacOS ? '⌘' : 'Win';

      default:
        return key.name.toUpperCase();
    }
  }
}

// // Usage example:
// void exampleUsage() {
//   // Get platform-specific key code
//   final aKeyCode = UniversalKey.a.code;
//   print('A key code on this platform: 0x${aKeyCode.toRadixString(16)}');

//   // Check if a key is supported
//   if (UniversalKey.f13.isSupported) {
//     print('F13 key is supported on this platform');
//   }

//   // Convert platform code back to universal key
//   final universalKey = KeyCodeUtils.fromPlatformCode(aKeyCode);
//   print('Universal key: $universalKey');

//   // Get display name
//   final displayName = KeyCodeUtils.getKeyDisplayName(UniversalKey.leftCommand);
//   print('Command key display name: $displayName');

//   // Check key combination support
//   final combination = [UniversalKey.leftControl, UniversalKey.c];
//   if (KeyCodeUtils.isKeyCombinationSupported(combination)) {
//     print('Ctrl+C is supported on this platform');
//   }
// }
