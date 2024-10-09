import 'package:flutter/material.dart';
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
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/otp': (context) => OTPScreen(
          mobileNumber: ModalRoute.of(context)!.settings.arguments as String,
        ),
      },
    );
  }
}