import 'package:flutter/material.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shell Page'),
      ),
      body: const Center(
        child: Text('This is the Shell Page'),
      ),
    );
  }
}
