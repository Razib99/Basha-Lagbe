import 'package:flutter/material.dart';
import 'login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Account',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 40),
              const Text('General', style: TextStyle(fontFamily: 'Almarai', fontSize: 13, color: Color(0xFFA8A7A7))),
              const SizedBox(height: 10),
              _buildListTile(iconPath: 'assets/icon_personal.png', title: 'Personal Info', onTap: () {}),
              _buildListTile(iconPath: 'assets/icon_security.png', title: 'Security', onTap: () {}),
              _buildListTile(iconPath: 'assets/icon_settings.png', title: 'Settings', onTap: () {}),
              const SizedBox(height: 40),
              const Text('About', style: TextStyle(fontFamily: 'Almarai', fontSize: 13, color: Color(0xFFA8A7A7))),
              const SizedBox(height: 10),
              _buildListTile(iconPath: 'assets/icon_help.png', title: 'Help Center', onTap: () {}),
              _buildListTile(iconPath: 'assets/icon_privacy.png', title: 'Privacy Policy', onTap: () {}),
              _buildListTile(iconPath: 'assets/icon_about.png', title: 'About', onTap: () {}),
              _buildListTile(
                iconPath: 'assets/icon_logout.png',
                title: 'Log Out',
                color: const Color(0xFFDF3E3E),
                onTap: () {
                  // This will remove all screens and go back to the login page
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widget for each item in the list
  Widget _buildListTile({required String iconPath, required String title, Color? color, required VoidCallback onTap}) {
    final itemColor = color ?? Colors.black;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(iconPath, color: itemColor, width: 24, height: 24),
      title: Text(title, style: TextStyle(fontFamily: 'Inter', color: itemColor)),
      trailing: Icon(Icons.chevron_right, color: itemColor),
      onTap: onTap,
    );
  }

  // Widget for the profile header section
  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Devid', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
            SizedBox(height: 4),
            Text('hello.88@gmail.com', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFA8A8A8))),
          ],
        ),
        Container(
          width: 63,
          height: 63,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
            image: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/profile_pic.png')),
          ),
        ),
      ],
    );
  }
}