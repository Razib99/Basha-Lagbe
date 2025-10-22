import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'personal_info_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _userName = 'Loading...';
  String _userEmail = '...';
  String? _profilePictureUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (mounted && userData.exists) {
        setState(() {
          _userName = userData.data()?['firstName'] ?? 'User';
          _userEmail = userData.data()?['email'] ?? 'No email';
          _profilePictureUrl = userData.data()?['profilePictureUrl'];
        });
      }
    }
  }

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
              _buildListTile(
                iconPath: 'assets/icon_personal.png',
                title: 'Personal Info',
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => const PersonalInfoScreen()));
                  _fetchUserData();
                },
              ),
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
                  FirebaseAuth.instance.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userName,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              _userEmail,
              style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFA8A8A8)),
            ),
          ],
        ),
        Container(
          width: 63,
          height: 63,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
            image: DecorationImage(
              fit: BoxFit.cover,
              // Show network image or default asset image
              image: (_profilePictureUrl != null
                  ? NetworkImage(_profilePictureUrl!)
                  : const AssetImage('assets/default_profile_pic.png')) // Use your new default image
              as ImageProvider,
            ),
          ),
        ),
      ],
    );
  }

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
}