import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/property_list_item.dart';
import 'property_detail_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _searchText = "";


  int? _selectedBeds;
  int? _selectedBaths;
  int? _selectedBalconies;

  @override
  void initState() {
    super.initState();
    // Update search results when text changes
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper function to build the Firestore query based on filters
  Query _buildSearchQuery() {
    Query query = FirebaseFirestore.instance.collection('properties');

    // Add filters based on selected values (more complex search logic can be added later)
    if (_selectedBeds != null) {
      query = query.where('beds', isEqualTo: _selectedBeds);
    }
    if (_selectedBaths != null) {
      query = query.where('baths', isEqualTo: _selectedBaths);
    }
    // Add text search (simple 'startsWith' for now)
    if (_searchText.isNotEmpty) {
      // Basic search: checks if 'name' starts with the search text (case-insensitive)
      // Firestore doesn't support case-insensitive 'startsWith' directly,
      // so we query a range. This requires lowercase fields or more complex setup later.
      query = query.where('name_lowercase', isGreaterThanOrEqualTo: _searchText.toLowerCase())
          .where('name_lowercase', isLessThanOrEqualTo: '${_searchText.toLowerCase()}\uf8ff');
    }


    query = query.orderBy('createdAt', descending: true); // Order results
    return query;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search by name or location...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade600),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 18),
          autofocus: true, // Automatically focus the search bar
        ),
      ),
      body: Column(
        children: [
          // --- Placeholder for Filter Controls ---
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: const Center(
              child: Text(
                'Filter options (beds, baths, etc.) will go here',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),

          // --- Display Search Results ---
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _buildSearchQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print(snapshot.error); // Print error for debugging
                  // Check for index error specifically
                  if (snapshot.error.toString().contains('requires an index')) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Firestore needs an index for this query. Please check the debug console for a link to create it automatically in the Firebase Console.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return const Center(child: Text('Error loading results.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No results found.'));
                }

                final results = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final data = results[index].data() as Map<String, dynamic>;
                    final propertyId = results[index].id;

                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailScreen(propertyId: propertyId))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: PropertyListItem(
                          imageUrl: data['mainImageUrl'],
                          posterName: data['posterName'] ?? 'Owner',
                          title: data['name'] ?? 'No Name',
                          location: data['location'] ?? 'No Location',
                          beds: data['beds'] ?? 0,
                          baths: data['baths'] ?? 0,
                          balconies: data['balconies'] ?? 0,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}