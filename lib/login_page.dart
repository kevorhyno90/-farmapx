import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    // Simple stub: accept any non-empty credentials
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      // show a small visual confirmation so we can verify the login path
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(const SnackBar(content: Text('Logging in...')));
      // delay briefly so the SnackBar is visible in release builds, then navigate
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter email and password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _login, child: const Text('Login'))
        ]),
      ),
    );
  }
}
