import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Import your login screen
import 'screens/registration_screen.dart'; // Import your registration screen
import 'screens/camera_registration.dart'; // Import your camera registration screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarriBiz Delivery Partner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => const LoginScreen(), // Your login screen
        '/registration': (context) => const RegistrationScreen(), // Your registration screen
        '/camera_registration': (context) => const CameraGuideScreen(), // Your camera registration screen
      },
    );
  }
}
