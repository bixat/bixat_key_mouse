// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.11.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class BixatKeyMouse {
  static void moveMouseAbs({required int x, required int y}) =>
      RustLib.instance.api.crateApiBixatKeyMouseMoveMouseAbs(x: x, y: y);

  static void moveMouseRel({required int x, required int y}) =>
      RustLib.instance.api.crateApiBixatKeyMouseMoveMouseRel(x: x, y: y);

  static void pressMouseButton({required int button}) => RustLib.instance.api
      .crateApiBixatKeyMousePressMouseButton(button: button);

  static void releaseMouseButton({required int button}) => RustLib.instance.api
      .crateApiBixatKeyMouseReleaseMouseButton(button: button);

  static void enterText({required String text}) =>
      RustLib.instance.api.crateApiBixatKeyMouseEnterText(text: text);

  static void simulateKey({required String key}) =>
      RustLib.instance.api.crateApiBixatKeyMouseSimulateKey(key: key);

  static void releaseKey({required String key}) =>
      RustLib.instance.api.crateApiBixatKeyMouseReleaseKey(key: key);
}
