import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/property_list_item.dart';
import 'property_detail_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  String _searchQuery = "";
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Recent Searches Logic ---
  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query); // Remove if it already exists to move it to the top
    _recentSearches.insert(0, query); // Add to the beginning of the list
    if (_recentSearches.length > 5) {
      _recentSearches = _recentSearches.sublist(0, 5); // Keep only the 5 most recent
    }
    await prefs.setStringList('recent_searches', _recentSearches);
    _loadRecentSearches(); // Reload to update UI
  }

  Future<void> _deleteRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    _recentSearches.remove(query);
    await prefs.setStringList('recent_searches', _recentSearches);
    _loadRecentSearches(); // Reload to update UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for a home...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _searchController.clear(),
            )
                : null,
          ),
          onSubmitted: (value) => _saveRecentSearch(value),
        ),
      ),
      body: _searchQuery.isEmpty ? _buildIdleView() : _buildResultsView(),
    );
  }

  // --- UI for the Idle State (no text in search bar) ---
  Widget _buildIdleView() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (_recentSearches.isNotEmpty) ...[
          const Text('Recent searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ..._recentSearches.map((search) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.history),
            title: Text(search),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _deleteRecentSearch(search),
            ),
            onTap: () {
              _searchController.text = search;
            },
          )),
          const SizedBox(height: 24),
        ],
        const Text('Popular searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: ['Apartment', 'Family', 'Bachelor', 'Room', 'Low Rent']
              .map((label) => Chip(
            label: Text(label),
            onDeleted: null,
          ))
              .toList(),
        ),
      ],
    );
  }

  // --- UI for the Results State (text in search bar) ---
  Widget _buildResultsView() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('properties')
          .where('name_lowercase', isGreaterThanOrEqualTo: _searchQuery.toLowerCase())
          .where('name_lowercase', isLessThanOrEqualTo: '${_searchQuery.toLowerCase()}\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No results found for "$_searchQuery"'));
        }

        final results = snapshot.data!.docs;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final data = results[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name'] ?? ''),
              subtitle: Text(data['location'] ?? ''),
              onTap: () {
                _saveRecentSearch(_searchController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PropertyDetailScreen(propertyId: results[index].id)),
                );
              },
            );
          },
        );
      },
    );
  }
}