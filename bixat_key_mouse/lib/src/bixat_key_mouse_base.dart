import 'package:bixat_key_mouse/src/enums.dart';
import 'package:ffi/ffi.dart';
import 'extern_bixat_key_mouse.dart';

class BixatKeyMouse {
  static void moveMouseAbs(int x, int y) =>
      ExternBixatKeyMouse.moveMouseAbs(x, y);

  static void moveMouseRel(int x, int y) =>
      ExternBixatKeyMouse.moveMouseRel(x, y);

  // TODO: Implement mouse wheel support
  // TODO: Use enums instead of int
  static void pressMouseButton(MouseButton button) =>
      ExternBixatKeyMouse.pressMouseButton(button.index);

  static void releaseMouseButton(MouseButton button) =>
      ExternBixatKeyMouse.releaseMouseButton(button.index);

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

