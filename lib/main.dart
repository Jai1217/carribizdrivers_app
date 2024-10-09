import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart'; // Import OnboardingScreen
import 'screens/login_screen.dart'; // Import your LoginScreen
import 'screens/otp_screen.dart'; // Import your OTPScreen

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
        scaffoldBackgroundColor: Colors.white, // Updated background color
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const OnboardingScreen(), // Set OnboardingScreen as the initial screen
        '/login': (context) => const LoginScreen(),
        '/otp': (context) => OTPScreen(
          mobileNumber: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}
