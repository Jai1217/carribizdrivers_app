import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/otp_screen.dart';
import 'onboarding/onboarding_file1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carribiz Users App',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      home: const OnboardingScreen1(), // This will be the first screen when the app opens
      routes: {
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => OTPScreen(
          mobileNumber: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}