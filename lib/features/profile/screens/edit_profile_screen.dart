import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/api/app_exception.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/users_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/searchable_city_picker.dart';
import '../../../shared/widgets/user_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitting = false;
  bool _uploadingPhoto = false;
  String? _selectedCityId;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).value;
    _selectedCityId = user?.city?.id ?? user?.cityId;
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
      final message =
          appException?.message.isNotEmpty == true
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
      final message =
          appException?.message.isNotEmpty == true
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
    final hasPhoto =
        user.effectiveAvatarUrl != null &&
        user.effectiveAvatarUrl!.trim().isNotEmpty;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
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
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    setState(() => _submitting = true);
    final v = form.value;
    try {
      await ref
          .read(usersRepositoryProvider)
          .update(
            user.id,
            name: v['name'] as String?,
            email: v['email'] as String?,
            phone: v['phone'] as String?,
            cityId: _selectedCityId ?? (v['city'] as String?),
          );
      await ref.read(authControllerProvider.notifier).refreshMe();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.saveChanges)));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      final appException = AppException.from(e);
      final message =
          appException?.fieldErrors?.values.firstOrNull?.firstOrNull ??
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(authControllerProvider);

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfile)),
      body: AmbientBackground(
        child: userAsync.when(
          loading: () => const LoadingIndicator(),
          error: (_, _) => Center(child: Text(l10n.errorGeneric)),
          data: (user) {
            if (user == null) return const SizedBox.shrink();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: FormBuilder(
                key: _formKey,
                initialValue: {
                  'name': user.name,
                  'email': user.email,
                  'phone': user.phone ?? '',
                  'city': user.cityId,
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap:
                            _uploadingPhoto
                                ? null
                                : () => _showPhotoOptions(context, user),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            UserAvatar(
                              user: user,
                              radius: 46,
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.3),
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
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0D9488),
                                      Color(0xFF0284C7),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(
                                          context,
                                        ).scaffoldBackgroundColor,
                                    width: 2.5,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed:
                            _uploadingPhoto
                                ? null
                                : () => _showPhotoOptions(context, user),
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 16,
                        ),
                        label: const Text('Change Photo'),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'name',
                      decoration: InputDecoration(
                        labelText: l10n.fullName,
                        prefixIcon: Icon(
                          Icons.person_rounded,
                          color: scheme.primary,
                        ),
                      ),
                      validator: FormBuilderValidators.required(
                        errorText: l10n.requiredField,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: InputDecoration(
                        labelText: l10n.emailAddress,
                        prefixIcon: Icon(
                          Icons.email_rounded,
                          color: scheme.primary,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                          errorText: l10n.requiredField,
                        ),
                        FormBuilderValidators.email(
                          errorText: l10n.invalidEmail,
                        ),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    FormBuilderTextField(
                      name: 'phone',
                      decoration: InputDecoration(
                        labelText: l10n.mobileNumber,
                        prefixIcon: Icon(
                          Icons.phone_rounded,
                          color: scheme.primary,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.match(
                        RegExp(r'^\+?[0-9]{7,15}$'),
                        errorText: l10n.invalidPhone,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SearchableCityPicker(
                      selectedCityId: _selectedCityId ?? user.city?.id ?? user.cityId,
                      labelText: l10n.selectYourCity,
                      prefixIcon: Icon(
                        Icons.location_city_rounded,
                        color: scheme.primary,
                      ),
                      onCitySelected: (city) {
                        setState(() {
                          _selectedCityId = city.id;
                        });
                        _formKey.currentState?.patchValue({'city': city.id});
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child:
                          _submitting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(l10n.saveChanges),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
