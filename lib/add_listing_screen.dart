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
  };
  String? _occupantType;
  bool _occupantTypeValidationFailed = false;

  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool get _isEditing => widget.propertyIdToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _fetchPropertyData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _bedsController.dispose();
    _bathsController.dispose();
    _balconiesController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

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

        setState(() {
          _occupantType = data['occupantType'];
          final fetchedCategories = List<String>.from(data['categories'] ?? []);
          _categories.forEach((key, value) {
            _categories[key] = fetchedCategories.contains(key);
          });
        });
      }
    } catch (e) {
      print("Failed to fetch property data: $e");
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<List<String>> _uploadImages(String propertyId) async {
    List<String> imageUrls = [];
    for (var imageFile in _selectedImages) {
      final ref = FirebaseStorage.instance.ref().child('property_images').child(propertyId).child('${DateTime.now().millisecondsSinceEpoch}-${imageFile.name}');
      await ref.putFile(File(imageFile.path));
      final url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }

  void _submitListing() async {
    setState(() {
      _occupantTypeValidationFailed = _occupantType == null;
    });

    final selectedCategories = _categories.entries.where((e) => e.value).map((e) => e.key).toList();

    if (_formKey.currentState!.validate() && !_occupantTypeValidationFailed) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));

      try {
        final posterData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final posterName = posterData.data()?['firstName'] ?? 'Anonymous';
        final propertyId = widget.propertyIdToEdit ?? FirebaseFirestore.instance.collection('properties').doc().id;
        final imageUrls = await _uploadImages(propertyId);

        final data = {
          'name': _nameController.text.trim(),
          'price': int.tryParse(_priceController.text.trim()) ?? 0,
          'description': _descriptionController.text.trim(),
          'beds': int.tryParse(_bedsController.text.trim()) ?? 0,
          'baths': int.tryParse(_bathsController.text.trim()) ?? 0,
          'balconies': int.tryParse(_balconiesController.text.trim()) ?? 0,
          'location': _addressController.text.trim(),
          'contact': _contactController.text.trim(),
          'categories': selectedCategories,
          'occupantType': _occupantType,
          'postedBy': user.uid,
          'posterName': posterName,
          'createdAt': Timestamp.now(),
          'galleryImageUrls': imageUrls,
          'mainImageUrl': imageUrls.isNotEmpty ? imageUrls[0] : null,
        };

        await FirebaseFirestore.instance.collection('properties').doc(propertyId).set(data, SetOptions(merge: true));

        if (mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to post listing: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _deleteListing() async {
    if (!_isEditing) return;

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to permanently delete this listing?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('properties').doc(widget.propertyIdToEdit).delete();
        if (mounted) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete post: $e'), backgroundColor: Colors.red));
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                _buildTextField(controller: _nameController, hintText: 'Property Name'),
                const SizedBox(height: 16),
                _buildTextField(controller: _priceController, hintText: 'Rent Price (/mo)', keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(controller: _descriptionController, hintText: 'Description', maxLines: 4),
                const SizedBox(height: 24),
                const Text('Property Info', style: TextStyle(fontFamily: 'Almarai', fontSize: 12, color: Color(0xFF5E5E5E))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildTextField(controller: _bedsController, hintText: 'Beds', hintFontSize: 10, keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(controller: _bathsController, hintText: 'Baths', hintFontSize: 10, keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField(controller: _balconiesController, hintText: 'Balconies', hintFontSize: 10, keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(controller: _addressController, hintText: 'Full Address'),
                const SizedBox(height: 16),
                _buildTextField(controller: _contactController, hintText: 'Contact Number', keyboardType: TextInputType.phone),
                const SizedBox(height: 24),
                const Text('Select Category', style: TextStyle(fontFamily: 'Almarai', fontSize: 12, color: Color(0xFF5E5E5E))),
                const SizedBox(height: 8),
                _buildCategorySelector(),
                const SizedBox(height: 24),
                const Text('Available for', style: TextStyle(fontFamily: 'Almarai', fontSize: 12, color: Color(0xFF5E5E5E))),
                const SizedBox(height: 8),
                _buildOccupantTypeSelector(),
                const SizedBox(height: 24),
                const Text('Add Image', style: TextStyle(fontFamily: 'Almarai', fontSize: 12, color: Color(0xFF5E5E5E))),
                const SizedBox(height: 8),
                _buildImageUploader(),
                const SizedBox(height: 24),
                _buildPostButton(),
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

  Widget _buildTextField({required TextEditingController controller, required String hintText, double hintFontSize = 12, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w200, fontSize: hintFontSize, color: const Color(0xFF898989)),
        filled: true,
        fillColor: const Color(0xF3F3F3),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0A8ED9), width: 1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF0A8ED9), width: 2)),
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
        childAspectRatio: 2.2,
        children: _categories.keys.map((String key) {
          return InkWell(
            onTap: () => setState(() => _categories[key] = !_categories[key]!),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(value: _categories[key], onChanged: (v) => setState(() => _categories[key] = v!), activeColor: const Color(0xFF5E5E5E)),
                Text(key, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFF5E5E5E))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOccupantTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _occupantTypeValidationFailed ? Colors.red : Colors.transparent, width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: RadioListTile<String>(title: const Text('Family'), value: 'Family', groupValue: _occupantType, onChanged: (v) => setState(() => _occupantType = v))),
          Expanded(child: RadioListTile<String>(title: const Text('Bachelor'), value: 'Bachelor', groupValue: _occupantType, onChanged: (v) => setState(() => _occupantType = v))),
        ],
      ),
    );
  }

  Widget _buildImageUploader() {
    return Column(
      children: [
        if (_selectedImages.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: _selectedImages.length,
            itemBuilder: (context, index) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(_selectedImages[index].path), width: double.infinity, height: double.infinity, fit: BoxFit.cover)),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImages.removeAt(index)),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xF3F3F3),
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
          gradient: const LinearGradient(colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Text(_isEditing ? 'Update Post' : 'Post', style: const TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );
  }

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