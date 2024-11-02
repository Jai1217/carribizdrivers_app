// location_permission_screen.dart
import 'package:carribizdrivers_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LocationPermissionScreenState createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // If permissions are granted, navigate to the next screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else if (status.isDenied) {
      // Handle when permissions are denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required to use this app.')),
      );
    }
    // Add further handling for other status (like permanently denied, etc.) as needed.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: const Center(
        child: Text(''),
      ),
    );
  }
}