import 'package:bixat_key_mouse/bixat_key_mouse.dart';
import 'package:bixat_key_mouse/src/rust/api/bixat_key_mouse.dart';
import 'package:flutter/widgets.dart';

class BixatKeyMouse {
  static void moveMouse({
    required int x,
    required int y,
    Coordinate coordinate = Coordinate.absolute,
  }) => moveMouseBase(x: x, y: y, coordinate: coordinate.index);

  static void pressMouseButton({
    required MouseButton button,
    Direction direction = Direction.press,
  }) => pressMouseButtonBase(button: button.index, direction: direction.index);

  static void enterText({required String text}) => enterTextBase(text: text);

  static void simulateKey({
    required UniversalKey key,
    Direction direction = Direction.press,
  }) => simulateKeyBase(key: key.code, direction: direction.index);

  static void scrollMouse({
    required int distance,
    Axis axis = Axis.horizontal,
  }) => scrollMouseBase(distance: distance, axis: axis.index);
}
