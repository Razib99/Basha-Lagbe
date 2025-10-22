import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'account_screen.dart';
import 'add_listing_screen.dart';
import 'apartment_details_screen.dart';
import 'car_parking_details_screen.dart';
import 'electrician_details_screen.dart';
import 'house_details_screen.dart';
import 'maid_details_screen.dart';
import 'property_detail_screen.dart';
import 'room_details_screen.dart';
import 'search_page.dart';
import 'widgets/property_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Loading...';

  final List<Map<String, String>> _categories = const [
    {'icon': 'assets/icon_house.png', 'label': 'House'},
    {'icon': 'assets/icon_apartment.png', 'label': 'Apartment'},
    {'icon': 'assets/icon_room.png', 'label': 'Room'},
    {'icon': 'assets/icon_electrician.png', 'label': 'Electricians'},
    {'icon': 'assets/icon_maid.png', 'label': 'Maid'},
    {'icon': 'assets/icon_parking.png', 'label': 'Car Parking'},
  ];

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
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              _buildHeader(context),
              const SizedBox(height: 24.0),
              _buildCategoryBar(context),
              const SizedBox(height: 24.0),
              _buildSearchBar(context),
              const SizedBox(height: 24.0),
              _buildBestForYouSection(),
              const SizedBox(height: 24.0),
              _buildMapSection(), // MAP SECTION
              const SizedBox(height: 24.0),
              _buildNearbyLocationSection(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddListingScreen()),
          );
        },
        elevation: 6,
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xFFA0DAFB),
                Color(0xFF0A8ED9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
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
              const Text(
                'Dhaka, Basundhara',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFA8A8A8)),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreen()));
              _fetchUserData();
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                // ## UPDATED LINE BELOW ##
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (FirebaseAuth.instance.currentUser?.photoURL != null && FirebaseAuth.instance.currentUser!.photoURL!.isNotEmpty)
                      ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                      : const AssetImage('assets/default_profile_pic.png') as ImageProvider, // <-- Use default if no photoURL
                  )
                ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: const EdgeInsets.only(left: 16.0),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return GestureDetector(
            onTap: () {
              Widget? nextPage;
              if (category['label'] == 'House') {
                nextPage = const HouseDetailsScreen();
              } else if (category['label'] == 'Apartment') {
                nextPage = const ApartmentDetailsScreen();
              } else if (category['label'] == 'Room') {
                nextPage = const RoomDetailsScreen();
              } else if (category['label'] == 'Electricians') {
                nextPage = const ElectricianDetailsScreen();
              } else if (category['label'] == 'Maid') {
                nextPage = const MaidDetailsScreen();
              } else if (category['label'] == 'Car Parking') {
                nextPage = const CarParkingDetailsScreen();
              }
              if (nextPage != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage!));
              }
            },
            child: _buildCategoryIcon(
              iconPath: category['icon']!,
              label: category['label']!,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryIcon({required String iconPath, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[200], shape: BoxShape.circle),
            child: Image.asset(iconPath, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF727272))),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Search for a home...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestForYouSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Best for you', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
              TextButton(onPressed: () {}, child: const Text('View more', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF727272)))),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('properties').orderBy('createdAt', descending: true).limit(1).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 326, child: Center(child: CircularProgressIndicator()));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SizedBox(height: 326, child: Center(child: Text('No listings yet.')));
              }

              final latestPropertyDoc = snapshot.data!.docs.first;
              final latestPropertyData = latestPropertyDoc.data() as Map<String, dynamic>;
              final String propertyId = latestPropertyDoc.id;
              final imageUrl = latestPropertyData['mainImageUrl'] as String?;

              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailScreen(propertyId: propertyId))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Stack(
                    children: [
                      Container(
                        height: 326,
                        color: Colors.grey[300],
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 50));
                          },
                        )
                            : Center(child: Image.asset('assets/green_house.png', fit: BoxFit.cover, width: double.infinity)), // Fallback local asset
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              latestPropertyData['name'] ?? 'No Name',
                              style: const TextStyle(fontFamily: 'Almarai', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              latestPropertyData['location'] ?? 'No Location',
                              style: const TextStyle(fontFamily: 'Almarai', fontSize: 11, color: Colors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${latestPropertyData['beds'] ?? 0} Bed    ${latestPropertyData['baths'] ?? 0} Bath   ${latestPropertyData['balconies'] ?? 0} Balcony',
                              style: const TextStyle(fontFamily: 'Almarai', fontSize: 11, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore on Map',
            style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 326,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('properties').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Create a list of markers from the property data
                  final List<Marker> markers = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final lat = data['latitude'];
                    final lon = data['longitude'];

                    if (lat != null && lon != null) {
                      return Marker(
                        point: LatLng(lat, lon),
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PropertyDetailScreen(propertyId: doc.id)),
                            );
                          },
                          child: const Icon(Icons.location_pin, color: Colors.red, size: 30),
                        ),
                      );
                    }
                    return null; // Return null if no coordinates
                  }).where((marker) => marker != null).cast<Marker>().toList();

                  return FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(23.8103, 90.4125), // Default to Dhaka
                      initialZoom: 12.0,
                      interactionOptions: InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      MarkerLayer(markers: markers),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Nearby your location', style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
              TextButton(onPressed: () {}, child: const Text('View more', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF727272)))),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('properties').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No listings found.'));
              }
              final properties = snapshot.data!.docs;
              return ListView.builder(
                itemCount: properties.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final propertyData = properties[index].data() as Map<String, dynamic>;
                  final propertyId = properties[index].id;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertyDetailScreen(propertyId: propertyId),
                        ),
                      );
                    },
                    child: PropertyListItem(
                      imageUrl: propertyData['mainImageUrl'],
                      posterName: propertyData['posterName'] ?? 'Owner',
                      title: propertyData['name'] ?? 'No Name',
                      location: propertyData['location'] ?? 'No Location',
                      occupantType: propertyData['occupantType'],
                      beds: propertyData['beds'] ?? 0,
                      baths: propertyData['baths'] ?? 0,
                      balconies: propertyData['balconies'] ?? 0,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}