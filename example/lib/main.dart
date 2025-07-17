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
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Column(
          children: [
            TextButton(
              onPressed: () {
                BixatKeyMouse.moveMouseAbs(x: 100, y: 100);
                BixatKeyMouse.pressMouseButton(button: 2); // Left button
              },
              child: Text("Movemouse"),
            ),
          ],
        ),
      ),
    );
  }
}
