import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  // --- MOCK DATA ---
  final Map<String, String> _userData = {
    'name': 'Devid',
    'email': 'hello.88@gmail.com',
    'password': '●●●●●●●●●●',
    'address': 'Flat 5A, House 740, Road 10, G Block, Basundhara R/A, Dhaka',
  };

  // --- STATE MANAGEMENT ---
  bool _isEditing = false;
  bool _isPasswordVisible = false;
  File? _profileImageFile;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _userData['name']);
    _emailController = TextEditingController(text: _userData['email']);
    _passwordController = TextEditingController(text: _userData['password']);
    _addressController = TextEditingController(text: _userData['address']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        _userData['name'] = _nameController.text;
        _userData['email'] = _emailController.text;
        _userData['address'] = _addressController.text;
      }
      _isEditing = !_isEditing;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
    if (mounted) Navigator.of(context).pop();
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Upload Image'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Info'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _isEditing ? _showImagePickerOptions : null,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImageFile != null
                        ? FileImage(_profileImageFile!)
                        : const AssetImage('assets/profile_pic.png') as ImageProvider,
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildInfoField(
              label: 'User Name',
              controller: _nameController,
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Email Address',
              controller: _emailController,
              icon: Icons.email,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Password',
              controller: _passwordController,
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Address',
              controller: _addressController,
              icon: Icons.location_on,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  // ## THIS WIDGET IS UPDATED ##
  Widget _buildInfoField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !_isEditing,
      obscureText: isPassword && !_isPasswordVisible,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        // This logic now shows the icon always for passwords,
        // but only makes it tappable when editing.
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
          onPressed: _isEditing
              ? () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          }
              : null, // Setting onPressed to null disables the button
        )
            : null,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: !_isEditing,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}