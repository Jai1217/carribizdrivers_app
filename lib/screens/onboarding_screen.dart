import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import your login screen here

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startAutoScroll();
  }

  void startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < 2) { // Now allows for three pages (0, 1, 2)
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < 2) { // Now allows for three pages (0, 1, 2)
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the LoginScreen if on the last page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildOnboardingPage(
            context,
            "assets/onboardingone.png", // Image asset for the first screen
            "Secure and Transparent Earnings",
            "Plus additional joining and referral incentives",
            const Color(0xFF6F00FF), // Background color for the first screen
          ),
          _buildOnboardingPage(
            context,
            "assets/image2.png", // Image asset for the second screen
            "Flexible working hours",
            "Work at your convenience",
            const Color(0xFF00BFFF), // Background color for the second screen
          ),
          _buildOnboardingPage(
            context,
            "assets/image3.png", // Image asset for the third screen
            "Easy to use app",
            "Seamless experience for all users",
            const Color(0xFFFF6347), // Background color for the third screen
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(BuildContext context, String imagePath, String title, String subtitle, Color backgroundColor) {
    return Container(
      color: backgroundColor, // Set the background color based on the parameter
      child: Column(
        children: [
          const Spacer(), // Spacer for top alignment
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
              Image.asset(imagePath, width: 120, height: 120),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const Spacer(), // Spacer for bottom alignment
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40), // Add padding on the sides
                  child: ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: const Color(0xFF6F00FF),
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text("Next", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) { // Update number of indicators based on pages
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: _currentPage == index ? 12 : 8,
                height: _currentPage == index ? 12 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? Colors.white : Colors.white54,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
