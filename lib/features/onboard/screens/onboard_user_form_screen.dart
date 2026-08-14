import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/cities_providers.dart';
import '../../../core/providers/onboard_providers.dart';
import '../../../data/models/city_model.dart';
import '../../../shared/widgets/glass_container.dart';

class OnboardUserFormScreen extends ConsumerStatefulWidget {
  const OnboardUserFormScreen({super.key});

  @override
  ConsumerState<OnboardUserFormScreen> createState() =>
      _OnboardUserFormScreenState();
}

class _OnboardUserFormScreenState extends ConsumerState<OnboardUserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  CityModel? _selectedCity;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardDraftControllerProvider);
    _nameController = TextEditingController(text: draft.name);
    _emailController = TextEditingController(text: draft.email);
    _phoneController = TextEditingController(text: draft.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your city'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ref.read(onboardDraftControllerProvider.notifier).updateBasicDetails(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          cityId: _selectedCity!.id,
          cityName: _selectedCity!.name,
        );

    context.push('/onboard/review');
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF6366F1);
    final citiesAsync = ref.watch(citiesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Onboard — Basic Details'),
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
                      // Progress Dots (Step 1 of 2)
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
                        'Let\'s start with some basic information',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Full Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          hintText: 'Rahul Sharma',
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter full name'
                            : null,
                      ),
                      const SizedBox(height: 18),

                      // Email Address
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'rahul.sharma@email.com',
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

                      // Mobile Number
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          hintText: '+91 98765 43210',
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter mobile number'
                            : null,
                      ),
                      const SizedBox(height: 18),

                      // City Dropdown
                      citiesAsync.when(
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator.adaptive(),
                          ),
                        ),
                        error: (_, _) => TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City',
                            hintText: 'Select city',
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
