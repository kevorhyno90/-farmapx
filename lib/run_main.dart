import 'package:flutter/material.dart';

void main() => runApp(const RunApp());

class RunApp extends StatelessWidget {
  const RunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temporary Runner',
      home: Scaffold(
        appBar: AppBar(title: const Text('Temporary Runner')),
        body: const Center(child: Text('Minimal app is running — web server OK')),
      ),
    );
  }
}
