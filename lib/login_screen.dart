import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _logIn() async {
    if (_formKey.currentState!.validate()) {
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Sign in the user with Firebase
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // If sign-in is successful, navigate to the home screen
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
                (Route<dynamic> route) => false,
          );
        }

      } on FirebaseAuthException catch (e) {
        // If there's an error, close the loading indicator
        if (mounted) Navigator.of(context).pop();

        // Show an error message
        String errorMessage = 'Login failed. Please check your credentials.';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else if (e.code == 'invalid-credential') {
          errorMessage = 'Invalid credentials. Please check your email and password.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/signup_background.png', fit: BoxFit.cover),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 40),
                      const Text('Log in', style: TextStyle(fontFamily: 'Raleway', fontSize: 64, fontWeight: FontWeight.w600, color: Colors.white)),
                      const Text('Please enter your email & password to log in', style: TextStyle(fontFamily: 'Raleway', fontSize: 16, color: Colors.white70)),
                      const SizedBox(height: 40),
                      _buildTextFormField(controller: _emailController, hint: 'Email address'),
                      const SizedBox(height: 15),
                      _buildTextFormField(controller: _passwordController, hint: 'Password', obscure: true),
                      const SizedBox(height: 15),
                      _buildOptionsRow(),
                      const SizedBox(height: 20),
                      _buildSignUpLink(),
                      const SizedBox(height: 30),
                      _buildDivider(),
                      const SizedBox(height: 30),
                      _buildSocialButtons(),
                      const SizedBox(height: 40),
                      _buildLoginButton(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---
  Widget _buildTextFormField({required TextEditingController controller, required String hint, bool obscure = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintText: hint,
        hintStyle: const TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: FontWeight.w300, color: Color(0xFFAFAFAF)),
        errorStyle: const TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hint';
        }
        return null;
      },
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              checkColor: Colors.blue,
              fillColor: WidgetStateProperty.all(Colors.white),
            ),
            const Text('Remember me', style: TextStyle(color: Colors.white)),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Forgot password?', style: TextStyle(color: Color(0xFF0A8ED9))),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: FontWeight.w300, color: Colors.white),
          children: <TextSpan>[
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Sign up',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A8ED9)),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(children: [Expanded(child: Divider(color: Colors.white, thickness: 1)), Padding(padding: EdgeInsets.symmetric(horizontal: 8.0), child: Text('or continue with', style: TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: FontWeight.w300, color: Colors.white))), Expanded(child: Divider(color: Colors.white, thickness: 1))]);
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialButton('assets/google_logo.png'),
        _buildSocialButton('assets/facebook_logo.png'),
        _buildSocialButton('assets/apple_logo.png'),
      ],
    );
  }

  Widget _buildSocialButton(String imagePath) {
    return Container(width: 79, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Padding(padding: const EdgeInsets.all(12.0), child: Image.asset(imagePath)));
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _logIn,
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
            'Log in',
            style: TextStyle(
              fontFamily: 'Inter',
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