import 'package:flutter/material.dart';

class MaidDetailsScreen extends StatelessWidget {
  const MaidDetailsScreen({super.key});

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
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFDEDEDE)),
                      const SizedBox(height: 20),
                      _buildAboutServiceText(),
                      const SizedBox(height: 20),
                      _buildBookingDateTimeBox(),
                      const SizedBox(height: 20),
                      _buildContactBox(),
                      const SizedBox(height: 20),
                      _buildReviewsSection(),
                      const SizedBox(height: 100), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  // --- All Helper Widgets MUST be inside this class ---

  Widget _buildHeaderImage(BuildContext context) {
    return SizedBox(
      height: 373,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/maid_hero_image.png',
            fit: BoxFit.cover,
          ),
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

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Maid',
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E5E5E),
              ),
            ),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.share, color: Colors.grey), onPressed: () {}),
                IconButton(icon: const Icon(Icons.bookmark_border, color: Colors.grey), onPressed: () {}),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Sofia',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0A8ED9),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.location_on, color: Color(0xFF727272), size: 14),
                SizedBox(width: 4),
                Text(
                  'Basundhara R/A, Dhaka',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF727272)),
                ),
              ],
            ),
            const Row(
              children: [
                Icon(Icons.star, color: Color(0xFF727272), size: 14),
                SizedBox(width: 4),
                Text(
                  '4.9 (267 Reviews)',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF727272)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutServiceText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Service', style: TextStyle(fontFamily: 'Raleway', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5E5E5E))),
        SizedBox(height: 10),
        Text(
          'Lorem ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s. Read More',
          style: TextStyle(fontFamily: 'Inter', color: Colors.grey, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildBookingDateTimeBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Booking Date and Time', style: TextStyle(fontFamily: 'Raleway', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5E5E5E))),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)],
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Color(0xFF646464)),
                      SizedBox(width: 8),
                      Text('Date', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF646464))),
                      SizedBox(width: 8),
                      Text('25th May, 2024', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Color(0xFF646464))),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Color(0xFF646464)),
                      SizedBox(width: 8),
                      Text('Time', style: TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF646464))),
                      SizedBox(width: 8),
                      Text('4:00 pm - 5:00 pm', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Color(0xFF646464))),
                    ],
                  ),
                ],
              ),
              const Divider(height: 24, color: Color(0xFFDEDEDE)),
              const Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Color(0xFF646464)),
                  SizedBox(width: 8),
                  Text('Flat 5A, House 740, Road 10, G Block', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF646464))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Contact', style: TextStyle(fontFamily: 'Raleway', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5E5E5E))),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)],
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)],
                  image: const DecorationImage(image: AssetImage('assets/contact_profile.png'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sofia', style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black)),
                  Text('Maid', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF868585))),
                ],
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: Color(0xFF0A8ED9))),
              IconButton(onPressed: () {}, icon: const Icon(Icons.message, color: Color(0xFF0A8ED9))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reviews', style: TextStyle(fontFamily: 'Raleway', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5E5E5E))),
        const SizedBox(height: 10),
        Row(
          children: [
            Column(
              children: [
                const Text('4.9', style: TextStyle(fontFamily: 'Inter', fontSize: 50)),
                Row(children: List.generate(5, (_) => const Icon(Icons.star, color: Colors.amber, size: 16))),
                const SizedBox(height: 4),
                const Text('2,256,867', style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Color(0xFF646464))),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildReviewBar(5, 0.9),
                  _buildReviewBar(4, 0.75),
                  _buildReviewBar(3, 0.4),
                  _buildReviewBar(2, 0.2),
                  _buildReviewBar(1, 0.1),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewBar(int rating, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$rating', style: const TextStyle(fontFamily: 'Inter', fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 75,
        color: const Color(0xFF3B3B3B),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('1000/work', style: TextStyle(fontFamily: 'Raleway', fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white)),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 137,
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA0DAFB), Color(0xFF0A8ED9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Book Now',
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
} // <-- This is the closing brace for the MaidDetailsScreen class