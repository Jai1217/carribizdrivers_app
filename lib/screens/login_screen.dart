import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showWebView = false;
  late WebViewController _webViewController;
  String _authMode = ''; // 'login' or 'register'

  // Azure AD B2C Configuration
  final String tenantName = 'carribiz';
  final String signInPolicy = 'B2C_1_signin1';
  final String signUpPolicy = 'B2C_1_signup1';
  final String clientId = '7709dd9b-23fc-412c-90e9-3f5c492d9148';
  final String redirectUri = 'msauth://com.example.carribizdrivers_app/N1LcmPjVpBMZDsTjlIdSU3nCjOU%3D';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith(redirectUri)) {
            // Handle successful authentication
            _handleAuthenticationSuccess(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));
  }

  String _buildAuthUrl(String policy) {
    return 'https://$tenantName.b2clogin.com/$tenantName.onmicrosoft.com/$policy/oauth2/v2.0/authorize'
        '?client_id=$clientId'
        '&response_type=code'
        '&redirect_uri=${Uri.encodeComponent(redirectUri)}'
        '&response_mode=query'
        '&scope=openid'
        '&prompt=login';
  }

  void _startAuthentication(String mode) {
    setState(() {
      _authMode = mode;
      _showWebView = true;
    });

    final policy = mode == 'login' ? signInPolicy : signUpPolicy;
    final authUrl = _buildAuthUrl(policy);
    _webViewController.loadRequest(Uri.parse(authUrl));
  }

  void _handleAuthenticationSuccess(String url) {
    // Parse authentication response
    final uri = Uri.parse(url);
    final code = uri.queryParameters['code'];

    if (code != null) {
      // Close WebView
      setState(() {
        _showWebView = false;
      });

      // Navigate to registration screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RegistrationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showWebView) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_authMode == 'login' ? 'Sign In' : 'Sign Up'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _showWebView = false;
              });
            },
          ),
        ),
        body: WebViewWidget(controller: _webViewController),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Full-width image without padding
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 250, // Adjusted height for better aspect ratio
              child: Image.asset(
                'assets/images/driversigninpage.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Log in or Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Verify your mobile number to access our \nservices',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 30),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => _startAuthentication('login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(160, 34, 45, 45),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New user?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Register with CarriBiz Driver App by clicking below button',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => _startAuthentication('register'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color.fromRGBO(160, 34, 45, 45),
                              width: 2,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Color.fromRGBO(160, 34, 45, 45),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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