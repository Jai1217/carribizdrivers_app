// onboarding_main.dart

import 'package:carribizdrivers_app/onboarding/onboarding_file1.dart';
import 'package:carribizdrivers_app/onboarding/onboarding_file2.dart';
import 'package:carribizdrivers_app/onboarding/onboarding_file3.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carribizdrivers_app/permissions/location_permission_screen.dart'; // Import the new screen

class OnboardingMain extends StatefulWidget {
  const OnboardingMain({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingMainState createState() => _OnboardingMainState();
}

class _OnboardingMainState extends State<OnboardingMain> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      if (_currentPage < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Navigate to the Location Permission Screen after onboarding
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LocationPermissionScreen()),
        );
      }
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              OnboardingScreen1(onNextPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )),
              OnboardingScreen2(onNextPressed: () => _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              )),
              OnboardingScreen3(onGetStartedPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LocationPermissionScreen()),
                );
              }),
            ],
          ),
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
