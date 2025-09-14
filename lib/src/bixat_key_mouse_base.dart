import 'package:bixat_key_mouse/bixat_key_mouse.dart';
import 'package:bixat_key_mouse/src/rust/api/bixat_key_mouse.dart';

class BixatKeyMouse {
  static Future<void> initialize() async {
    await RustLib.init();
  }

  static void simulateKeyCombination({
    required List<UniversalKey> keys,
    Duration duration = const Duration(milliseconds: 100),
  }) => simulateKeyCombinationBase(
    keys: keys.map((key) => key.code).toList(),
    durationMs: BigInt.from(duration.inMilliseconds),
  );

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
    ScrollAxis axis = ScrollAxis.horizontal,
  }) => scrollMouseBase(distance: distance, axis: axis.index);
}
