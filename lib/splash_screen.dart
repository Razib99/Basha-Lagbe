import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.grey,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          // FIX 1: Make the column take up the full width to allow centering.
          child: SizedBox(
            width: double.infinity,
            child: Column(
              // FIX 1: Center all items horizontally on the screen.
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 50),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 58,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      height: 1.2,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'RENT A\n',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: 'HOME ',
                        style: TextStyle(color: Color(0xFF0A8ED9)),
                      ),
                      TextSpan(
                        text: 'NOW',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/splash_vector.png', // We'll fix the path issue next
                  width: 430,
                  height: 430,
                ),
                GestureDetector(
                  onTap: () {
                    print("Get Started Tapped!");
                  },
                  child: Container(
                    width: 356,
                    height: 51,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // FIX 2: Change the gradient direction
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFA0DAFB), // Light color
                          Color(0xFF0A8ED9), // Dark color
                        ],
                        begin: Alignment.topCenter,   // <-- CHANGED
                        end: Alignment.bottomCenter,  // <-- CHANGED
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'GET STARTED',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}