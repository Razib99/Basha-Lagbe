import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'property_detail_screen.dart';
import 'widgets/property_list_item.dart';

class HouseDetailsScreen extends StatelessWidget {
  const HouseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Houses for Rent'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        // Query now checks if the 'categories' list contains 'House'
        stream: FirebaseFirestore.instance
            .collection('properties')
            .where('categories', arrayContains: 'House')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No houses have been listed yet.'));
          }

          final houses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: houses.length,
            itemBuilder: (context, index) {
              final propertyData = houses[index].data() as Map<String, dynamic>;
              final propertyId = houses[index].id;

              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailScreen(propertyId: propertyId))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: PropertyListItem(
                    imageUrl: propertyData['mainImageUrl'],
                    posterName: propertyData['posterName'] ?? 'Owner',
                    title: propertyData['name'] ?? 'No Name',
                    location: propertyData['location'] ?? 'No Location',
                    beds: propertyData['beds'] ?? 0,
                    baths: propertyData['baths'] ?? 0,
                    balconies: propertyData['balconies'] ?? 0,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}