import 'package:flutter/material.dart';

class ConferenceSoundPage extends StatelessWidget {
  const ConferenceSoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound & Screens')),
      body: const Center(
        child: Text(
          'Welcome to Sound & Screens',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
