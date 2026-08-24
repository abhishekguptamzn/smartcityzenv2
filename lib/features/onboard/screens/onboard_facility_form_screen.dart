import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../core/providers/onboard_providers.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/onboard_model.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading/shimmer.dart';
import '../../../shared/widgets/loading/skeleton_primitives.dart';

class OnboardFacilityFormScreen extends ConsumerStatefulWidget {
  const OnboardFacilityFormScreen({
    super.key,
    required this.type,
  });

  final OnboardType type;

  @override
  ConsumerState<OnboardFacilityFormScreen> createState() =>
      _OnboardFacilityFormScreenState();
}

class _OnboardFacilityFormScreenState
    extends ConsumerState<OnboardFacilityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  CityModel? _selectedCity;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardDraftControllerProvider);
    _nameController = TextEditingController(text: draft.name);
    _emailController = TextEditingController(text: draft.email);
    _phoneController = TextEditingController(text: draft.phone);
    _addressController = TextEditingController(text: draft.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Color _getAccentColor() {
    return widget.type == OnboardType.library
        ? const Color(0xFF10B981)
        : const Color(0xFFF97316);
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a city'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ref.read(onboardDraftControllerProvider.notifier).updateBasicDetails(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          cityId: _selectedCity!.id,
          cityName: _selectedCity!.name,
        );

    context.push('/onboard/facility/owner/${widget.type.name}');
  }

  @override
  Widget build(BuildContext context) {
    final accent = _getAccentColor();
    final isLibrary = widget.type == OnboardType.library;
    final facilityLabel = isLibrary ? 'Library' : 'Gym';
    final citiesAsync = ref.watch(citiesListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/onboard');
            }
          },
        ),
        title: Text('$facilityLabel Onboard — Basic Details'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    children: [
                      // Progress Dots (Step 1 of 3)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 8,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        'Basic Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tell us about your ${facilityLabel.toLowerCase()}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Facility Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: '$facilityLabel Name',
                          hintText: isLibrary
                              ? 'City Central Library'
                              : 'PowerFit Gym',
                          prefixIcon: Icon(
                            isLibrary
                                ? Icons.menu_book_rounded
                                : Icons.fitness_center_rounded,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter $facilityLabel name'
                            : null,
                      ),
                      const SizedBox(height: 18),

                      // Email Address
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: isLibrary
                              ? 'library@citycentral.com'
                              : 'powerfit.gym@email.com',
                          prefixIcon: const Icon(Icons.mail_outline_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!v.contains('@') || !v.contains('.')) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Contact Number
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Contact Number',
                          hintText: '10-digit mobile number',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Please enter contact number';
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(v.trim())) {
                            return 'Contact number must be exactly 10 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          hintText: isLibrary
                              ? '123 Library Road, Central Square'
                              : '456 Fitness Street, North Block',
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter address'
                            : null,
                      ),
                      const SizedBox(height: 18),

                      // City Dropdown
                      citiesAsync.when(
                        loading: () => const Shimmer(
                          child: SkeletonInput(height: 56),
                        ),
                        error: (_, _) => TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        data: (cities) {
                          if (_selectedCity == null && cities.isNotEmpty) {
                            final draft =
                                ref.read(onboardDraftControllerProvider);
                            _selectedCity = cities.firstWhere(
                              (c) => c.id == draft.cityId,
                              orElse: () => cities.first,
                            );
                          }

                          return DropdownButtonFormField<CityModel>(
                            initialValue: _selectedCity,
                            decoration: InputDecoration(
                              labelText: 'City',
                              prefixIcon:
                                  const Icon(Icons.location_city_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            items: cities.map((city) {
                              return DropdownMenuItem<CityModel>(
                                value: city,
                                child: Text('${city.name}, ${city.state}'),
                              );
                            }).toList(),
                            onChanged: (city) {
                              setState(() {
                                _selectedCity = city;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Continue Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _onContinue,
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
