import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/api/app_exception.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/users_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/searchable_city_picker.dart';
import '../../../shared/widgets/user_avatar.dart';

enum ProfileTab {
  personal('Personal', Icons.person_outline_rounded, Icons.person_rounded),
  professional('Professional', Icons.business_center_outlined, Icons.business_center_rounded),
  location('Location', Icons.location_on_outlined, Icons.location_on_rounded),
  about('About', Icons.favorite_border_rounded, Icons.favorite_rounded);

  const ProfileTab(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  ProfileTab _activeTab = ProfileTab.personal;
  bool _submitting = false;
  bool _uploadingPhoto = false;

  // Personal Tab
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDob;
  String _selectedGender = 'Male';

  // Professional Tab
  final _professionController = TextEditingController();
  final _companyController = TextEditingController();
  String _selectedExperience = '4+ Years';
  final _educationController = TextEditingController();
  final List<String> _skills = ['Flutter', 'Firebase', 'Laravel'];

  // Location Tab
  String? _selectedCityId;
  final _localityController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _landmarkController = TextEditingController();

  // About Tab
  final List<String> _languages = ['English', 'Hindi'];
  final List<String> _interests = ['Fitness', 'Traveling'];
  final _bioController = TextEditingController();
  final List<String> _hobbies = ['Gym', 'Music', 'Reading'];
  String _selectedVisibility = 'public';

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _bioController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    _companyController.dispose();
    _educationController.dispose();
    _localityController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _populateUser(UserModel user) {
    if (_initialized) return;
    _initialized = true;

    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';

    if (user.dob != null && user.dob!.isNotEmpty) {
      try {
        _selectedDob = DateTime.parse(user.dob!);
      } catch (_) {}
    }

    if (user.gender != null && user.gender!.isNotEmpty) {
      _selectedGender = user.gender!;
    }

    _selectedCityId = user.city?.id ?? user.cityId;
    _localityController.text = user.locality ?? '';
    _addressController.text = user.address ?? '';
    _pincodeController.text = user.pincode ?? '';
    _landmarkController.text = user.landmark ?? '';

    _professionController.text = user.profession ?? 'Software Developer';
    _companyController.text = user.company ?? 'Tech Solutions Pvt. Ltd.';
    if (user.workExperience != null && user.workExperience!.isNotEmpty) {
      _selectedExperience = user.workExperience!;
    }
    _educationController.text = user.education ?? 'B.Tech in Computer Science';

    if (user.skills != null && user.skills!.isNotEmpty) {
      _skills.clear();
      _skills.addAll(user.skills!);
    }

    if (user.languages != null && user.languages!.isNotEmpty) {
      _languages.clear();
      _languages.addAll(user.languages!);
    }

    if (user.interests != null && user.interests!.isNotEmpty) {
      _interests.clear();
      _interests.addAll(user.interests!);
    }

    _bioController.text = user.bio ?? 'Love exploring new places, fitness enthusiast and tech lover.';

    if (user.hobbies != null && user.hobbies!.isNotEmpty) {
      _hobbies.clear();
      _hobbies.addAll(user.hobbies!);
    }

    _selectedVisibility = user.profileVisibility;
  }

  int _calculateLocalCompletion(UserModel? user) {
    int total = 15;
    int filled = 0;

    if (_nameController.text.trim().isNotEmpty) filled++;
    if (_emailController.text.trim().isNotEmpty) filled++;
    if (_phoneController.text.trim().isNotEmpty) filled++;
    if (user?.effectiveAvatarUrl != null) filled++;
    if (_selectedDob != null) filled++;
    if (_selectedGender.isNotEmpty) filled++;
    if (_selectedCityId != null) filled++;
    if (_addressController.text.trim().isNotEmpty || _localityController.text.trim().isNotEmpty) filled++;
    if (_professionController.text.trim().isNotEmpty) filled++;
    if (_companyController.text.trim().isNotEmpty) filled++;
    if (_educationController.text.trim().isNotEmpty) filled++;
    if (_skills.isNotEmpty) filled++;
    if (_languages.isNotEmpty) filled++;
    if (_interests.isNotEmpty || _hobbies.isNotEmpty) filled++;
    if (_bioController.text.trim().isNotEmpty) filled++;

    return ((filled / total) * 100).round();
  }

  Future<void> _pickAndUploadPhoto(ImageSource source, UserModel user) async {
    final l10n = AppLocalizations.of(context);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (picked == null) return;

      setState(() => _uploadingPhoto = true);
      final bytes = await picked.readAsBytes();

      await ref.read(usersRepositoryProvider).uploadPhoto(
            user.id,
            bytes: bytes,
            filename: picked.name.isNotEmpty ? picked.name : 'avatar.jpg',
          );
      await ref.read(authControllerProvider.notifier).refreshMe();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo updated successfully.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF0D9488),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final appException = AppException.from(e);
      final message = appException?.message.isNotEmpty == true
          ? appException!.message
          : l10n.errorGeneric;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _removePhoto(UserModel user) async {
    final l10n = AppLocalizations.of(context);
    try {
      setState(() => _uploadingPhoto = true);
      await ref.read(usersRepositoryProvider).deletePhoto(user.id);
      await ref.read(authControllerProvider.notifier).refreshMe();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo removed.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final appException = AppException.from(e);
      final message = appException?.message.isNotEmpty == true
          ? appException!.message
          : l10n.errorGeneric;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  void _showPhotoOptions(BuildContext context, UserModel user) {
    final scheme = Theme.of(context).colorScheme;
    final hasPhoto = user.effectiveAvatarUrl != null && user.effectiveAvatarUrl!.trim().isNotEmpty;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Change Profile Photo',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFF0D9488),
                  ),
                ),
                title: const Text('Take Photo'),
                subtitle: const Text('Use camera to take a new picture'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _pickAndUploadPhoto(ImageSource.camera, user);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: Color(0xFF0284C7),
                  ),
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select a photo from your library'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _pickAndUploadPhoto(ImageSource.gallery, user);
                },
              ),
              if (hasPhoto)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Color(0xFFDC2626)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    _removePhoto(user);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your full name.'), behavior: SnackBarBehavior.floating),
      );
      setState(() => _activeTab = ProfileTab.personal);
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.'), behavior: SnackBarBehavior.floating),
      );
      setState(() => _activeTab = ProfileTab.personal);
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(usersRepositoryProvider).update(
            user.id,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            dob: _selectedDob != null ? DateFormat('yyyy-MM-dd').format(_selectedDob!) : null,
            gender: _selectedGender,
            cityId: _selectedCityId,
            locality: _localityController.text.trim(),
            address: _addressController.text.trim(),
            pincode: _pincodeController.text.trim(),
            landmark: _landmarkController.text.trim(),
            profession: _professionController.text.trim(),
            company: _companyController.text.trim(),
            workExperience: _selectedExperience,
            education: _educationController.text.trim(),
            skills: _skills,
            languages: _languages,
            interests: _interests,
            bio: _bioController.text.trim(),
            hobbies: _hobbies,
            profileVisibility: _selectedVisibility,
          );

      await ref.read(authControllerProvider.notifier).refreshMe();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final appException = AppException.from(e);
      final message = appException?.fieldErrors?.values.firstOrNull?.firstOrNull ??
          (appException != null && appException.message.isNotEmpty
              ? appException.message
              : l10n.errorGeneric);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showAddChipDialog(String title, List<String> targetList) {
    final textCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add $title'),
        content: TextField(
          controller: textCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter $title',
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (val) {
            final v = val.trim();
            if (v.isNotEmpty && !targetList.contains(v)) {
              setState(() => targetList.add(v));
            }
            Navigator.pop(ctx);
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final v = textCtrl.text.trim();
              if (v.isNotEmpty && !targetList.contains(v)) {
                setState(() => targetList.add(v));
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(authControllerProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: FilledButton(
            onPressed: _submitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
      body: AmbientBackground(
        child: userAsync.when(
          loading: () => const LoadingIndicator(),
          error: (_, _) => Center(child: Text(l10n.errorGeneric)),
          data: (user) {
            if (user == null) return const SizedBox.shrink();
            _populateUser(user);

            final completionPercent = _calculateLocalCompletion(user);

            return Column(
              children: [
                // Top Custom 4-Tab Navigation Selector
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: ProfileTab.values.map((tab) {
                      final isSelected = _activeTab == tab;
                      return Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _activeTab = tab),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSelected ? tab.activeIcon : tab.icon,
                                  color: isSelected ? const Color(0xFF2563EB) : scheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tab.label,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? const Color(0xFF2563EB) : scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Active Tab Content View
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      if (_activeTab == ProfileTab.personal)
                        _buildPersonalTab(user, completionPercent),
                      if (_activeTab == ProfileTab.professional)
                        _buildProfessionalTab(),
                      if (_activeTab == ProfileTab.location)
                        _buildLocationTab(),
                      if (_activeTab == ProfileTab.about)
                        _buildAboutTab(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: PERSONAL
  // ==========================================
  Widget _buildPersonalTab(UserModel user, int completionPercent) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final dobFormatted = _selectedDob != null
        ? DateFormat('d MMM yyyy').format(_selectedDob!)
        : 'Select Date of Birth';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Completion & Avatar Row Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              // Avatar with camera badge
              GestureDetector(
                onTap: _uploadingPhoto ? null : () => _showPhotoOptions(context, user),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    UserAvatar(
                      user: user,
                      radius: 38,
                      border: Border.all(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.4),
                        width: 2.5,
                      ),
                    ),
                    if (_uploadingPhoto)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0x66000000),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),

              // Progress Bar & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Completion',
                      style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completionPercent% Complete',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: completionPercent / 100.0,
                        minHeight: 6,
                        backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keep going!',
                      style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Basic Information Section Header
        const Text(
          'Basic Information',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Full Name Field
        _buildInputField(
          label: 'Full Name *',
          icon: Icons.person_outline_rounded,
          controller: _nameController,
        ),
        const SizedBox(height: 12),

        // Date of Birth Field (DatePicker)
        _buildTapField(
          label: 'Date of Birth',
          icon: Icons.calendar_today_rounded,
          value: dobFormatted,
          hasChevron: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDob ?? DateTime(1995, 8, 15),
              firstDate: DateTime(1940),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() => _selectedDob = picked);
            }
          },
        ),
        const SizedBox(height: 12),

        // Gender Dropdown
        _buildDropdownField(
          label: 'Gender',
          icon: Icons.wc_rounded,
          value: _selectedGender,
          items: const ['Male', 'Female', 'Other', 'Prefer not to say'],
          onChanged: (val) {
            if (val != null) setState(() => _selectedGender = val);
          },
        ),
        const SizedBox(height: 12),

        // 2-Col Row: Email & Phone
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'Email Address *',
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildInputField(
                label: 'Mobile Number *',
                icon: Icons.phone_outlined,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Required fields note
        Text(
          '* Required fields',
          style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant.withValues(alpha: 0.8)),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 2: PROFESSIONAL
  // ==========================================
  Widget _buildProfessionalTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Work Information',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Profession Field / Dropdown
        _buildDropdownOrInputField(
          label: 'Profession',
          icon: Icons.business_center_outlined,
          controller: _professionController,
          options: const [
            'Software Developer',
            'UI/UX Designer',
            'Product Manager',
            'Civil Engineer',
            'Doctor',
            'Teacher / Professor',
            'Business Owner / Entrepreneur',
            'Student',
            'Lawyer',
            'Accountant',
            'Other',
          ],
        ),
        const SizedBox(height: 12),

        // Company / Organization
        _buildInputField(
          label: 'Company / Organization',
          icon: Icons.apartment_rounded,
          controller: _companyController,
        ),
        const SizedBox(height: 12),

        // Work Experience
        _buildDropdownField(
          label: 'Work Experience (Optional)',
          icon: Icons.access_time_rounded,
          value: _selectedExperience,
          items: const [
            'Fresher / 0-1 Years',
            '1-3 Years',
            '4+ Years',
            '7+ Years',
            '10+ Years',
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedExperience = val);
          },
        ),
        const SizedBox(height: 12),

        // Education
        _buildDropdownOrInputField(
          label: 'Education (Optional)',
          icon: Icons.school_outlined,
          controller: _educationController,
          options: const [
            'B.Tech in Computer Science',
            'B.E. / B.Tech',
            'B.Sc / M.Sc',
            'B.Com / M.Com',
            'MBA / PGDM',
            'Doctorate / Ph.D',
            'High School / Intermediate',
            'Other',
          ],
        ),
        const SizedBox(height: 12),

        // Skills (Optional) Chips Box
        _buildChipsInputBox(
          label: 'Skills (Optional)',
          icon: Icons.star_border_rounded,
          chips: _skills,
          onAddTap: () => _showAddChipDialog('Skill', _skills),
          onRemoveTap: (item) => setState(() => _skills.remove(item)),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: LOCATION
  // ==========================================
  Widget _buildLocationTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location Details',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Select Your City * (Searchable picker)
        SearchableCityPicker(
          selectedCityId: _selectedCityId,
          labelText: 'Select Your City *',
          prefixIcon: const Icon(Icons.apartment_rounded, color: Color(0xFF0284C7), size: 20),
          onCitySelected: (city) {
            setState(() => _selectedCityId = city.id);
          },
        ),
        const SizedBox(height: 12),

        // Locality / Area
        _buildInputField(
          label: 'Locality / Area (Optional)',
          icon: Icons.map_outlined,
          controller: _localityController,
        ),
        const SizedBox(height: 12),

        // Address (Optional)
        _buildInputField(
          label: 'Address (Optional)',
          icon: Icons.home_outlined,
          controller: _addressController,
          maxLines: 2,
        ),
        const SizedBox(height: 12),

        // 2-Col Row: Pincode & Landmark
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                label: 'Pincode (Optional)',
                icon: Icons.pin_drop_outlined,
                controller: _pincodeController,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildInputField(
                label: 'Nearby Landmark (Optional)',
                icon: Icons.outlined_flag_rounded,
                controller: _landmarkController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // TAB 4: ABOUT
  // ==========================================
  Widget _buildAboutTab() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bioLength = _bioController.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'More About You',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Languages & Interests Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildChipsInputBox(
                label: 'Languages Known (Optional)',
                icon: Icons.language_rounded,
                chips: _languages,
                onAddTap: () => _showAddChipDialog('Language', _languages),
                onRemoveTap: (item) => setState(() => _languages.remove(item)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildChipsInputBox(
                label: 'Interests (Optional)',
                icon: Icons.star_border_rounded,
                chips: _interests,
                onAddTap: () => _showAddChipDialog('Interest', _interests),
                onRemoveTap: (item) => setState(() => _interests.remove(item)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Bio (Optional) with Character Counter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Text(
                    'Bio (Optional)',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: scheme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _bioController,
                maxLength: 120,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tell others a little about yourself...',
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '$bioLength/120',
                  style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Hobbies (Optional)
        _buildChipsInputBox(
          label: 'Hobbies (Optional)',
          icon: Icons.sports_esports_outlined,
          chips: _hobbies,
          onAddTap: () => _showAddChipDialog('Hobby', _hobbies),
          onRemoveTap: (item) => setState(() => _hobbies.remove(item)),
        ),
        const SizedBox(height: 12),

        // Profile Visibility
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF0284C7)),
                  const SizedBox(width: 8),
                  Text(
                    'Profile Visibility',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: scheme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedVisibility,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'public', child: Text('Public', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                    DropdownMenuItem(value: 'private', child: Text('Private', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedVisibility = val);
                  },
                ),
              ),
              Text(
                'This info will be visible to other users in the app.',
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SHARED REUSABLE INPUT WIDGETS
  // ==========================================
  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF0D9488)),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: label.contains('*') ? const Color(0xFF0D9488) : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapField({
    required String label,
    required IconData icon,
    required String value,
    required VoidCallback onTap,
    bool hasChevron = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0284C7).withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Icon(icon, size: 16, color: const Color(0xFF0284C7)),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            if (hasChevron)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveValue = items.contains(value) ? value : items.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF8B5CF6)),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: effectiveValue,
              isExpanded: true,
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownOrInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required List<String> options,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF0D9488)),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                icon: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.arrow_drop_down_rounded, size: 20),
                ),
                tooltip: 'Select $label',
                onSelected: (val) {
                  controller.text = val;
                  setState(() {});
                },
                itemBuilder: (ctx) => options.map((opt) => PopupMenuItem(value: opt, child: Text(opt))).toList(),
              ),
            ],
          ),
          const SizedBox(height: 2),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsInputBox({
    required String label,
    required IconData icon,
    required List<String> chips,
    required VoidCallback onAddTap,
    required ValueChanged<String> onRemoveTap,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFFD97706)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final chip in chips)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        chip,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurface),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => onRemoveTap(chip),
                        child: Icon(Icons.close_rounded, size: 14, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              InkWell(
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF0D9488).withValues(alpha: 0.35)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 15, color: Color(0xFF0D9488)),
                      SizedBox(width: 3),
                      Text(
                        'Add',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

