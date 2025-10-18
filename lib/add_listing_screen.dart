import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddListingScreen extends StatefulWidget {
  final String? propertyIdToEdit;
  const AddListingScreen({super.key, this.propertyIdToEdit});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bedsController = TextEditingController();
  final _bathsController = TextEditingController();
  final _balconiesController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();

  Map<String, bool> _categories = {
    'House': false, 'Apartment': false, 'Room': false,
    'Maid': false, 'Electricians': false, 'Car Parking': false,
    'Family': false, 'Bachelor': false,
  };

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  bool get _isEditing => widget.propertyIdToEdit != null;

  @override
  void initState() {
    super.initState();
    // If we are in edit mode, fetch the existing data
    if (_isEditing) {
      _fetchPropertyData();
    }
  }

  // ## Function to fetch data for editing ##
  Future<void> _fetchPropertyData() async {
    if (widget.propertyIdToEdit == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('properties').doc(widget.propertyIdToEdit).get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = data['name'] ?? '';
        _priceController.text = (data['price'] ?? 0).toString();
        _descriptionController.text = data['description'] ?? '';
        _bedsController.text = (data['beds'] ?? 0).toString();
        _bathsController.text = (data['baths'] ?? 0).toString();
        _balconiesController.text = (data['balconies'] ?? 0).toString();
        _addressController.text = data['location'] ?? '';
        _contactController.text = data['contact'] ?? '';

        final fetchedCategories = List<String>.from(data['categories'] ?? []);
        Map<String, bool> updatedCategories = {};
        _categories.forEach((key, value) {
          updatedCategories[key] = fetchedCategories.contains(key);
        });

        setState(() {
          _categories = updatedCategories;
        });
      }
    } catch (e) {
      print("Failed to fetch property data: $e");
    }
  }

  @override
  void dispose() { /* ... same as before ... */ }
  Future<void> _pickImages() async { /* ... same as before ... */ }
  Future<List<String>> _uploadImages(String propertyId) async {
    List<String> imageUrls = [];
    for (var imageFile in _selectedImages) {
      // Create a reference for each image in Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('property_images')
          .child(propertyId)
          .child('${DateTime.now().millisecondsSinceEpoch}-${imageFile.name}');

      // Upload the file
      await ref.putFile(File(imageFile.path));

      // Get the download URL
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls; // This line ensures the function always returns a list
  }

  void _submitListing() async { /* ...  ... */ }

  // ## Function to delete a post ##
  void _deleteListing() async {
    if (!_isEditing) return;

    // Show a confirmation dialog
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to permanently delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('properties').doc(widget.propertyIdToEdit).delete();
        if (mounted) {
          // Pop twice to go back to the list page
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete post: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Post' : 'New Post', style: const TextStyle(fontFamily: 'Almarai', fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTextField(controller: _nameController, hintText: 'Property Name'),
                _buildPostButton(),

                // ## Show delete button only in edit mode ##
                if (_isEditing) ...[
                  const SizedBox(height: 16),
                  _buildDeleteButton(),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets for the new UI ---

  Widget _buildTextField({required TextEditingController controller, required String hintText, double hintFontSize = 12, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w200, fontSize: hintFontSize, color: const Color(0xFF898989)),
        filled: true,
        fillColor: const Color(0xFFF3F3F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0A8ED9), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF0A8ED9), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.2, // Adjust aspect ratio for better spacing
        children: _categories.keys.map((String key) {
          return InkWell(
            onTap: () {
              setState(() {
                _categories[key] = !_categories[key]!;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                Checkbox(
                  value: _categories[key],
                  onChanged: (bool? value) {
                    setState(() {
                      _categories[key] = value!;
                    });
                  },
                  activeColor: const Color(0xFF5E5E5E), // Set the checkbox color
                ),
                Text(key, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF5E5E5E))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageUploader() {
    return Column(
      children: [
        if (_selectedImages.isNotEmpty) ...[
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: _selectedImages.length,
            itemBuilder: (context, index) {
            },
          ),
          const SizedBox(height: 8),
        ],
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF0A8ED9), width: 1),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Color(0xFF898989), size: 16),
                SizedBox(width: 8),
                Text('Add Image', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w200, fontSize: 12, color: Color(0xFF898989))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostButton() {
    return GestureDetector(
      onTap: _submitListing,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Text(_isEditing ? 'Update Post' : 'Post', style: const TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );
  }

  // ## Delete Button Widget ##
  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _deleteListing,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('Delete Post'),
      ),
    );
  }
}