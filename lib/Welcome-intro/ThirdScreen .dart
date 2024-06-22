import 'package:flutter/material.dart';
import '../Login/Login.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Third Screen"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to the login page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: const Text("Get Started"),
          ),
        ],
      ),
    );
  }
}
