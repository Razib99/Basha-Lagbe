import 'package:flutter/material.dart';

class PropertyListItem extends StatelessWidget {
  final String? imageUrl;
  final String posterName; // <-- NOW DEFINED
  final String title;
  final String location;
  final int beds;
  final int baths;
  final int balconies;

  const PropertyListItem({
    super.key,
    this.imageUrl,
    required this.posterName, // <-- NOW REQUIRED
    required this.title,
    required this.location,
    required this.beds,
    required this.baths,
    required this.balconies,
  });

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
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: imageUrl != null && imageUrl!.startsWith('http')
                ? Image.network(
              imageUrl!,
              width: 65,
              height: 67,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
              progress == null ? child : Container(width: 65, height: 67, color: Colors.grey[200]),
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 65, height: 67, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
            )
                : Image.asset(
              'assets/house_list_item.png', // Fallback local asset
              width: 65,
              height: 67,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  posterName,
                  style: const TextStyle(fontFamily: 'Almarai', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  title,
                  style: const TextStyle(fontFamily: 'Almarai', fontSize: 11, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$beds Bed    $baths Bath   $balconies Balcony',
                  style: const TextStyle(fontFamily: 'Almarai', fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}