import 'package:flutter/material.dart';
import 'account_screen.dart';
import 'house_details_screen.dart';
import 'electrician_details_screen.dart';
import 'maid_details_screen.dart';
import 'car_parking_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<Map<String, String>> _categories = const [
    {'icon': 'assets/icon_house.png', 'label': 'House'},
    {'icon': 'assets/icon_apartment.png', 'label': 'Apartment'},
    {'icon': 'assets/icon_room.png', 'label': 'Room'},
    {'icon': 'assets/icon_electrician.png', 'label': 'Electricians'},
    {'icon': 'assets/icon_maid.png', 'label': 'Maid'},
    {'icon': 'assets/icon_parking.png', 'label': 'Car Parking'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24.0),
              _buildCategoryBar(context),
              const SizedBox(height: 24.0),
              _buildBestForYouSection(),
              const SizedBox(height: 24.0),
              _buildNearbyLocationSection(),
            ],
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
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Devid', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
              SizedBox(height: 4),
              Text('Dhaka, Basundhara', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFFA8A8A8))),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
            child: Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
                image: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/profile_pic.png')),
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
              if (category['label'] == 'House') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HouseDetailsScreen()),
                );
              } else if (category['label'] == 'Electricians') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ElectricianDetailsScreen()),
                );
              } else if (category['label'] == 'Maid') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MaidDetailsScreen()),
                );
              } else if (category['label'] == 'Car Parking') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CarParkingDetailsScreen()),
                );
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
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              children: [
                Image.asset('assets/green_house.png', width: 348, height: 326, fit: BoxFit.cover),
                Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.8)], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: const [0.5, 1.0])))),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Green House', style: TextStyle(fontFamily: 'Almarai', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 8),
                      Text('Road 10, Basundhara R/A', style: TextStyle(fontFamily: 'Almarai', fontSize: 11, color: Colors.white)),
                      SizedBox(height: 8),
                      Text('3 Bed    3 Bath   2 Balcony', style: TextStyle(fontFamily: 'Almarai', fontSize: 11, color: Colors.white)),
                    ],
                  ),
                ),
              ],
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
          Column(
            children: List.generate(8, (index) => const PropertyListItem()),
          ),
        ],
      ),
    );
  }
}

class PropertyListItem extends StatelessWidget {
  const PropertyListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset('assets/house_list_item.png', width: 65, height: 67, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Green House', style: TextStyle(fontFamily: 'Almarai', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                const Text('Road 10, Basundhara R/A', style: TextStyle(fontFamily: 'Almarai', fontSize: 11, color: Colors.black)),
                const Text('3 Bed    3 Bath   2 Balcony', style: TextStyle(fontFamily: 'Almarai', fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}