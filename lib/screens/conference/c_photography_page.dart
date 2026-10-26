import 'package:flutter/material.dart';

class ConferencePhotographyPage extends StatelessWidget {
  const ConferencePhotographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photography')),
      body: const Center(
        child: Text(
          'Welcome to Photography',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
