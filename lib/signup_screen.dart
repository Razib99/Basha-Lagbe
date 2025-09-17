import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/signup_background.png', // <-- Use your background image file name
            fit: BoxFit.cover,
          ),
          // Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 1.0], // Controls gradient start and end
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Arrow
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 20),
                    // "Sign up" Title
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 64,
                        fontWeight: FontWeight.w600, // SemiBold
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Input Fields
                    _buildTextField(hint: 'First Name'),
                    const SizedBox(height: 15),
                    _buildTextField(hint: 'Last Name'),
                    const SizedBox(height: 15),
                    _buildTextField(hint: 'Email address'),
                    const SizedBox(height: 15),
                    _buildTextField(hint: 'Phone'),
                    const SizedBox(height: 15),
                    _buildTextField(hint: 'Password', obscure: true),
                    const SizedBox(height: 20),
                    // "Already have an account?" Text
                    Center(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 17,
                            fontWeight: FontWeight.w300, // Light
                            color: Colors.white,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A8ED9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // "or continue with" Divider
                    _buildDivider(),
                    const SizedBox(height: 30),
                    // Social Login Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialButton('assets/google_logo.png'),
                        _buildSocialButton('assets/facebook_logo.png'),
                        _buildSocialButton('assets/apple_logo.png'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    // Continue Button
                    _buildContinueButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for TextFields
  Widget _buildTextField({required String hint, bool obscure = false}) {
    return Container(
      width: 345,
      height: 47,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Raleway',
            fontSize: 17,
            fontWeight: FontWeight.w300, // Light
            color: Color(0xFFAFAFAF),
          ),
        ),
      ),
    );
  }

  // Helper widget for the "or continue with" divider
  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: Colors.white, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'or continue with',
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 17,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white, thickness: 1)),
      ],
    );
  }

  // Helper widget for Social Login Buttons
  Widget _buildSocialButton(String imagePath) {
    return Container(
      width: 79,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Image.asset(imagePath),
      ),
    );
  }

  // Helper widget for the Continue Button
  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: () {
        // TODO: Add navigation to the next page
      },
      child: Container(
        width: 345,
        height: 51,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Text(
            'Continue',
            style: TextStyle(
              fontFamily:
              'Inter', // Using Inter from previous screen as per button style
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}