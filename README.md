# 🖱️ Bixat Key Mouse

Cross-platform (Linux, Windows, macOS & BSD) package to simulate keyboard and mouse events

## Features

- 🖲️ Move mouse to absolute and relative positions
- 🖱️ Press and release mouse buttons
- 🖋️ Enter text programmatically
- ⌨️ Simulate key presses and releases
- 🗝️ Support for multiple key modifiers
- 🖥️ Desktop compatibility

## Installation

To use Bixat Key Mouse in your Flutter project, add it to your `pubspec.yaml` file:

```shell
flutter pub add bixat_key_mouse
```

Then run `flutter pub get` to install the package.

## Getting Started

To use Bixat Key Mouse in your Dart code, import the package:

```dart
import 'package:bixat_key_mouse/bixat_key_mouse.dart';
```

## Basic Usage

Here's a simple example demonstrating various functionalities:

```dart
import 'package:bixat_key_mouse/bixat_key_mouse.dart';

void main() {
  // Move mouse to absolute position 🖱️
  BixatKeyMouse.moveMouseAbs(100, 100);

  // Move mouse relative to current position ➡️
  BixatKeyMouse.moveMouseRel(50, 50);

  // Press left mouse button 🖱️
  BixatKeyMouse.pressMouseButton(1);

  // Release left mouse button 🖱️
  BixatKeyMouse.releaseMouseButton(1);

  // Enter text 🖋️
  final text = 'Hello, world!';
  BixatKeyMouse.enterText(text);

  // Simulate key press ⌨️
  final key = KeyModifier.command;
  BixatKeyMouse.simulateKeyPress(key);

  // Release key ⌨️
  final keyRelease = KeyModifier.capsLock;
  BixatKeyMouse.simulateKeyPress(keyRelease);
}
```

## Available Functions

### Mouse Control

#### moveMouseAbs(int x, int y)
Move the mouse cursor to an absolute position on the screen. 📍

```dart
BixatKeyMouse.moveMouseAbs(100, 100);
```

#### moveMouseRel(int dx, int dy)
Move the mouse cursor relative to its current position. ➡️

```dart
BixatKeyMouse.moveMouseRel(50, 50);
```

#### pressMouseButton(int button)
Press the specified mouse button. 🖱️

```dart
BixatKeyMouse.pressMouseButton(1); // Left mouse button
BixatKeyMouse.pressMouseButton(2); // Middle mouse button
BixatKeyMouse.pressMouseButton(3); // Right mouse button
```

#### releaseMouseButton(int button)
Release the specified mouse button. 🖱️

```dart
BixatKeyMouse.releaseMouseButton(1);
```

### Text Input

#### enterText(String text)
Enter text programmatically. 📜

```dart
final text = 'Hello, world!';
BixatKeyMouse.enterText(text);
```

### Keyboard Simulation

#### simulateKeyPress(KeyModifier modifier)
Simulate key press. ⌨️

```dart
final key = KeyModifier.command;
BixatKeyMouse.simulateKeyPress(key);
```

#### simulateKeyPress(KeyModifier modifier)
Simulate key release. ⌨️

```dart
final keyRelease = KeyModifier.capsLock;
BixatKeyMouse.simulateKeyPress(keyRelease);
```

## Key Modifier Values

The package supports various key modifiers. Here's a list of available values: 🔑

```dart
const KeyModifier {
  command,
  shift,
  control,
  alt,
  capsLock,
  numLock,
  scrollLock,
}
```

## Advanced Usage

### Combining Functions

You can combine mouse movements and key presses for complex interactions: 🔄

```dart
BixatKeyMouse.moveMouseAbs(100, 100);
BixatKeyMouse.pressMouseButton(1);
// Perform actions...
BixatKeyMouse.releaseMouseButton(1);
```

### Handling Exceptions

The package throws exceptions when certain operations fail. It's recommended to handle these exceptions: ⚠️

```dart
try {
  BixatKeyMouse.moveMouseAbs(100, 100);
} catch (e) {
  print('Error moving mouse: $e');
}
```

## Acknowledgements

The Bixat Key Mouse package utilizes the [Enigo](https://crates.io/crates/enigo) crate for simulating keyboard and mouse events across different platforms. Enigo is a Rust library that provides a cross-platform abstraction for controlling keyboards and mice, making it a valuable underlying tool for this package. 🎉

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. 🤝

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 📜