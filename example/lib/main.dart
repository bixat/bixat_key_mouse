import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bixat_key_mouse/bixat_key_mouse.dart';

/// Key test result model
class KeyTestResult {
  final UniversalKey key;
  final String expectedLabel;
  final String? detectedLabel;
  final bool passed;
  final DateTime timestamp;

  KeyTestResult({
    required this.key,
    required this.expectedLabel,
    this.detectedLabel,
    required this.passed,
    required this.timestamp,
  });

  bool get isPending => detectedLabel == null && !passed;
}

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

  String _lastKeyLabel = 'Waiting for key press...';
  final FocusNode _keyboardFocusNode = FocusNode();

  // Key testing state
  final Map<UniversalKey, KeyTestResult> _keyTestResults = {};
  bool _isTestingKeys = false;
  int _currentTestIndex = 0;
  List<UniversalKey> _keysToTest = [];
  final Set<String> _detectedKeyLabels = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _xController.dispose();
    _yController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _updateStatus(String message, {bool isError = false}) {
    setState(() {
      _statusMessage = isError ? '❌ $message' : '✅ $message';
      _statusColor = isError ? Colors.red : Colors.green;
    });
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      setState(() {
        final keyLabel = event.logicalKey.debugName;
        _lastKeyLabel = 'Detected key: $keyLabel';
        _updateStatus(
          _lastKeyLabel,
          isError: _getKeyDisplayName(_selectedKey) != keyLabel,
        );
      });
    }
  }

  String _getKeyDisplayName(UniversalKey key) {
    return KeyCodeUtils.getKeyDisplayName(key);
  }

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
            Tab(icon: Icon(Icons.bug_report), text: 'Key Testing'),
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
                _buildKeyTestingTab(),
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
    return KeyboardListener(
      focusNode: _keyboardFocusNode..requestFocus(),
      onKeyEvent: _handleKeyEvent,
      child: SingleChildScrollView(
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
                return DropdownMenuItem(value: key, child: Text(key.name));
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
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
      ),
    );
  }

  Widget _buildQuickKeyButton(String label, UniversalKey key) {
    return ElevatedButton(
      onPressed: () {
        BixatKeyMouse.simulateKey(key: key, direction: Direction.click);
      },
      child: Text(label),
    );
  }

  List<UniversalKey> _getCommonKeys() {
    return UniversalKey.values;
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

  // ==================== Key Testing Tab ====================

  Widget _buildKeyTestingTab() {
    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent && _isTestingKeys) {
          // Use debugName instead of keyLabel for proper key identification
          final keyLabel =
              event.logicalKey.debugName ?? event.logicalKey.keyLabel;
          _detectedKeyLabels.add(keyLabel);

          if (_currentTestIndex < _keysToTest.length) {
            final currentKey = _keysToTest[_currentTestIndex];
            final expectedLabel = KeyCodeUtils.getKeyDisplayName(currentKey);
            setState(() {
              _keyTestResults[currentKey] = KeyTestResult(
                key: currentKey,
                expectedLabel: expectedLabel,
                detectedLabel: keyLabel,
                passed: keyLabel == expectedLabel,
                timestamp: DateTime.now(),
              );
            });
          }
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🧪 Automated Key Testing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Test all keys to detect which ones are missing or failing.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Note: Modifier keys (Ctrl, Shift, Alt, Cmd), function keys (F1-F20), '
                        'arrow keys, and media keys may not be detected correctly when simulated '
                        'programmatically. This is a limitation of keyboard event simulation, but '
                        'these keys DO work correctly in real applications.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Test Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Test Controls',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isTestingKeys ? null : _startKeyTesting,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start Testing All Keys'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isTestingKeys ? _stopKeyTesting : null,
                            icon: const Icon(Icons.stop),
                            label: const Text('Stop Testing'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _clearTestResults,
                            icon: const Icon(Icons.clear_all),
                            label: const Text('Clear Results'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _keyTestResults.isEmpty
                                ? null
                                : _exportTestResults,
                            icon: const Icon(Icons.download),
                            label: const Text('Export Results'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Test Progress
            if (_isTestingKeys) ...[
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Testing in progress... ($_currentTestIndex/${_keysToTest.length})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _keysToTest.isEmpty
                            ? 0
                            : _currentTestIndex / _keysToTest.length,
                      ),
                      const SizedBox(height: 8),
                      if (_currentTestIndex < _keysToTest.length)
                        Text(
                          'Current key: ${_keysToTest[_currentTestIndex].name}',
                          style: const TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Test Summary
            if (_keyTestResults.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        'Total Keys Tested',
                        '${_keyTestResults.length}',
                        Icons.keyboard,
                        Colors.blue,
                      ),
                      const Divider(),
                      _buildSummaryRow(
                        'Passed',
                        '${_keyTestResults.values.where((r) => r.passed).length}',
                        Icons.check_circle,
                        Colors.green,
                      ),
                      const Divider(),
                      _buildSummaryRow(
                        'Failed',
                        '${_keyTestResults.values.where((r) => !r.passed && !r.isPending).length}',
                        Icons.error,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Detailed Results
              const Text(
                'Detailed Results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Failed Keys
              if (_keyTestResults.values.any(
                (r) => !r.passed && !r.isPending,
              )) ...[
                Card(
                  color: Colors.red.shade50,
                  child: ExpansionTile(
                    title: Text(
                      'Failed Keys (${_keyTestResults.values.where((r) => !r.passed && !r.isPending).length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    leading: const Icon(Icons.error, color: Colors.red),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _keyTestResults.values
                            .where((r) => !r.passed && !r.isPending)
                            .length,
                        itemBuilder: (context, index) {
                          final result = _keyTestResults.values
                              .where((r) => !r.passed && !r.isPending)
                              .toList()[index];
                          return _buildResultTile(result);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Passed Keys
              if (_keyTestResults.values.any((r) => r.passed)) ...[
                Card(
                  color: Colors.green.shade50,
                  child: ExpansionTile(
                    title: Text(
                      'Passed Keys (${_keyTestResults.values.where((r) => r.passed).length})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    initiallyExpanded: false,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _keyTestResults.values
                            .where((r) => r.passed)
                            .length,
                        itemBuilder: (context, index) {
                          final result = _keyTestResults.values
                              .where((r) => r.passed)
                              .toList()[index];
                          return _buildResultTile(result);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile(KeyTestResult result) {
    final color = result.passed ? Colors.green : Colors.red;
    final icon = result.passed ? Icons.check_circle : Icons.error;

    return ListTile(
      dense: true,
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        result.key.name,
        style: const TextStyle(fontFamily: 'monospace'),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Expected: ${result.expectedLabel}'),
          Text(
            'Detected: ${result.detectedLabel ?? "Not detected"}',
            style: TextStyle(
              color: result.passed ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: result.passed
          ? const Icon(Icons.check, color: Colors.green)
          : const Icon(Icons.close, color: Colors.red),
    );
  }

  void _startKeyTesting() async {
    setState(() {
      _isTestingKeys = true;
      _currentTestIndex = 0;
      _keysToTest = UniversalKey.values.toList();
      _keyTestResults.clear();
      _detectedKeyLabels.clear();
    });

    _keyboardFocusNode.requestFocus();

    // Test each key
    for (int i = 0; i < _keysToTest.length; i++) {
      if (!_isTestingKeys) break;

      setState(() {
        _currentTestIndex = i;
      });

      final key = _keysToTest[i];
      final expectedLabel = KeyCodeUtils.getKeyDisplayName(key);

      // Clear detected labels before testing
      _detectedKeyLabels.clear();

      // Simulate the key press
      try {
        BixatKeyMouse.simulateKey(key: key, direction: Direction.click);
        await Future.delayed(const Duration(milliseconds: 100));

        // Check if the key was detected
        if (!_keyTestResults.containsKey(key)) {
          setState(() {
            _keyTestResults[key] = KeyTestResult(
              key: key,
              expectedLabel: expectedLabel,
              detectedLabel: _detectedKeyLabels.isEmpty
                  ? null
                  : _detectedKeyLabels.first,
              passed: false,
              timestamp: DateTime.now(),
            );
          });
        }
      } catch (e) {
        setState(() {
          _keyTestResults[key] = KeyTestResult(
            key: key,
            expectedLabel: expectedLabel,
            detectedLabel: 'Error: $e',
            passed: false,
            timestamp: DateTime.now(),
          );
        });
      }

      await Future.delayed(const Duration(milliseconds: 50));
    }

    setState(() {
      _isTestingKeys = false;
    });

    _updateStatus(
      'Key testing completed! ${_keyTestResults.values.where((r) => r.passed).length}/${_keyTestResults.length} passed',
    );
  }

  void _stopKeyTesting() {
    setState(() {
      _isTestingKeys = false;
    });
    _updateStatus('Key testing stopped');
  }

  void _clearTestResults() {
    setState(() {
      _keyTestResults.clear();
      _currentTestIndex = 0;
      _keysToTest.clear();
      _detectedKeyLabels.clear();
    });
    _updateStatus('Test results cleared');
  }

  void _exportTestResults() {
    final buffer = StringBuffer();
    buffer.writeln('Bixat Key Mouse - Key Testing Results');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Platform: ${Platform.operatingSystem}');
    buffer.writeln('=' * 80);
    buffer.writeln();

    final passed = _keyTestResults.values.where((r) => r.passed).length;
    final failed = _keyTestResults.values
        .where((r) => !r.passed && !r.isPending)
        .length;

    buffer.writeln('Summary:');
    buffer.writeln('  Total Keys Tested: ${_keyTestResults.length}');
    buffer.writeln('  Passed: $passed');
    buffer.writeln('  Failed: $failed');
    buffer.writeln(
      '  Success Rate: ${(passed / _keyTestResults.length * 100).toStringAsFixed(2)}%',
    );
    buffer.writeln();
    buffer.writeln('=' * 80);
    buffer.writeln();

    // Failed keys
    if (failed > 0) {
      buffer.writeln('FAILED KEYS ($failed):');
      buffer.writeln('-' * 80);
      for (final result in _keyTestResults.values.where(
        (r) => !r.passed && !r.isPending,
      )) {
        buffer.writeln('Key: ${result.key.name}');
        buffer.writeln('  Expected Label: ${result.expectedLabel}');
        buffer.writeln(
          '  Detected Label: ${result.detectedLabel ?? "Not detected"}',
        );
        buffer.writeln('  Timestamp: ${result.timestamp}');
        buffer.writeln();
      }
      buffer.writeln();
    }

    // Passed keys
    if (passed > 0) {
      buffer.writeln('PASSED KEYS ($passed):');
      buffer.writeln('-' * 80);
      for (final result in _keyTestResults.values.where((r) => r.passed)) {
        buffer.writeln('Key: ${result.key.name} - ${result.expectedLabel}');
      }
      buffer.writeln();
    }

    // Print to console
    print(buffer.toString());

    _updateStatus('Test results exported to console. Check the debug output.');
  }
}
