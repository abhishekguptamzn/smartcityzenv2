import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/models/facility_model.dart';
import '../../../../shared/widgets/app_network_image.dart';

class FacilityHeroGallery extends StatefulWidget {
  const FacilityHeroGallery({
    super.key,
    required this.facility,
    required this.galleryUrls,
    required this.isOpen,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final FacilityModel facility;
  final List<String> galleryUrls;
  final bool isOpen;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  State<FacilityHeroGallery> createState() => _FacilityHeroGalleryState();
}

class _FacilityHeroGalleryState extends State<FacilityHeroGallery> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullscreenViewer(int initialIndex) {
    if (widget.galleryUrls.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullscreenGalleryViewer(
          images: widget.galleryUrls,
          initialIndex: initialIndex,
          title: widget.facility.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = widget.galleryUrls;
    final hasImages = urls.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            // Image Carousel
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                height: 250,
                child: hasImages
                    ? PageView.builder(
                        controller: _pageController,
                        itemCount: urls.length,
                        onPageChanged: (i) => setState(() => _currentIndex = i),
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () => _openFullscreenViewer(i),
                            child: AppNetworkImage(
                              imageUrl: urls[i],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: const Color(0xFFE0F2FE),
                        child: Center(
                          child: Icon(
                            widget.facility.kind == FacilityKind.library
                                ? Icons.local_library_rounded
                                : Icons.fitness_center_rounded,
                            size: 64,
                            color: const Color(0xFF0284C7),
                          ),
                        ),
                      ),
              ),
            ),

            // Top Badges (Open/Closed status + Favorite button)
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (widget.isOpen ? const Color(0xFF059669) : const Color(0xFFDC2626))
                      .withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.isOpen ? 'OPEN NOW' : 'CLOSED',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.black.withValues(alpha: 0.45),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onToggleFavorite();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 20,
                      color: widget.isFavorite ? const Color(0xFFFB7185) : Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Counter Indicator
            if (urls.length > 1)
              Positioned(
                bottom: 12,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 0.8),
                  ),
                  child: Text(
                    '${_currentIndex + 1}/${urls.length}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            if (urls.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    urls.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentIndex == i ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentIndex == i ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _FullscreenGalleryViewer extends StatefulWidget {
  const _FullscreenGalleryViewer({
    required this.images,
    required this.initialIndex,
    required this.title,
  });

  final List<String> images;
  final int initialIndex;
  final String title;

  @override
  State<_FullscreenGalleryViewer> createState() => _FullscreenGalleryViewerState();
}

class _FullscreenGalleryViewerState extends State<_FullscreenGalleryViewer> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${widget.title} (${_index + 1}/${widget.images.length})',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) {
          return InteractiveViewer(
            minScale: 0.8,
            maxScale: 3.5,
            child: Center(
              child: AppNetworkImage(
                imageUrl: widget.images[i],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
