// onboarding_file2.dart

import 'package:flutter/material.dart';

class OnboardingScreen2 extends StatelessWidget {
  final VoidCallback onNextPressed;

  const OnboardingScreen2({super.key, required this.onNextPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFA5D6A7), Color(0xFF388E3C)],
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
                    '',
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
                      width: MediaQuery.of(context).size.width * (0.3 + (i * 0.1)),
                      height: MediaQuery.of(context).size.width * (0.3 + (i * 0.1)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.01 + (i * 0.01)),
                      ),
                    ),
                  Image.asset(
                    'assets/images/onboardings.png',
                    width: 200, // Fixed width of 216 pixels
                    height: 200, // Fixed height of 216 pixels
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const Text(
                    'We Care for your Earnings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Early payouts for all our rides',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30), // Increased spacing
                  ElevatedButton(
                    onPressed: onNextPressed,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color.fromRGBO(160, 34, 45, 45),
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Optional to move the button up further
          ],
        ),
      ),
    );
  }
}
