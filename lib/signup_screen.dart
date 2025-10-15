import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String userId = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'createdAt': Timestamp.now(),
        });

        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading indicator

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const SignUpSuccessDialog(),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        });

      } catch (e) { // This now catches ANY error (Auth or Firestore)
        if (mounted) Navigator.of(context).pop(); // Make sure loading dialog always closes

        print('Error during sign up: $e'); // Print the specific error

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign up failed. Please try again.'),
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
                      const SizedBox(height: 20),
                      const Text('Sign up', style: TextStyle(fontFamily: 'Raleway', fontSize: 64, fontWeight: FontWeight.w600, color: Colors.white)),
                      const SizedBox(height: 30),
                      _buildTextFormField(controller: _firstNameController, hint: 'First Name'),
                      const SizedBox(height: 15),
                      _buildTextFormField(controller: _lastNameController, hint: 'Last Name'),
                      const SizedBox(height: 15),
                      _buildTextFormField(controller: _emailController, hint: 'Email address'),
                      const SizedBox(height: 15),
                      _buildTextFormField(controller: _phoneController, hint: 'Phone'),
                      const SizedBox(height: 15),
                      _buildTextFormField(controller: _passwordController, hint: 'Password', obscure: true),
                      const SizedBox(height: 20),
                      _buildLoginLink(),
                      const SizedBox(height: 30),
                      _buildDivider(),
                      const SizedBox(height: 30),
                      _buildSocialButtons(),
                      const SizedBox(height: 40),
                      _buildContinueButton(),
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

  Widget _buildLoginLink() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: FontWeight.w300, color: Colors.white),
          children: <TextSpan>[
            const TextSpan(text: 'Already have an account? '),
            TextSpan(
              text: 'Log In',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0A8ED9)),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
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

  Widget _buildContinueButton() {
    return GestureDetector(
      onTap: _signUp,
      child: Container(
        width: 345, height: 51,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: const LinearGradient(colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: const Center(child: Text('Continue', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: Colors.white))),
      ),
    );
  }
}

// SignUpSuccessDialog class
class SignUpSuccessDialog extends StatelessWidget {
  const SignUpSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Image.asset(
          'assets/signup_popup_image.png',
        ),
      ),
    );
  }
}