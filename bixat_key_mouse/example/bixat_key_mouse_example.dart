import '../lib/bixat_key_mouse.dart';

void main() {
  // Move the mouse to an absolute position
  BixatKeyMouse.moveMouseAbs(100, 100);

  // Move the mouse to a relative position
  BixatKeyMouse.moveMouseRel(50, 50);

  // Press the left mouse button
  BixatKeyMouse.pressMouseButton(1);

  // Release the left mouse button
  BixatKeyMouse.releaseMouseButton(1);

  // Enter text
  final text = 'Hello, world!';
  BixatKeyMouse.enterText(text);

  // Simulate key press
  final key = KeyModifier.command;
  BixatKeyMouse.simulateKeyPress(key);
  // Release key
  final keyRelease = KeyModifier.capsLock;
  BixatKeyMouse.simulateKeyPress(keyRelease);
}
