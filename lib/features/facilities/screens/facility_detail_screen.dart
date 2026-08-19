import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/providers/facilities_providers.dart';
import '../../../core/utils/icon_helper.dart';
import '../../../data/models/amenity_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../shared/widgets/app_network_image.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../widgets/send_enquiry_sheet.dart';

class FacilityDetailScreen extends ConsumerStatefulWidget {
  const FacilityDetailScreen({super.key, required this.kind, required this.id});

  final FacilityKind kind;
  final String id;

  @override
  ConsumerState<FacilityDetailScreen> createState() =>
      _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends ConsumerState<FacilityDetailScreen> {
  bool _isFavorite = false;

  Future<void> _openDirections(FacilityModel facility) async {
    if (facility.latitude != null && facility.longitude != null) {
      final uri = Uri.parse('geo:${facility.latitude},${facility.longitude}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return;
      }
      final webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${facility.latitude},${facility.longitude}',
      );
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
        return;
      }
    }
    if (facility.address != null && facility.address!.isNotEmpty) {
      final query = Uri.encodeComponent(facility.address!);
      final webUri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$query',
      );
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
      }
    }
  }

  Future<void> _call(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(
      facilityDetailProvider(widget.kind, widget.id),
    );
    final isLibrary = widget.kind == FacilityKind.library;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Circular Back Button
                _CircleIconButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/services?kind=${widget.kind.name}');
                    }
                  },
                ),
                // Circular Favorite Button
                _CircleIconButton(
                  icon: _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  iconColor: _isFavorite ? const Color(0xFFE11D48) : null,
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                ),
              ],
            ),
          ),
        ),
      ),
      body: detailAsync.when(
        loading: () => const LoadingIndicator(),
        error: (error, _) => ErrorStateView(
          error: error,
          onRetry: () => ref.invalidate(
            facilityDetailProvider(widget.kind, widget.id),
          ),
        ),
        data: (facility) {
          final isOpen = facility.isOpenNow;
          final cover = facility.coverImageUrl;
          final gallery = facility.galleryImageUrls;
          final activeAmenities = facility.activeAmenities;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Hero Split Section: Photo (Left) + Details & Actions (Right)
                _HeroFacilityHeader(
                  facility: facility,
                  isLibrary: isLibrary,
                  isOpen: isOpen,
                  cover: cover,
                  onOpenDirections: () => _openDirections(facility),
                  onCall: () => _call(facility.contactPhone),
                  onSendEnquiry: () => SendEnquirySheet.show(
                    context,
                    facilityId: facility.id,
                    facilityKind: widget.kind,
                    facilityTitle: facility.name,
                    facilitySubtitle: facility.address,
                    categoryName: isLibrary ? 'Public Library' : 'Gym & Fitness Center',
                    facilityPhone: facility.contactPhone,
                    facilityEmail: facility.contactEmail,
                  ),
                ),
                const SizedBox(height: 22),

                // 2. Photos & Gallery Section
                _SectionTitle(
                  icon: Icons.photo_library_outlined,
                  title: 'Photos & Gallery',
                  iconColor: const Color(0xFF0F766E),
                ),
                const SizedBox(height: 10),
                _GallerySection(gallery: gallery, isLibrary: isLibrary),
                const SizedBox(height: 22),

                // 3. Amenities & Features Section
                _SectionTitle(
                  icon: Icons.stars_rounded,
                  title: 'Amenities & Features',
                  iconColor: const Color(0xFF0F766E),
                ),
                const SizedBox(height: 10),
                _AmenitiesSection(
                  amenities: activeAmenities,
                  isLibrary: isLibrary,
                ),
                const SizedBox(height: 22),

                // 4. About Section
                _SectionTitle(
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  iconColor: const Color(0xFF0F766E),
                ),
                const SizedBox(height: 8),
                Text(
                  (facility.description != null &&
                          facility.description!.trim().isNotEmpty)
                      ? facility.description!
                      : (isLibrary
                          ? 'Central library hosting public lecture halls, modern digital collections, study lounges, and coding workshops.'
                          : 'State-of-the-art fitness center with certified trainers, modern equipment, and wellness zones.'),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4B5563),
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 22),

                // 5. Hours Section
                _SectionTitle(
                  icon: Icons.schedule_rounded,
                  title: 'Hours',
                  iconColor: const Color(0xFF0F766E),
                ),
                const SizedBox(height: 8),
                _HoursCard(facility: facility, isOpen: isOpen),
                const SizedBox(height: 22),

                // 6. Location Section
                _SectionTitle(
                  icon: Icons.location_on_rounded,
                  title: 'Location',
                  iconColor: const Color(0xFF0F766E),
                ),
                const SizedBox(height: 8),
                _LocationCard(
                  facility: facility,
                  onTap: () => _openDirections(facility),
                ),
                const SizedBox(height: 22),

                // 7. Stats Banner (Established, Books/Equipment, Visitors)
                _StatsBanner(facility: facility, isLibrary: isLibrary),

                // 8. Send Citizen Enquiry Action
                const SizedBox(height: 18),
                _FullWidthActionButton(
                  label: 'Send Enquiry to Provider / Desk',
                  icon: Icons.contact_mail_outlined,
                  isPrimary: false,
                  onTap: () => SendEnquirySheet.show(
                    context,
                    facilityId: facility.id,
                    facilityKind: widget.kind,
                    facilityTitle: facility.name,
                    facilitySubtitle: facility.address,
                    categoryName: isLibrary ? 'Public Library' : 'Gym & Fitness Center',
                    facilityPhone: facility.contactPhone,
                    facilityEmail: facility.contactEmail,
                  ),
                ),

                // 9. Direct Gym QR Check-in CTA (if Gym)
                if (!isLibrary) ...[
                  const SizedBox(height: 12),
                  _FullWidthActionButton(
                    label: 'Scan QR to Check-in at this Gym',
                    icon: Icons.qr_code_scanner_rounded,
                    isPrimary: true,
                    onTap: () => context.push('/checkin'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 42,
      height: 42,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        elevation: 1,
        shadowColor: const Color(0x10000000),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: Icon(
              icon,
              color: iconColor ?? const Color(0xFF1F2937),
              size: 19,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  final IconData icon;
  final String title;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}

class _HeroFacilityHeader extends StatelessWidget {
  const _HeroFacilityHeader({
    required this.facility,
    required this.isLibrary,
    required this.isOpen,
    required this.cover,
    required this.onOpenDirections,
    required this.onCall,
    required this.onSendEnquiry,
  });

  final FacilityModel facility;
  final bool isLibrary;
  final bool isOpen;
  final String? cover;
  final VoidCallback onOpenDirections;
  final VoidCallback onCall;
  final VoidCallback onSendEnquiry;

  @override
  Widget build(BuildContext context) {
    final cityName = facility.city?.name ?? '';
    final addressLine = facility.address ?? (cityName.isNotEmpty ? cityName : 'City Center');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Cover Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            width: 145,
            height: 195,
            child: AppNetworkImage(
              imageUrl: cover,
              width: 145,
              height: 195,
              fit: BoxFit.cover,
              isLibrary: isLibrary,
              fallbackIcon:
                  isLibrary
                      ? Icons.menu_book_rounded
                      : Icons.fitness_center_rounded,
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Right Info & Buttons
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Open Now Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: isOpen ? const Color(0xFFE8F5E9) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOpen ? const Color(0xFF16A34A) : const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isOpen ? 'Open Now' : 'Closed',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isOpen ? const Color(0xFF166534) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                facility.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  height: 1.2,
                  letterSpacing: -0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              if (cityName.isNotEmpty && !facility.name.contains(cityName)) ...[
                const SizedBox(height: 2),
                Text(
                  cityName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
              const SizedBox(height: 6),

              // Location Pin Line
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: Color(0xFF0F766E),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      addressLine,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Action Buttons Row (Directions & Call & Enquiry — icon-only)
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  // Directions icon button
                  _HeaderIconButton(
                    icon: Icons.near_me_rounded,
                    tooltip: 'Get Directions',
                    backgroundColor: const Color(0xFF0D473B),
                    iconColor: Colors.white,
                    onTap: onOpenDirections,
                  ),

                  // Call icon button
                  _HeaderIconButton(
                    icon: Icons.call_outlined,
                    tooltip: 'Call Facility',
                    backgroundColor: Colors.white,
                    iconColor: const Color(0xFF374151),
                    borderColor: const Color(0xFFE5E7EB),
                    onTap: onCall,
                  ),

                  // Send Enquiry icon button
                  _HeaderIconButton(
                    icon: Icons.mark_email_unread_outlined,
                    tooltip: 'Send Citizen Enquiry',
                    backgroundColor: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF15803D),
                    borderColor: const Color(0xFF86EFAC),
                    onTap: onSendEnquiry,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({required this.gallery, required this.isLibrary});

  final List<String> gallery;
  final bool isLibrary;

  @override
  Widget build(BuildContext context) {
    // Sample interior gallery photos if backend has only 1 or no extra photos
    final items = gallery.isNotEmpty
        ? gallery
        : [
            'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=400&q=80',
            'https://images.unsplash.com/photo-1541829070764-84a7d30dd3f3?w=400&q=80',
            'https://images.unsplash.com/photo-1568667256549-094345857637?w=400&q=80',
          ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 110,
                height: 90,
                child: AppNetworkImage(
                  imageUrl: items[i],
                  width: 110,
                  height: 90,
                  fit: BoxFit.cover,
                  isLibrary: isLibrary,
                  fallbackIcon: isLibrary
                      ? Icons.menu_book_rounded
                      : Icons.fitness_center_rounded,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          // Trailing "View All" card
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: Color(0xFF0D473B),
                  size: 22,
                ),
                SizedBox(height: 4),
                Text(
                  'View All →',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D473B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesSection extends StatelessWidget {
  const _AmenitiesSection({
    required this.amenities,
    required this.isLibrary,
  });

  final List<AmenityModel> amenities;
  final bool isLibrary;

  @override
  Widget build(BuildContext context) {
    // Default curated list matching reference design
    final defaultAmenities = isLibrary
        ? const [
            ('🛡️', '24/7 CCTV &\nSecurity Guard'),
            ('💻', 'Digital Archives &\nE-Book Terminals'),
            ('❄️', 'Air Conditioning &\nClimate Control'),
            ('🧸', 'Kids Activity &\nReading Corner'),
            ('📖', 'Silent Study Hall &\nReading Desks'),
            ('💧', 'RO Purified\nDrinking Water'),
            ('☕', 'Cafeteria &\nEspresso Lounge'),
            ('📶', 'High-Speed\nWi-Fi'),
            ('🅿️', 'Dedicated Parking\n& Valet'),
          ]
        : const [
            ('🏋️', 'Cardio & Strength\nEquipment'),
            ('❄️', 'Air Conditioning &\nClimate Control'),
            ('🚿', 'Locker & Shower\nFacilities'),
            ('💧', 'RO Purified\nDrinking Water'),
            ('🧘', 'Yoga & Stretch\nStudio'),
            ('🅿️', 'Dedicated Parking\nSpace'),
          ];

    final items = amenities.isNotEmpty
        ? amenities.map((a) => (a.icon ?? '★', a.name)).toList()
        : defaultAmenities;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final (icon, name) = item;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconHelper.buildIcon(
                icon,
                size: 16,
                color: const Color(0xFF1565D8),
                defaultEmoji: '★',
              ),
              const SizedBox(width: 6),
              Text(
                name.replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _HoursCard extends StatelessWidget {
  const _HoursCard({required this.facility, required this.isOpen});

  final FacilityModel facility;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final openTime = facility.openingTimeShort ?? '09:30 AM';
    final closeTime = facility.closingTimeShort ?? '08:30 PM';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Today',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    '$openTime – $closeTime',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D473B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isOpen ? const Color(0xFFE8F5E9) : const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isOpen ? 'Open Now' : 'Closed',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isOpen ? const Color(0xFF166534) : const Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.facility, required this.onTap});

  final FacilityModel facility;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cityName = facility.city?.name ?? '';
    final addressLine = facility.address ?? (cityName.isNotEmpty ? cityName : 'City Center');

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEEF2F6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addressLine,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cityName.isNotEmpty ? '$cityName, India' : 'India',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Right Map Graphic with Pinpoint
              Container(
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7F0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD1FAE5)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Stylized map streets
                    Positioned(
                      top: 15,
                      left: 0,
                      right: 0,
                      child: Container(height: 6, color: Colors.white.withValues(alpha: 0.6)),
                    ),
                    Positioned(
                      top: 35,
                      left: 10,
                      right: 20,
                      child: Container(height: 4, color: Colors.white.withValues(alpha: 0.6)),
                    ),
                    Positioned(
                      left: 45,
                      top: 0,
                      bottom: 0,
                      child: Container(width: 5, color: Colors.white.withValues(alpha: 0.6)),
                    ),
                    // Pin
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D473B),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x20000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsBanner extends StatelessWidget {
  const _StatsBanner({required this.facility, required this.isLibrary});

  final FacilityModel facility;
  final bool isLibrary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEF2F6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Stat 1: Established
          Expanded(
            child: _StatItem(
              icon: Icons.schedule_rounded,
              label: 'Established',
              value: '1956',
            ),
          ),
          Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),

          // Stat 2: Total Books / Equipment
          Expanded(
            child: _StatItem(
              icon: isLibrary ? Icons.menu_book_rounded : Icons.fitness_center_rounded,
              label: isLibrary ? 'Total Books' : 'Equipment',
              value: isLibrary ? '2.5 Lakh+' : '120+ Sets',
            ),
          ),
          Container(width: 1, height: 28, color: const Color(0xFFE2E8F0)),

          // Stat 3: Visitors Monthly
          Expanded(
            child: _StatItem(
              icon: Icons.people_outline_rounded,
              label: 'Visitors Monthly',
              value: isLibrary ? '15K+' : '1.2K+',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF0F766E)),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.backgroundColor = Colors.white,
    this.iconColor = const Color(0xFF374151),
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color backgroundColor;
  final Color iconColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 38,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(11),
          child: InkWell(
            borderRadius: BorderRadius.circular(11),
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: borderColor != null ? Border.all(color: borderColor!) : null,
              ),
              child: Center(
                child: Icon(icon, color: iconColor, size: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FullWidthActionButton extends StatelessWidget {
  const _FullWidthActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? const Color(0xFF0D473B) : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: isPrimary ? null : Border.all(color: const Color(0xFF0F766E), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isPrimary ? Colors.white : const Color(0xFF0F766E),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: isPrimary ? Colors.white : const Color(0xFF0F766E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
