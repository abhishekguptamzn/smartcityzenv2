import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/image_url_resolver.dart';
import '../../../data/models/amenity_model.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/show_confirm_dialog.dart';
import '../widgets/amenity_selector_sheet.dart';
import 'facility_dashboard_screen.dart';

final facilityMediaProvider = FutureProvider.autoDispose
    .family<List<FacilityMediaModel>, (FacilityKind, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getFacilityMedia(args.$1, args.$2);
});

class EditFacilityDetailsScreen extends ConsumerStatefulWidget {
  const EditFacilityDetailsScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;

  @override
  ConsumerState<EditFacilityDetailsScreen> createState() =>
      _EditFacilityDetailsScreenState();
}

class _EditFacilityDetailsScreenState
    extends ConsumerState<EditFacilityDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Details Tab Form State
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _descController = TextEditingController();
  bool _submitting = false;
  bool _isLoadingAmenities = true;
  bool _uploadingPhoto = false;

  late TimeOfDay? _openingTime;
  late TimeOfDay? _closingTime;
  List<AmenityModel> _selectedAmenities = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _descController.text = widget.facility?.description ?? '';
    _openingTime = _parseTimeString(widget.facility?.openingTime) ??
        const TimeOfDay(hour: 6, minute: 0);
    _closingTime = _parseTimeString(widget.facility?.closingTime) ??
        const TimeOfDay(hour: 22, minute: 0);
    _selectedAmenities = widget.facility?.amenities ?? [];

    _loadFacilityAmenities();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _loadFacilityAmenities() async {
    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final list =
          await repo.getFacilityAmenities(widget.kind, widget.facilityId);
      if (mounted && list.isNotEmpty) {
        setState(() => _selectedAmenities = list);
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingAmenities = false);
    }
  }

  TimeOfDay? _parseTimeString(String? timeStr) {
    if (timeStr == null || timeStr.trim().isEmpty) return null;
    try {
      final parts = timeStr.trim().split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (_) {}
    return null;
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeDisplay(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  IconData _resolveAmenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wifi') ||
        lower.contains('wi-fi') ||
        lower.contains('internet')) {
      return Icons.wifi_rounded;
    } else if (lower.contains('ac') ||
        lower.contains('air') ||
        lower.contains('cool')) {
      return Icons.ac_unit_rounded;
    } else if (lower.contains('reading') ||
        lower.contains('book') ||
        lower.contains('study') ||
        lower.contains('quiet') ||
        lower.contains('desk')) {
      return Icons.chair_alt_rounded;
    } else if (lower.contains('newspaper') ||
        lower.contains('journal') ||
        lower.contains('magazin')) {
      return Icons.menu_book_rounded;
    } else if (lower.contains('water') ||
        lower.contains('dispenser') ||
        lower.contains('drink')) {
      return Icons.local_drink_rounded;
    } else if (lower.contains('power') ||
        lower.contains('plug') ||
        lower.contains('charging')) {
      return Icons.power_rounded;
    } else if (lower.contains('parking') || lower.contains('valet')) {
      return Icons.local_parking_rounded;
    } else if (lower.contains('locker') || lower.contains('storage')) {
      return Icons.lock_outline_rounded;
    } else if (lower.contains('gym') ||
        lower.contains('dumbbell') ||
        lower.contains('weight') ||
        lower.contains('treadmill')) {
      return Icons.fitness_center_rounded;
    } else if (lower.contains('shower') ||
        lower.contains('bath') ||
        lower.contains('washroom')) {
      return Icons.shower_rounded;
    } else if (lower.contains('cafe') ||
        lower.contains('coffee') ||
        lower.contains('tea')) {
      return Icons.coffee_rounded;
    } else if (lower.contains('cctv') ||
        lower.contains('security') ||
        lower.contains('guard')) {
      return Icons.videocam_outlined;
    }
    return Icons.star_rounded;
  }

  Future<void> _handleOpenAmenitySelector() async {
    final updatedList = await showAmenitySelectorSheet(
      context: context,
      kind: widget.kind,
      facilityId: widget.facilityId,
      initiallySelected: _selectedAmenities,
    );

    if (updatedList != null && mounted) {
      setState(() => _selectedAmenities = updatedList);
    }
  }

  Future<void> _submitDetails() async {
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    final v = form.value;
    final facilityName =
        v['name']?.toString() ?? widget.facility?.name ?? 'Facility';

    final confirm = await showAppConfirmDialog(
      context: context,
      title: 'Save Facility Details',
      message:
          'Are you sure you want to update public details and amenities for $facilityName?',
      confirmLabel: 'Save Changes',
      details: [
        ConfirmDetailRow(label: 'Facility', value: facilityName),
        ConfirmDetailRow(
            label: 'Amenities', value: '${_selectedAmenities.length} selected'),
        ConfirmDetailRow(
          label: 'Operating Hours',
          value:
              '${_formatTimeDisplay(_openingTime)} — ${_formatTimeDisplay(_closingTime)}',
        ),
      ],
    );

    if (!confirm) return;

    setState(() => _submitting = true);
    final repo = ref.read(clientFacilityRepositoryProvider);

    try {
      final payload = {
        'name': v['name'],
        'description': _descController.text.trim(),
        'address': v['address'],
        'contact_phone': v['contact_phone'],
        'contact_email': v['contact_email'],
        if (_openingTime != null)
          'opening_time': _formatTimeOfDay(_openingTime!),
        if (_closingTime != null)
          'closing_time': _formatTimeOfDay(_closingTime!),
        'amenity_ids': _selectedAmenities.map((a) => a.id).toList(),
      };

      if (widget.kind == FacilityKind.gym) {
        await repo.updateGymDetails(widget.facilityId, payload);
      } else {
        await repo.updateLibraryDetails(widget.facilityId, payload);
      }

      ref.invalidate(myOwnedFacilitiesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    '${widget.kind == FacilityKind.gym ? "Gym" : "Library"} details & amenities updated successfully!'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update facility: $err'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _pickAndUploadPhoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;

      setState(() => _uploadingPhoto = true);
      final bytes = await picked.readAsBytes();

      final repo = ref.read(clientFacilityRepositoryProvider);
      await repo.uploadFacilityMedia(
        widget.kind,
        widget.facilityId,
        bytes: bytes,
        filename: picked.name.isNotEmpty ? picked.name : 'facility_photo.jpg',
      );

      ref.invalidate(
          facilityMediaProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo uploaded to facility gallery successfully!'),
          backgroundColor: Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload photo: $e'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  void _showAddPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Facility Photo',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFEFF6FF),
                  child: Icon(Icons.camera_alt_rounded,
                      color: Color(0xFF2563EB)),
                ),
                title: const Text('Take Photo with Camera',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadPhoto(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFECFDF5),
                  child: Icon(Icons.photo_library_rounded,
                      color: Color(0xFF059669)),
                ),
                title: const Text('Choose from Gallery',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadPhoto(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSetPrimary(FacilityMediaModel photo) async {
    try {
      setState(() => _uploadingPhoto = true);
      final repo = ref.read(clientFacilityRepositoryProvider);
      await repo.setPrimaryMedia(photo.id);
      ref.invalidate(
          facilityMediaProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primary cover photo updated!'),
          backgroundColor: Color(0xFF0D9488),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set cover photo: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _handleDeletePhoto(FacilityMediaModel photo) async {
    final confirm = await showAppConfirmDialog(
      context: context,
      title: 'Delete Photo',
      message:
          'Are you sure you want to permanently remove this photo from the facility gallery?',
      confirmLabel: 'Delete',
      type: ConfirmDialogType.danger,
      isDestructive: true,
    );
    if (!confirm) return;

    try {
      setState(() => _uploadingPhoto = true);
      final repo = ref.read(clientFacilityRepositoryProvider);
      await repo.deleteFacilityMedia(photo.id);
      ref.invalidate(
          facilityMediaProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo removed from gallery.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete photo: $e'),
          backgroundColor: const Color(0xFFDC2626),
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final f = widget.facility;
    final isGym = widget.kind == FacilityKind.gym;
    const brandBlue = Color(0xFF2563EB);
    final lightBg = isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder =
        isDark ? const Color(0xFF334155) : const Color(0xFFEDF2F7);

    final facilityTitle = isGym ? 'Gym' : 'Library';

    final mediaAsync =
        ref.watch(facilityMediaProvider((widget.kind, widget.facilityId)));
    final photos = mediaAsync.value ?? [];

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: cardBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit $facilityTitle',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              f?.name ?? '$facilityTitle Profile',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: _buildHeaderEmblem(isGym, isDark),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: cardBg,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF2563EB),
              indicatorWeight: 3,
              labelColor: const Color(0xFF2563EB),
              unselectedLabelColor:
                  isDark ? Colors.white60 : const Color(0xFF64748B),
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
              tabs: [
                const Tab(
                  iconMargin: EdgeInsets.only(bottom: 2),
                  icon: Icon(Icons.edit_note_rounded, size: 20),
                  text: 'Details & Amenities',
                ),
                Tab(
                  iconMargin: const EdgeInsets.only(bottom: 2),
                  icon: const Icon(Icons.photo_library_rounded, size: 19),
                  text: 'Photos (${photos.length})',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Details & Amenities
          _buildDetailsTab(
            f,
            isGym,
            isDark,
            cardBg,
            cardBorder,
            brandBlue,
            facilityTitle,
            theme,
          ),

          // Tab 2: Photos & Gallery
          _buildPhotosTab(
            photos,
            mediaAsync.isLoading,
            isGym,
            isDark,
            cardBg,
            cardBorder,
            brandBlue,
            facilityTitle,
            theme,
          ),
        ],
      ),
    );
  }

  // TAB 0: DETAILS & AMENITIES
  Widget _buildDetailsTab(
    FacilityModel? f,
    bool isGym,
    bool isDark,
    Color cardBg,
    Color cardBorder,
    Color brandBlue,
    String facilityTitle,
    ThemeData theme,
  ) {
    return FormBuilder(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 36),
        children: [
          // Identity Hero Card
          _buildIdentityHeroCard(f, isGym, isDark, cardBg, cardBorder, brandBlue),
          const SizedBox(height: 16),

          // Facility Name
          _buildInputFieldCard(
            icon: isGym
                ? Icons.fitness_center_rounded
                : Icons.storefront_rounded,
            iconBgColor: const Color(0xFFEFF6FF),
            iconColor: brandBlue,
            label: 'Facility Name',
            isDark: isDark,
            cardBg: cardBg,
            cardBorder: cardBorder,
            child: FormBuilderTextField(
              name: 'name',
              initialValue: f?.name ?? '',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Enter facility name',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Facility name is required'),
                FormBuilderValidators.minLength(3,
                    errorText: 'Must be at least 3 characters'),
              ]),
            ),
          ),
          const SizedBox(height: 14),

          // Full Address
          _buildInputFieldCard(
            icon: Icons.location_on_rounded,
            iconBgColor: const Color(0xFFEFF6FF),
            iconColor: brandBlue,
            label: 'Full Address',
            isDark: isDark,
            cardBg: cardBg,
            cardBorder: cardBorder,
            child: FormBuilderTextField(
              name: 'address',
              initialValue: f?.address ?? '',
              maxLines: 2,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Enter full street address',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: 'Address is required'),
              ]),
            ),
          ),
          const SizedBox(height: 14),

          // Contact Phone
          _buildInputFieldCard(
            icon: Icons.phone_rounded,
            iconBgColor: const Color(0xFFEFF6FF),
            iconColor: brandBlue,
            label: 'Contact Phone',
            isDark: isDark,
            cardBg: cardBg,
            cardBorder: cardBorder,
            child: FormBuilderTextField(
              name: 'contact_phone',
              initialValue: f?.contactPhone ?? '',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'e.g. 9876543210',
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Contact Email
          _buildInputFieldCard(
            icon: Icons.email_rounded,
            iconBgColor: const Color(0xFFEFF6FF),
            iconColor: brandBlue,
            label: 'Contact Email',
            isDark: isDark,
            cardBg: cardBg,
            cardBorder: cardBorder,
            child: FormBuilderTextField(
              name: 'contact_email',
              initialValue: f?.contactEmail ?? '',
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'contact@facility.com',
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Operating Hours Section
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 18, color: Color(0xFF334155)),
              const SizedBox(width: 8),
              Text(
                'Operating Hours',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Opening & Closing Hours
          Row(
            children: [
              Expanded(
                child: _buildOperatingTimeCard(
                  label: 'Opening Time',
                  timeDisplay: _formatTimeDisplay(_openingTime),
                  icon: Icons.wb_sunny_outlined,
                  iconBg: const Color(0xFFECFDF5),
                  iconColor: const Color(0xFF10B981),
                  isDark: isDark,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _openingTime ??
                          const TimeOfDay(hour: 6, minute: 0),
                    );
                    if (picked != null) {
                      setState(() => _openingTime = picked);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildOperatingTimeCard(
                  label: 'Closing Time',
                  timeDisplay: _formatTimeDisplay(_closingTime),
                  icon: Icons.nights_stay_outlined,
                  iconBg: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF9333EA),
                  isDark: isDark,
                  cardBg: cardBg,
                  cardBorder: cardBorder,
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _closingTime ??
                          const TimeOfDay(hour: 22, minute: 0),
                    );
                    if (picked != null) {
                      setState(() => _closingTime = picked);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Description Section
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  size: 18, color: Color(0xFF334155)),
              const SizedBox(width: 8),
              Text(
                'About & Description',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cardBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _descController,
              maxLines: 4,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                height: 1.4,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText:
                    'Share facility features, environment, training equipment or study areas...',
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Amenities Management Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.star_rounded,
                              size: 18, color: Color(0xFF2563EB)),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Available Amenities',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              '${_selectedAmenities.length} selected for public profile',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    FilledButton.tonalIcon(
                      onPressed: _handleOpenAmenitySelector,
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('Add / Manage',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: const Color(0xFFEFF6FF),
                        foregroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (_isLoadingAmenities)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_selectedAmenities.isEmpty)
                  InkWell(
                    onTap: _handleOpenAmenitySelector,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              color: Color(0xFF2563EB), size: 28),
                          SizedBox(height: 6),
                          Text(
                            'No amenities configured yet',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Color(0xFF2563EB)),
                          ),
                          Text(
                            'Tap here to add Wi-Fi, AC, Parking, Lockers...',
                            style:
                                TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in _selectedAmenities)
                        Chip(
                          avatar: Icon(_resolveAmenityIcon(a.name),
                              size: 15, color: const Color(0xFF2563EB)),
                          label: Text(a.name,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          deleteIcon: const Icon(Icons.close_rounded, size: 14),
                          onDeleted: () {
                            HapticFeedback.lightImpact();
                            setState(() => _selectedAmenities.removeWhere(
                                (item) => item.id == a.id));
                          },
                          backgroundColor: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFF1F5F9),
                          side: BorderSide(
                              color: const Color(0xFF2563EB)
                                  .withValues(alpha: 0.25)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Submit Changes Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _submitting ? null : _submitDetails,
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 20),
              label: Text(
                _submitting ? 'Saving Changes...' : 'Save $facilityTitle Details',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: brandBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: brandBlue.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TAB 1: PHOTOS & GALLERY
  Widget _buildPhotosTab(
    List<FacilityMediaModel> photos,
    bool isLoading,
    bool isGym,
    bool isDark,
    Color cardBg,
    Color cardBorder,
    Color brandBlue,
    String facilityTitle,
    ThemeData theme,
  ) {
    final primaryPhoto = photos.where((p) => p.isPrimary).firstOrNull ??
        photos.firstOrNull;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(
            facilityMediaProvider((widget.kind, widget.facilityId)));
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 36),
        children: [
          // Gallery Summary Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: Color(0xFF0D9488), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$facilityTitle Gallery',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${photos.length} photo(s) published for citizens',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: _uploadingPhoto ? null : _showAddPhotoOptions,
                  icon: _uploadingPhoto
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.add_a_photo_rounded, size: 16),
                  label: const Text('Add Photo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Primary Cover Banner
          if (primaryPhoto != null) ...[
            Text(
              'Primary Cover Photo',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.5),
                    width: 2),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 10,
                      offset: Offset(0, 3)),
                ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      ImageUrlResolver.resolve(primaryPhoto.url) ?? primaryPhoto.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                            child: Icon(Icons.broken_image_rounded, size: 40)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_rounded,
                              size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('MAIN COVER',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.black54,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: _showAddPhotoOptions,
                      icon: const Icon(Icons.edit_rounded, size: 14),
                      label: const Text('Change Cover',
                          style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // All Gallery Photos Grid Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Gallery Images',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              if (photos.isNotEmpty)
                Text('${photos.length} item(s)',
                    style: TextStyle(
                        fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 10),

          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (photos.isEmpty)
            Container(
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: cardBorder, width: 1.2),
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_photo_alternate_outlined,
                          size: 48, color: Color(0xFF0D9488)),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'No Photos Added Yet',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Upload photos of your ${facilityTitle.toLowerCase()} to attract more members and showcase amenities.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _showAddPhotoOptions,
                      icon: const Icon(Icons.upload_rounded, size: 16),
                      label: const Text('Upload First Photo'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final photo = photos[index];
                final isCover = photo.isPrimary;
                final resolvedUrl =
                    ImageUrlResolver.resolve(photo.url) ?? photo.url;

                return Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCover
                          ? const Color(0xFF0D9488)
                          : cardBorder,
                      width: isCover ? 2.0 : 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: isDark ? 0.2 : 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Photo Image with Cover Badge
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                resolvedUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.broken_image_rounded,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            if (isCover)
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0D9488),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Cover',
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Actions Row: Set Primary & Delete
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC),
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (!isCover)
                              TextButton.icon(
                                style: TextButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                ),
                                onPressed: () => _handleSetPrimary(photo),
                                icon: const Icon(Icons.star_border_rounded,
                                    size: 14, color: Color(0xFFD97706)),
                                label: const Text('Make Cover',
                                    style: TextStyle(
                                        fontSize: 10.5,
                                        color: Color(0xFFD97706),
                                        fontWeight: FontWeight.bold)),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text('Primary Cover',
                                    style: TextStyle(
                                        fontSize: 10.5,
                                        color: Color(0xFF0D9488),
                                        fontWeight: FontWeight.bold)),
                              ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.delete_outline_rounded,
                                  size: 18, color: Color(0xFFDC2626)),
                              onPressed: () => _handleDeletePhoto(photo),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // Header Emblem
  Widget _buildHeaderEmblem(bool isGym, bool isDark) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2563EB).withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: Center(
        child: Icon(
          isGym ? Icons.fitness_center_rounded : Icons.menu_book_rounded,
          color: const Color(0xFF2563EB),
          size: 20,
        ),
      ),
    );
  }

  // Identity Hero Card
  Widget _buildIdentityHeroCard(
    FacilityModel? f,
    bool isGym,
    bool isDark,
    Color cardBg,
    Color cardBorder,
    Color brandBlue,
  ) {
    final facilityName = f?.name ?? (isGym ? 'Gym Facility' : 'Library Hub');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isGym
                        ? Icons.fitness_center_rounded
                        : Icons.menu_book_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.edit_rounded,
                        size: 12, color: Color(0xFF2563EB)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGym ? 'GYM NAME' : 'LIBRARY NAME',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2563EB),
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  facilityName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.public_rounded,
                              size: 12, color: Color(0xFF059669)),
                          SizedBox(width: 4),
                          Text(
                            'Public Profile',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'This information is visible to users',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Input Field Card
  Widget _buildInputFieldCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required Widget child,
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 2),
                child,
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // Operating Time Card
  Widget _buildOperatingTimeCard({
    required String label,
    required String timeDisplay,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required bool isDark,
    required Color cardBg,
    required Color cardBorder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cardBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    timeDisplay,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
