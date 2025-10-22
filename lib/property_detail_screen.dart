import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/gallery_popup.dart';
import 'add_listing_screen.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PropertyDetailScreen extends StatefulWidget {
  final String propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  bool _isExpanded = false;

  Future<void> _launchUrl(String scheme, String path) async {
    /* ...  ... */
  }

  Future<LatLng?> _getCoordinates(String address) async {
    const apiKey = 'bkoi_793dbfe013a6c4e5a943e362293253cda4c0192c24fcfb6b3eb52e84b7ab8b9a';
    final url = Uri.parse(
        'https://barikoi.xyz/v1/api/search/geocode/web/place?q=$address&api_key=$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 200 && data['place'] != null) {
          final place = data['place'];
          return LatLng(double.parse(place['latitude']),
              double.parse(place['longitude']));
        }
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('properties').doc(
            widget.propertyId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Property not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final currentUser = FirebaseAuth.instance.currentUser;
          final bool isOwner = currentUser != null &&
              currentUser.uid == data['postedBy'];

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildHeaderImage(context, data, isOwner: isOwner),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleSection(data),
                          const SizedBox(height: 16),
                          _buildAboutSection(data),
                          const SizedBox(height: 24),
                          _buildContactSection(data),
                          const SizedBox(height: 24),
                          _buildGallerySection(context, data),
                          const SizedBox(height: 24),
                          _buildLocationSection(data),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _buildBottomBar(data),
            ],
          );
        },
      ),
    );
  }


  Widget _buildHeaderImage(BuildContext context, Map<String, dynamic> data,
      {required bool isOwner}) {
    final imageUrl = data['mainImageUrl'] as String?;
    return SliverAppBar(
      expandedHeight: 250.0,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.5),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        if (isOwner)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddListingScreen(propertyIdToEdit: widget.propertyId),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: imageUrl != null && imageUrl.startsWith('http')
            ? Image.network(imageUrl, fit: BoxFit.cover)
            : Image.asset('assets/green_house_details.png', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildTitleSection(Map<String, dynamic> data) {
    final occupantType = data['occupantType'] as String?;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                data['name'] ?? 'No Title',
                style: const TextStyle(fontFamily: 'Raleway',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            if (occupantType != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  occupantType,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF898989),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(data['location'] ?? 'No Location', style: const TextStyle(
            fontFamily: 'Inter', fontSize: 11, color: Color(0xFF5E5E5E))),
        const SizedBox(height: 8),
        Text('${data['beds'] ?? 0} Bed    ${data['baths'] ??
            0} Bath   ${data['balconies'] ?? 0} Balcony',
            style: const TextStyle(fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5E5E5E))),
      ],
    );
  }

  Widget _buildAboutSection(Map<String, dynamic> data) {
    String description = data['description'] ?? 'No description available.';
    bool isLongText = description.length > 120;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          maxLines: _isExpanded ? null : 3,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: 'Inter',
              color: Colors.grey,
              height: 1.5,
              fontSize: 14),
        ),
        if (isLongText)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? 'Show Less' : 'Read More',
              style: const TextStyle(color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildContactSection(Map<String, dynamic> data) {
    String contactNumber = data['contact'] ?? '';
    String ownerId = data['postedBy'] ?? '';
    String category = (data['categories'] as List<dynamic>?)?.first ??
        'Property';

    if (ownerId.isEmpty) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(ownerId).get(),
      builder: (context, ownerSnapshot) {
        if (!ownerSnapshot.hasData || !ownerSnapshot.data!.exists) {
          return const CircularProgressIndicator();
        }
        final ownerData = ownerSnapshot.data!.data() as Map<String, dynamic>;
        final ownerName = ownerData['firstName'] ?? 'Owner';
        final ownerImageUrl = ownerData['profilePictureUrl'] as String?;

        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2)
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: (ownerImageUrl != null &&
                    ownerImageUrl.isNotEmpty)
                    ? NetworkImage(ownerImageUrl)
                    : const AssetImage(
                    'assets/default_profile_pic.png') as ImageProvider,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ownerName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Owner ($category)',
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: IconButton(
                  icon: const Icon(Icons.call, color: Colors.blue),
                  onPressed: () => _launchUrl('tel', contactNumber),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: IconButton(
                  icon: const Icon(Icons.message, color: Colors.blue),
                  onPressed: () => _launchUrl('sms', contactNumber),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGallerySection(BuildContext context, Map<String, dynamic> data) {
    final List galleryImages = data['galleryImageUrls'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gallery',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (galleryImages.isEmpty)
          const Center(child: Text(
              'No Photos', style: TextStyle(color: Colors.grey, fontSize: 16)))
        else
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: galleryImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
                      builder: (BuildContext context) =>
                          GalleryPopup(
                          images: galleryImages, initialIndex: index),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(galleryImages[index], width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) =>
                        progress == null
                            ? child
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> data) {
    final String address = data['location'] ?? '';
    if (address.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FutureBuilder<LatLng?>(
              future: _getCoordinates(address),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                      child: Text('Could not load map location.'));
                }
                final coordinates = snapshot.data!;
                return FlutterMap(
                  options: MapOptions(
                    initialCenter: coordinates,
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.basha_lagbe',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: coordinates,
                          width: 80,
                          height: 80,
                          child: const Icon(Icons.location_pin, color: Colors
                              .red, size: 40),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(Map<String, dynamic> data) {
    final price = data['price']?.toString() ?? '...';
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        width: double.infinity,
        color: const Color(0xFF3B3B3B),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Rent', style: TextStyle(fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white)),
                Text('$price/mo', style: const TextStyle(fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
              ],
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 137,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                      colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter),
                ),
                child: const Center(child: Text('Rent Now', style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}