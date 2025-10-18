import 'package:flutter/material.dart';

class GalleryPopup extends StatefulWidget {
  final List<dynamic> images;
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
                      child: Image.network(widget.images[index]),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 16,
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
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