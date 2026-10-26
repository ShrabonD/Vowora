import 'package:flutter/material.dart';

class ConferenceDecorationPage extends StatelessWidget {
  const ConferenceDecorationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Decoration')),
      body: const Center(
        child: Text(
          'Welcome to Decoration',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
