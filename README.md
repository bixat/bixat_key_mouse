# 🖱️ Bixat Key Mouse

A powerful cross-platform Flutter plugin for simulating keyboard and mouse events on desktop platforms (Linux, Windows, macOS & BSD). Built with Rust for high performance and reliability.

## ✨ Features

- 🖲️ **Mouse Control**
  - Move mouse to absolute and relative positions
  - Press, release, and click mouse buttons (left, middle, right, back, forward)
  - Scroll mouse horizontally and vertically

- ⌨️ **Keyboard Simulation**
  - Simulate individual key presses and releases
  - Execute key combinations (e.g., Ctrl+C, Cmd+V)
  - Cross-platform key mapping with `UniversalKey` enum
  - Support for 100+ keys including:
    - All letters (A-Z)
    - Numbers (0-9) and numpad keys
    - Function keys (F1-F20)
    - Modifiers (Ctrl, Shift, Alt, Command/Win)
    - Symbols and punctuation
    - Navigation keys (arrows, home, end, page up/down)
    - Media keys (volume, mute)

- 📝 **Text Input**
  - Enter text programmatically

- 🖥️ **Desktop Compatibility**
  - Seamless cross-platform support
  - Platform-specific key code management

## Installation

To use Bixat Key Mouse in your Flutter project, add it to your `pubspec.yaml` file:

```shell
flutter pub add bixat_key_mouse
```

Then run `flutter pub get` to install the package.

## Supported Platforms

| Platform | Tested |
| -------- | ------ |
| Linux    | No     |
| Windows  | No     |
| macOS    | Yes    |
| BSD      | No     |


## 🚀 Getting Started

### Initialization

Before using the plugin, initialize it in your app:

```dart
import 'package:bixat_key_mouse/bixat_key_mouse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BixatKeyMouse.initialize();
  runApp(MyApp());
}
```

## 📖 Usage Examples

### Mouse Control

```dart
// Move mouse to absolute position (x: 100, y: 200)
BixatKeyMouse.moveMouse(
  x: 100,
  y: 200,
  coordinate: Coordinate.absolute,
);

// Move mouse relative to current position
BixatKeyMouse.moveMouse(
  x: 50,
  y: -30,
  coordinate: Coordinate.relative,
);

// Click left mouse button
BixatKeyMouse.pressMouseButton(
  button: MouseButton.left,
  direction: Direction.click,
);

// Press and hold right mouse button
BixatKeyMouse.pressMouseButton(
  button: MouseButton.right,
  direction: Direction.press,
);

// Release mouse button
BixatKeyMouse.pressMouseButton(
  button: MouseButton.left,
  direction: Direction.release,
);

// Scroll mouse vertically
BixatKeyMouse.scrollMouse(
  distance: 5,
  axis: ScrollAxis.vertical,
);

// Scroll mouse horizontally
BixatKeyMouse.scrollMouse(
  distance: -3,
  axis: ScrollAxis.horizontal,
);
```

### Keyboard Simulation

```dart
// Press a single key
BixatKeyMouse.simulateKey(
  key: UniversalKey.a,
  direction: Direction.press,
);

// Release a key
BixatKeyMouse.simulateKey(
  key: UniversalKey.a,
  direction: Direction.release,
);

// Click a key (press and release)
BixatKeyMouse.simulateKey(
  key: UniversalKey.enter,
  direction: Direction.click,
);

// Simulate key combination (e.g., Ctrl+C)
BixatKeyMouse.simulateKeyCombination(
  keys: [UniversalKey.leftControl, UniversalKey.c],
  duration: Duration(milliseconds: 100),
);

// Simulate Cmd+V on macOS or Ctrl+V on Windows/Linux
BixatKeyMouse.simulateKeyCombination(
  keys: [UniversalKey.leftCommand, UniversalKey.v],
  duration: Duration(milliseconds: 50),
);
```

### Text Input

```dart
// Enter text programmatically
BixatKeyMouse.enterText(text: 'Hello, World!');

// Type a sentence
BixatKeyMouse.enterText(text: 'This is automated text input.');
```

## 📚 API Reference

### Core Methods

#### `initialize()`
Initialize the Rust library. Must be called before using any other methods.

```dart
await BixatKeyMouse.initialize();
```

#### `moveMouse({required int x, required int y, Coordinate coordinate})`
Move the mouse cursor to a position.

**Parameters:**
- `x`: X coordinate
- `y`: Y coordinate
- `coordinate`: `Coordinate.absolute` or `Coordinate.relative` (default: `absolute`)

#### `pressMouseButton({required MouseButton button, Direction direction})`
Control mouse button actions.

**Parameters:**
- `button`: Mouse button (`left`, `middle`, `right`, `back`, `forward`, `scrollUp`, `scrollDown`, `scrollLeft`, `scrollRight`)
- `direction`: Action type (`press`, `release`, `click`) (default: `press`)

#### `scrollMouse({required int distance, ScrollAxis axis})`
Scroll the mouse wheel.

**Parameters:**
- `distance`: Scroll distance (positive or negative)
- `axis`: Scroll direction (`horizontal` or `vertical`) (default: `horizontal`)

#### `simulateKey({required UniversalKey key, Direction direction})`
Simulate a keyboard key action.

**Parameters:**
- `key`: The key to simulate (see `UniversalKey` enum)
- `direction`: Action type (`press`, `release`, `click`) (default: `press`)

#### `simulateKeyCombination({required List<UniversalKey> keys, Duration duration})`
Simulate a key combination (e.g., Ctrl+C).

**Parameters:**
- `keys`: List of keys to press simultaneously
- `duration`: How long to hold the keys (default: `100ms`)

#### `enterText({required String text})`
Type text programmatically.

**Parameters:**
- `text`: The text to type

### Enums

#### `MouseButton`
- `left`, `middle`, `right`, `back`, `forward`
- `scrollUp`, `scrollDown`, `scrollLeft`, `scrollRight`

#### `Direction`
- `press` - Press and hold
- `release` - Release a pressed key/button
- `click` - Press and immediately release

#### `Coordinate`
- `absolute` - Absolute screen position
- `relative` - Relative to current position

#### `ScrollAxis`
- `horizontal` - Scroll left/right
- `vertical` - Scroll up/down

#### `UniversalKey`
Cross-platform key identifiers. Includes:
- Letters: `a` to `z`
- Numbers: `num0` to `num9`
- Numpad: `numPad0` to `numPad9`, `numPadAdd`, `numPadSubtract`, etc.
- Function keys: `f1` to `f20`
- Modifiers: `leftControl`, `leftShift`, `leftAlt`, `leftCommand`, `rightControl`, etc.
- Symbols: `equal`, `minus`, `leftBracket`, `rightBracket`, `quote`, etc.
- Navigation: `arrowLeft`, `arrowRight`, `arrowUp`, `arrowDown`, `home`, `end`, `pageUp`, `pageDown`
- Special: `returnKey`, `tab`, `space`, `delete`, `escape`, `capsLock`, `function`
- Media: `volumeUp`, `volumeDown`, `mute`

## 🔧 Advanced Usage

### Complex Automation Example

```dart
// Automate a copy-paste operation
await Future.delayed(Duration(seconds: 1));

// Select all text (Ctrl+A / Cmd+A)
BixatKeyMouse.simulateKeyCombination(
  keys: [UniversalKey.leftCommand, UniversalKey.a],
);

await Future.delayed(Duration(milliseconds: 100));

// Copy (Ctrl+C / Cmd+C)
BixatKeyMouse.simulateKeyCombination(
  keys: [UniversalKey.leftCommand, UniversalKey.c],
);

await Future.delayed(Duration(milliseconds: 100));

// Move to another location
BixatKeyMouse.moveMouse(x: 500, y: 300, coordinate: Coordinate.absolute);
BixatKeyMouse.pressMouseButton(button: MouseButton.left, direction: Direction.click);

// Paste (Ctrl+V / Cmd+V)
BixatKeyMouse.simulateKeyCombination(
  keys: [UniversalKey.leftCommand, UniversalKey.v],
);
```

### Platform-Specific Key Codes

The plugin automatically handles platform-specific key codes:

```dart
// This works on all platforms
BixatKeyMouse.simulateKey(key: UniversalKey.leftCommand);

// On macOS: Uses Command key
// On Windows/Linux: Uses Windows/Super key

// Check if a key is supported on current platform
if (UniversalKey.f13.isSupported) {
  BixatKeyMouse.simulateKey(key: UniversalKey.f13);
}

// Get platform-specific key code
int keyCode = UniversalKey.a.code;
```

## 🏗️ Architecture

This plugin is built using:

- **[Flutter Rust Bridge](https://github.com/fzyzcjy/flutter_rust_bridge)** - Seamless Dart-Rust interop
- **[Enigo](https://crates.io/crates/enigo)** - Cross-platform input simulation in Rust
- **[Cargokit](https://github.com/irondash/cargokit)** - Rust build integration for Flutter

The architecture leverages Rust's performance and safety while maintaining Flutter's ease of use.

## 🤝 Contributing

Contributions are welcome! Please feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgements

Special thanks to:
- The [Enigo](https://crates.io/crates/enigo) team for the excellent cross-platform input simulation library
- The [Flutter Rust Bridge](https://github.com/fzyzcjy/flutter_rust_bridge) project for making Dart-Rust integration seamless
- All contributors and users of this package

## 📞 Support

- 🐛 [Report Issues](https://github.com/bixat/bixat_key_mouse/issues)
- � [Discussions](https://github.com/bixat/bixat_key_mouse/discussions)
- 🌐 [Website](https://bixat.dev)

---

Made with ❤️ by the Bixat team