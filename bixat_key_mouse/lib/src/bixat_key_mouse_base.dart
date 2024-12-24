import 'package:ffi/ffi.dart';
import 'extern_bixat_key_mouse.dart';

class BixatKeyMouse {
  static void moveMouseAbs(int x, int y) =>
      ExternBixatKeyMouse.moveMouseAbs(x, y);

  static void moveMouseRel(int x, int y) =>
      ExternBixatKeyMouse.moveMouseRel(x, y);

  static void pressMouseButton(int button) =>
      ExternBixatKeyMouse.pressMouseButton(button);

  static void releaseMouseButton(int button) =>
      ExternBixatKeyMouse.releaseMouseButton(button);

  static void enterText(String text) {
    final textPointer = text.toNativeUtf8();
    ExternBixatKeyMouse.enterText(textPointer);
    malloc.free(textPointer);
  }

  static void simulateKeyPress(KeyModifier key) {
    final keyPointer = key.toString().toNativeUtf8();
    ExternBixatKeyMouse.simulateKeyPress(keyPointer);
    malloc.free(keyPointer);
  }

  static void releaseKey(KeyModifier key) {
    final keyPointer = key.toString().toNativeUtf8();
    ExternBixatKeyMouse.releaseKey(keyPointer);
    malloc.free(keyPointer);
  }
}

enum KeyModifier {
  shift,
  control,
  alt,
  meta,
  command,
  windows,
  superKey,
  backspace,
  tab,
  enter,
  escape,
  space,
  pageUp,
  pageDown,
  end,
  home,
  leftArrow,
  upArrow,
  rightArrow,
  downArrow,
  insert,
  delete,
  f1,
  f2,
  f3,
  f4,
  f5,
  f6,
  f7,
  f8,
  f9,
  f10,
  f11,
  f12,
  numLock,
  scrollLock,
  capsLock,
  printScreen,
  pause,
  clear,
  menu;

  @override
  String toString() {
    final name = super.toString().split('.').last;
    return name[0].toUpperCase() + name.substring(1);
  }
}
