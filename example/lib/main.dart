import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bixat_key_mouse/bixat_key_mouse.dart';

/// Bixat Key Mouse Demo Application
///
/// This example demonstrates all features of the bixat_key_mouse plugin:
/// - Mouse movement (absolute and relative)
/// - Mouse button actions (click, press, release)
/// - Mouse scrolling (horizontal and vertical)
/// - Keyboard simulation (individual keys and combinations)
/// - Text input automation
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Rust library before using the plugin
  await BixatKeyMouse.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bixat Key Mouse Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BixatKeyMouseDemo(),
    );
  }
}

class BixatKeyMouseDemo extends StatefulWidget {
  const BixatKeyMouseDemo({super.key});

  @override
  State<BixatKeyMouseDemo> createState() => _BixatKeyMouseDemoState();
}

class _BixatKeyMouseDemoState extends State<BixatKeyMouseDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _xController = TextEditingController(text: '500');
  final TextEditingController _yController = TextEditingController(text: '500');
  final TextEditingController _textController = TextEditingController(
    text: 'Hello from Bixat Key Mouse!',
  );
  final TextEditingController _scrollController = TextEditingController(
    text: '5',
  );

  String _statusMessage = '✅ Ready - Plugin initialized successfully';
  Color _statusColor = Colors.green;
  UniversalKey _selectedKey = UniversalKey.a;
  Direction _selectedDirection = Direction.click;
  ScrollAxis _selectedScrollAxis = ScrollAxis.vertical;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _xController.dispose();
    _yController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateStatus(String message, {bool isError = false}) {
    setState(() {
      _statusMessage = isError ? '❌ $message' : '✅ $message';
      _statusColor = isError ? Colors.red : Colors.green;
    });
  }

  // ==================== Mouse Functions ====================

  void _moveMouseAbsolute() {
    try {
      final x = int.parse(_xController.text);
      final y = int.parse(_yController.text);
      BixatKeyMouse.moveMouse(x: x, y: y, coordinate: Coordinate.absolute);
      _updateStatus('Mouse moved to absolute position ($x, $y)');
    } catch (e) {
      _updateStatus('Invalid coordinates: $e', isError: true);
    }
  }

  void _moveMouseRelative() {
    try {
      final x = int.parse(_xController.text);
      final y = int.parse(_yController.text);
      BixatKeyMouse.moveMouse(x: x, y: y, coordinate: Coordinate.relative);
      _updateStatus('Mouse moved by relative offset ($x, $y)');
    } catch (e) {
      _updateStatus('Invalid coordinates: $e', isError: true);
    }
  }

  void _performMouseAction(MouseButton button, Direction direction) {
    BixatKeyMouse.pressMouseButton(button: button, direction: direction);
    _updateStatus('${button.name} button ${direction.name}');
  }

  void _performDoubleClick() async {
    BixatKeyMouse.pressMouseButton(
      button: MouseButton.left,
      direction: Direction.click,
    );
    await Future.delayed(const Duration(milliseconds: 50));
    BixatKeyMouse.pressMouseButton(
      button: MouseButton.left,
      direction: Direction.click,
    );
    _updateStatus('Double click performed');
  }

  void _scrollMouse() {
    try {
      final distance = int.parse(_scrollController.text);
      BixatKeyMouse.scrollMouse(distance: distance, axis: _selectedScrollAxis);
      _updateStatus('Scrolled ${_selectedScrollAxis.name} by $distance');
    } catch (e) {
      _updateStatus('Invalid scroll distance: $e', isError: true);
    }
  }

  // ==================== Keyboard Functions ====================

  void _simulateKey() {
    BixatKeyMouse.simulateKey(key: _selectedKey, direction: _selectedDirection);
    _updateStatus('Key ${_selectedKey.name} ${_selectedDirection.name}');
  }

  void _typeText() {
    if (_textController.text.isEmpty) {
      _updateStatus('Please enter some text', isError: true);
      return;
    }
    BixatKeyMouse.enterText(text: _textController.text);
    _updateStatus('Typed: "${_textController.text}"');
  }

  // ==================== Key Combination Functions ====================

  Future<void> _performCopyPaste() async {
    final modifierKey = Platform.isMacOS
        ? UniversalKey.leftCommand
        : UniversalKey.leftControl;

    // Select all
    BixatKeyMouse.simulateKeyCombination(
      keys: [modifierKey, UniversalKey.a],
      duration: const Duration(milliseconds: 50),
    );
    await Future.delayed(const Duration(milliseconds: 100));

    // Copy
    BixatKeyMouse.simulateKeyCombination(
      keys: [modifierKey, UniversalKey.c],
      duration: const Duration(milliseconds: 50),
    );
    await Future.delayed(const Duration(milliseconds: 100));

    // Paste
    BixatKeyMouse.simulateKeyCombination(
      keys: [modifierKey, UniversalKey.v],
      duration: const Duration(milliseconds: 50),
    );

    _updateStatus('Copy-Paste sequence completed');
  }

  Future<void> _performCustomCombo(
    List<UniversalKey> keys,
    String description,
  ) async {
    BixatKeyMouse.simulateKeyCombination(
      keys: keys,
      duration: const Duration(milliseconds: 100),
    );
    _updateStatus(description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🖱️ Bixat Key Mouse Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.mouse), text: 'Mouse Movement'),
            Tab(icon: Icon(Icons.touch_app), text: 'Mouse Buttons'),
            Tab(icon: Icon(Icons.keyboard), text: 'Keyboard'),
            Tab(icon: Icon(Icons.text_fields), text: 'Text Input'),
            Tab(icon: Icon(Icons.auto_awesome), text: 'Automation'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: _statusColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(
                  _statusColor == Colors.green
                      ? Icons.check_circle
                      : Icons.error,
                  color: _statusColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _statusMessage,
                    style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMouseMovementTab(),
                _buildMouseButtonsTab(),
                _buildKeyboardTab(),
                _buildTextInputTab(),
                _buildAutomationTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== Tab Builders ====================

  Widget _buildMouseMovementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🖱️ Mouse Movement',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Control mouse cursor position using absolute or relative coordinates.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _xController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'X Coordinate',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.arrow_forward),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _yController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Y Coordinate',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.arrow_downward),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _moveMouseAbsolute,
            icon: const Icon(Icons.gps_fixed),
            label: const Text('Move to Absolute Position'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _moveMouseRelative,
            icon: const Icon(Icons.open_with),
            label: const Text('Move by Relative Offset'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Quick Movement Presets',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPresetButton('Top Left', 0, 0),
              _buildPresetButton('Top Right', 1920, 0),
              _buildPresetButton('Center', 960, 540),
              _buildPresetButton('Bottom Left', 0, 1080),
              _buildPresetButton('Bottom Right', 1920, 1080),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, int x, int y) {
    return ElevatedButton(
      onPressed: () {
        BixatKeyMouse.moveMouse(x: x, y: y, coordinate: Coordinate.absolute);
        _updateStatus('Mouse moved to $label ($x, $y)');
      },
      child: Text(label),
    );
  }

  Widget _buildMouseButtonsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🖱️ Mouse Buttons & Scrolling',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Simulate mouse button clicks and scroll wheel actions.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            'Mouse Buttons',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildMouseButtonCard(
            'Left Button',
            Icons.mouse,
            MouseButton.left,
            Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildMouseButtonCard(
            'Right Button',
            Icons.mouse,
            MouseButton.right,
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildMouseButtonCard(
            'Middle Button',
            Icons.mouse,
            MouseButton.middle,
            Colors.green,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _performDoubleClick,
            icon: const Icon(Icons.touch_app),
            label: const Text('Double Click'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Mouse Scrolling',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _scrollController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Scroll Distance',
                    border: OutlineInputBorder(),
                    helperText: 'Positive = down/right, Negative = up/left',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<ScrollAxis>(
                  initialValue: _selectedScrollAxis,
                  decoration: const InputDecoration(
                    labelText: 'Scroll Axis',
                    border: OutlineInputBorder(),
                  ),
                  items: ScrollAxis.values.map((axis) {
                    return DropdownMenuItem(
                      value: axis,
                      child: Text(axis.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedScrollAxis = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _scrollMouse,
            icon: const Icon(Icons.swap_vert),
            label: const Text('Scroll Mouse'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        ],
      ),
    );
  }

  Widget _buildMouseButtonCard(
    String title,
    IconData icon,
    MouseButton button,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _performMouseAction(button, Direction.click),
                    child: const Text('Click'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _performMouseAction(button, Direction.press),
                    child: const Text('Press'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _performMouseAction(button, Direction.release),
                    child: const Text('Release'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '⌨️ Keyboard Simulation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Simulate individual key presses, releases, and clicks.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<UniversalKey>(
            initialValue: _selectedKey,
            decoration: const InputDecoration(
              labelText: 'Select Key',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.keyboard),
            ),
            items: _getCommonKeys().map((key) {
              return DropdownMenuItem(
                value: key,
                child: Text(key.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedKey = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Direction>(
            initialValue: _selectedDirection,
            decoration: const InputDecoration(
              labelText: 'Action Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.touch_app),
            ),
            items: Direction.values.map((direction) {
              return DropdownMenuItem(
                value: direction,
                child: Text(direction.name.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDirection = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _simulateKey,
            icon: const Icon(Icons.keyboard_alt),
            label: Text(
              'Simulate ${_selectedKey.name} ${_selectedDirection.name}',
            ),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Quick Key Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickKeyButton('Enter', UniversalKey.returnKey),
              _buildQuickKeyButton('Space', UniversalKey.space),
              _buildQuickKeyButton('Tab', UniversalKey.tab),
              _buildQuickKeyButton('Escape', UniversalKey.escape),
              _buildQuickKeyButton('Delete', UniversalKey.delete),
              _buildQuickKeyButton('↑', UniversalKey.arrowUp),
              _buildQuickKeyButton('↓', UniversalKey.arrowDown),
              _buildQuickKeyButton('←', UniversalKey.arrowLeft),
              _buildQuickKeyButton('→', UniversalKey.arrowRight),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Modifier Keys',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickKeyButton('Ctrl', UniversalKey.leftControl),
              _buildQuickKeyButton('Shift', UniversalKey.leftShift),
              _buildQuickKeyButton('Alt', UniversalKey.leftAlt),
              _buildQuickKeyButton(
                Platform.isMacOS ? 'Cmd' : 'Win',
                UniversalKey.leftCommand,
              ),
              _buildQuickKeyButton('Caps Lock', UniversalKey.capsLock),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickKeyButton(String label, UniversalKey key) {
    return ElevatedButton(
      onPressed: () {
        BixatKeyMouse.simulateKey(key: key, direction: Direction.click);
        _updateStatus('$label key clicked');
      },
      child: Text(label),
    );
  }

  List<UniversalKey> _getCommonKeys() {
    return [
      // Letters
      UniversalKey.a, UniversalKey.b, UniversalKey.c, UniversalKey.d,
      UniversalKey.e, UniversalKey.f, UniversalKey.g, UniversalKey.h,
      // Numbers
      UniversalKey.num0, UniversalKey.num1, UniversalKey.num2,
      UniversalKey.num3, UniversalKey.num4, UniversalKey.num5,
      // Special
      UniversalKey.returnKey, UniversalKey.space, UniversalKey.tab,
      UniversalKey.escape, UniversalKey.delete,
      // Arrows
      UniversalKey.arrowUp, UniversalKey.arrowDown,
      UniversalKey.arrowLeft, UniversalKey.arrowRight,
      // Modifiers
      UniversalKey.leftControl, UniversalKey.leftShift,
      UniversalKey.leftAlt, UniversalKey.leftCommand,
      // Function keys
      UniversalKey.f1, UniversalKey.f2, UniversalKey.f3, UniversalKey.f4,
    ];
  }

  Widget _buildTextInputTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '📝 Text Input Automation',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Automatically type text into any application.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _textController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Text to Type',
              border: OutlineInputBorder(),
              hintText: 'Enter the text you want to type automatically...',
              helperText: 'This text will be typed character by character',
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _typeText,
            icon: const Icon(Icons.text_fields),
            label: const Text('Type Text'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Quick Text Presets',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTextPresetButton('Hello World', 'Hello, World!'),
          const SizedBox(height: 8),
          _buildTextPresetButton(
            'Email Template',
            'Dear Sir/Madam,\n\nThank you for your email.\n\nBest regards,',
          ),
          const SizedBox(height: 8),
          _buildTextPresetButton(
            'Lorem Ipsum',
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
          const SizedBox(height: 8),
          _buildTextPresetButton(
            'Code Snippet',
            'function hello() {\n  console.log("Hello from Bixat!");\n}',
          ),
        ],
      ),
    );
  }

  Widget _buildTextPresetButton(String label, String text) {
    return ElevatedButton(
      onPressed: () {
        BixatKeyMouse.enterText(text: text);
        _updateStatus('Typed: $label');
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            text.length > 50 ? '${text.substring(0, 50)}...' : text,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAutomationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '🤖 Automation & Key Combinations',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Execute complex automation sequences and key combinations.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          const Text(
            'Common Key Combinations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildComboCard(
            'Copy-Paste Automation',
            'Select All → Copy → Paste',
            Icons.content_copy,
            Colors.blue,
            _performCopyPaste,
          ),
          const SizedBox(height: 12),
          _buildComboCard(
            Platform.isMacOS ? 'Cmd+C (Copy)' : 'Ctrl+C (Copy)',
            'Copy selected content',
            Icons.copy,
            Colors.green,
            () => _performCustomCombo([
              Platform.isMacOS
                  ? UniversalKey.leftCommand
                  : UniversalKey.leftControl,
              UniversalKey.c,
            ], 'Copy command executed'),
          ),
          const SizedBox(height: 12),
          _buildComboCard(
            Platform.isMacOS ? 'Cmd+V (Paste)' : 'Ctrl+V (Paste)',
            'Paste clipboard content',
            Icons.paste,
            Colors.orange,
            () => _performCustomCombo([
              Platform.isMacOS
                  ? UniversalKey.leftCommand
                  : UniversalKey.leftControl,
              UniversalKey.v,
            ], 'Paste command executed'),
          ),
          const SizedBox(height: 12),
          _buildComboCard(
            Platform.isMacOS ? 'Cmd+Z (Undo)' : 'Ctrl+Z (Undo)',
            'Undo last action',
            Icons.undo,
            Colors.purple,
            () => _performCustomCombo([
              Platform.isMacOS
                  ? UniversalKey.leftCommand
                  : UniversalKey.leftControl,
              UniversalKey.z,
            ], 'Undo command executed'),
          ),
          const SizedBox(height: 12),
          _buildComboCard(
            Platform.isMacOS ? 'Cmd+S (Save)' : 'Ctrl+S (Save)',
            'Save current document',
            Icons.save,
            Colors.teal,
            () => _performCustomCombo([
              Platform.isMacOS
                  ? UniversalKey.leftCommand
                  : UniversalKey.leftControl,
              UniversalKey.s,
            ], 'Save command executed'),
          ),
          const SizedBox(height: 12),
          _buildComboCard(
            Platform.isMacOS ? 'Cmd+F (Find)' : 'Ctrl+F (Find)',
            'Open find dialog',
            Icons.search,
            Colors.indigo,
            () => _performCustomCombo([
              Platform.isMacOS
                  ? UniversalKey.leftCommand
                  : UniversalKey.leftControl,
              UniversalKey.f,
            ], 'Find command executed'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Platform Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Platform', Platform.operatingSystem),
                  const Divider(),
                  _buildInfoRow(
                    'Modifier Key',
                    Platform.isMacOS ? 'Command (⌘)' : 'Control (Ctrl)',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Total Keys Supported',
                    '${UniversalKey.values.length} keys',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComboCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.play_arrow),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
