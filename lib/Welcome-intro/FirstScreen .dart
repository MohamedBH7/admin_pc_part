import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PC Parts Store'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('lib/assets/pc.png'),
            ),
            const Text(
              'Secure and Reliable',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Our app ensures secure transactions with the latest encryption to protect your information. We offer the newest PC parts as soon as they are available.',
                textAlign: TextAlign.center,
              ),
            ),
            const Text(
              'Gaming Gear',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Find high-performance parts for your gaming rig. Get expert recommendations and join our community of gaming enthusiasts.',
                textAlign: TextAlign.center,
              ),
            ),
            // Add more widgets for other app features as needed
          ],
        ),
      ),
    );
  }
}
