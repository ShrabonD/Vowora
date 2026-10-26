import 'package:flutter/material.dart';

class ConferenceFoodPage extends StatelessWidget {
  const ConferenceFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant & Food')),
      body: const Center(
        child: Text(
          'Welcome to Restaurant & Food',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
