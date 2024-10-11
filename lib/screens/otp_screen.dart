import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '/widgets/custom_button.dart';
import 'registration_screen.dart'; // Import your registration screen here

class OTPScreen extends StatefulWidget {
  final String mobileNumber;

  const OTPScreen({super.key, required this.mobileNumber, required String phoneNumber, required Null Function() onVerificationSuccess});

  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  bool _isResendButtonEnabled = false;
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startTimer(); // Start the timer when the screen is loaded
  }

  void _startTimer() {
    setState(() {
      _isResendButtonEnabled = false;
      _secondsRemaining = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isResendButtonEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  // Build the OTP input boxes
  Widget _buildOTPBox(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          _otpController.text.length > index ? _otpController.text[index] : '',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Login with OTP',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Text(
              'To confirm your email address, please enter the OTP we sent to +91 ${widget.mobileNumber}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                _otpFocusNode.requestFocus();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildOTPBox(index)),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _otpController,
              focusNode: _otpFocusNode,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              maxLength: 6,
              onChanged: (value) {
                setState(() {});
                if (value.length == 6) {
                  _otpFocusNode.unfocus();
                }
              },
              style: const TextStyle(
                color: Colors.transparent,
                height: 0.01,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Login',
              onPressed: () {
                // Navigate to the registration screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationScreen(phoneNumber: '',)), // Replace with your registration screen widget
                );
              },
              color: const Color.fromRGBO(160, 34, 45, 45),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromRGBO(160, 34, 45, 45), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: _isResendButtonEnabled ? () {
                    _startTimer(); // Restart the timer
                  } : null,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: _isResendButtonEnabled ? const Color.fromRGBO(160, 34, 45, 45) : Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Valid for $_secondsRemaining seconds',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
