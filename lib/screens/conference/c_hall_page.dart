import 'package:flutter/material.dart';

class ConferenceHallPage extends StatelessWidget {
  const ConferenceHallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore and Book Hall')),
      body: const Center(
        child: Text(
          'Welcome to Explore and Book Hall',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
