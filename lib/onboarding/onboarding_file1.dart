// onboarding_file1.dart

import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  final VoidCallback onNextPressed;

  const OnboardingScreen1({super.key, required this.onNextPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.red[900]!, Colors.red[400]!],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, right: 20.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  child: const Text(
                    'English',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    // Implement language change functionality
                  },
                ),
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (var i = 5; i > 0; i--)
                    Container(
                      width: MediaQuery.of(context).size.width * (1.2 - (i * 0.1)),
                      height: MediaQuery.of(context).size.width * (1.2 - (i * 0.1)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1 - (i * 0.015)),
                      ),
                    ),
                  Image.asset(
                    'assets/images/onboarding1.png',
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Work within your own area',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Short distance and quick deliveries within your area',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onNextPressed,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}