import 'package:flutter/material.dart';
import 'package:bixat_key_mouse/bixat_key_mouse.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BixatKeyMouse Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const BixatKeyMouseDemo(),
    );
  }
}

class BixatKeyMouseDemo extends StatefulWidget {
  const BixatKeyMouseDemo({super.key});

  @override
  State<BixatKeyMouseDemo> createState() => _BixatKeyMouseDemoState();
}

class _BixatKeyMouseDemoState extends State<BixatKeyMouseDemo> {
  final TextEditingController _xController = TextEditingController(text: '100');
  final TextEditingController _yController = TextEditingController(text: '100');
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();

  String _statusMessage = 'Ready';

  void _updateStatus(String message) {
    setState(() {
      _statusMessage = message;
    });
  }

  // Mouse movement functions
  void _moveMouseAbsolute() {
    try {
      int x = int.parse(_xController.text);
      int y = int.parse(_yController.text);
      BixatKeyMouse.moveMouse(x: x, y: y);
      _updateStatus('Mouse moved to ($x, $y)');
    } catch (e) {
      _updateStatus('Error: Invalid coordinates');
    }
  }

  void _moveMouseRelative() {
    try {
      int x = int.parse(_xController.text);
      int y = int.parse(_yController.text);
      BixatKeyMouse.moveMouse(x: x, y: y, coordinate: Coordinate.relative);
      _updateStatus('Mouse moved by ($x, $y)');
    } catch (e) {
      _updateStatus('Error: Invalid coordinates');
    }
  }

  // Mouse button functions
  void _leftClick() {
    BixatKeyMouse.pressMouseButton(button: MouseButton.left);
    BixatKeyMouse.pressMouseButton(
      button: MouseButton.left,
      direction: Direction.release,
    );
    _updateStatus('Left click performed');
  }

  void _rightClick() {
    BixatKeyMouse.pressMouseButton(button: MouseButton.right);
    BixatKeyMouse.pressMouseButton(
      button: MouseButton.right,
      direction: Direction.release,
    );
    _updateStatus('Right click performed');
  }

  void _middleClick() {
    BixatKeyMouse.pressMouseButton(button: MouseButton.middle);
    BixatKeyMouse.pressMouseButton(
      button: MouseButton.middle,
      direction: Direction.release,
    );
    _updateStatus('Middle click performed');
  }

  void _scrollMouse() {
    BixatKeyMouse.scrollMouse(axis: Axis.vertical, distance: 100);
    _updateStatus('Scroll Down performed');
  }

  // Keyboard functions
  void _typeText() {
    if (_textController.text.isNotEmpty) {
      BixatKeyMouse.enterText(text: _textController.text);
      _updateStatus('Text typed: "${_textController.text}"');
    } else {
      _updateStatus('Please enter some text');
    }
  }

  void _pressKey() {
    if (_keyController.text.isNotEmpty) {
      BixatKeyMouse.simulateKey(
        unicode: _keyController.text,
        key: KeyboardKey.ctrl,
      );
      _updateStatus('Key pressed: ${_keyController.text}');
    } else {
      _updateStatus('Please enter a key');
    }
  }

  void _releaseKey() {
    if (_keyController.text.isNotEmpty) {
      BixatKeyMouse.simulateKey(
        key: KeyboardKey.ctrl,
        unicode: _textController.text,
      );
      _updateStatus('Key released: ${_keyController.text}');
    } else {
      _updateStatus('Please enter a key');
    }
  }

  // Predefined actions
  void _performDoubleClick() {
    BixatKeyMouse.pressMouseButton(button: MouseButton.left);
    BixatKeyMouse.pressMouseButton(
      button: MouseButton.left,
      direction: Direction.release,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      BixatKeyMouse.pressMouseButton(button: MouseButton.left);
      BixatKeyMouse.pressMouseButton(
        button: MouseButton.left,
        direction: Direction.release,
      );
    });
    _updateStatus('Double click performed');
  }

  void _performKeyCombo() {
    // Simulate Ctrl+C
    BixatKeyMouse.simulateKey(key: KeyboardKey.ctrl);
    BixatKeyMouse.simulateKey(key: KeyboardKey.ctrl, unicode: "c");
    Future.delayed(const Duration(milliseconds: 100), () {
      BixatKeyMouse.simulateKey(
        key: KeyboardKey.ctrl,
        unicode: "c",
        direction: Direction.release,
      );
      BixatKeyMouse.simulateKey(
        key: KeyboardKey.ctrl,
        direction: Direction.release,
      );
    });
    _updateStatus('Ctrl+C performed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BixatKeyMouse Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _statusMessage,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Mouse controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Mouse Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _xController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'X Position',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _yController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Y Position',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _moveMouseAbsolute,
                            child: const Text('Move Absolute'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _moveMouseRelative,
                            child: const Text('Move Relative'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _leftClick,
                            child: const Text('Left Click'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _rightClick,
                            child: const Text('Right Click'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _middleClick,
                            child: const Text('Middle Click'),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _scrollMouse,
                            child: const Text('Scroll Down'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _performDoubleClick,
                      child: const Text('Double Click'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Keyboard controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Keyboard Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: 'Text to Type',
                        border: OutlineInputBorder(),
                        hintText: 'Enter text here...',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _typeText,
                      child: const Text('Type Text'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _keyController,
                      decoration: const InputDecoration(
                        labelText: 'Key Name',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., enter, space, ctrl, alt',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _pressKey,
                            child: const Text('Press Key'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _releaseKey,
                            child: const Text('Release Key'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _performKeyCombo,
                      child: const Text('Ctrl+C Combo'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            BixatKeyMouse.simulateKey(key: KeyboardKey.enter);
                            _updateStatus('Enter key pressed');
                          },
                          child: const Text('Enter'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BixatKeyMouse.simulateKey(key: KeyboardKey.space);
                            _updateStatus('Space key pressed');
                          },
                          child: const Text('Space'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BixatKeyMouse.simulateKey(key: KeyboardKey.tab);
                            _updateStatus('Tab key pressed');
                          },
                          child: const Text('Tab'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            BixatKeyMouse.simulateKey(key: KeyboardKey.escape);
                            _updateStatus('Escape key pressed');
                          },
                          child: const Text('Escape'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _textController.dispose();
    _keyController.dispose();
    super.dispose();
  }
}
