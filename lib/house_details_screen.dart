import 'package:flutter/material.dart';

class HouseDetailsScreen extends StatelessWidget {
  const HouseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderImage(context),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const SizedBox(height: 16),
                      _buildAboutSection(),
                      const SizedBox(height: 24),
                      _buildContactSection(),
                      const SizedBox(height: 24),
                      _buildGallerySection(context),
                      const SizedBox(height: 24),
                      _buildLocationSection(),
                      const SizedBox(height: 120), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(),
          // Positioned back button on top of the stack
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildHeaderImage(BuildContext context) {
    return Container(
      height: 367,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Image.asset(
          'assets/green_house_details.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Green House',
          style: TextStyle(
            fontFamily: 'Raleway',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Road 10, Basundhara R/A',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Color(0xFF5E5E5E),
          ),
        ),
        SizedBox(height: 8),
        Text(
          '3 Bed    3 Bath   2 Balcony',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF5E5E5E),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontFamily: 'Inter', color: Colors.grey, height: 1.5, fontSize: 14),
        children: [
          TextSpan(text: 'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s... '),
          TextSpan(text: 'Read More', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/david_profile.png'),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Devid', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Owner Green House', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: IconButton(icon: const Icon(Icons.call, color: Colors.blue), onPressed: () {}),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: IconButton(icon: const Icon(Icons.message, color: Colors.blue), onPressed: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection(BuildContext context) {
    final List<String> galleryImages = [
      'assets/gallery_1.png',
      'assets/gallery_2.png',
      'assets/gallery_3.png',
      'assets/gallery_4.png',
      'assets/gallery_5.png',
      'assets/gallery_6.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gallery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
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
                    barrierColor: Colors.black.withOpacity(0.8),
                    builder: (BuildContext context) {
                      return GalleryPopup(
                        images: galleryImages,
                        initialIndex: index,
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(galleryImages[index], width: 80, height: 80, fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/map_placeholder.png',
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rent',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                Text(
                  '35,000/mo',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                ),
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
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Rent Now',
                    style: TextStyle(fontFamily: 'Raleway', fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class GalleryPopup extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const GalleryPopup({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  State<GalleryPopup> createState() => _GalleryPopupState();
}

class _GalleryPopupState extends State<GalleryPopup> {
  late final PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 0.8,
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                double scale = 1.0;
                if (_pageController.position.haveDimensions) {
                  scale = 1.0 - ((_currentPage - index).abs() * 0.2);
                  scale = scale.clamp(0.8, 1.0);
                }

                return Transform.scale(
                  scale: scale,
                  child: Center(
                    child: InteractiveViewer(
                      child: Image.asset(widget.images[index]),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 16,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}