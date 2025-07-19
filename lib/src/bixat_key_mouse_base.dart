import 'package:bixat_key_mouse/src/enums.dart';
import 'package:bixat_key_mouse/src/rust/api/bixat_key_mouse.dart';

class BixatKeyMouse {
  static void moveMouseAbs({required int x, required int y}) =>
      moveMouseAbsBase(x: x, y: y);

  static void moveMouseRel({required int x, required int y}) =>
      moveMouseRelBase(x: x, y: y);

  static void pressMouseButton({required MouseButton button}) =>
      pressMouseButtonBase(button: button.index);

  static void releaseMouseButton({required MouseButton button}) =>
      releaseMouseButtonBase(button: button.index);

  static void enterText({required String text}) => enterTextBase(text: text);

  static void simulateKey({required String key}) => simulateKeyBase(key: key);

  static void releaseKey({required String key}) => releaseKeyBase(key: key);
}
