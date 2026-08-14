import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/onboard_providers.dart';
import '../../../data/models/onboard_model.dart';
import '../../../shared/widgets/glass_container.dart';

class OnboardSelectOwnerScreen extends ConsumerStatefulWidget {
  const OnboardSelectOwnerScreen({
    super.key,
    required this.type,
  });

  final OnboardType type;

  @override
  ConsumerState<OnboardSelectOwnerScreen> createState() =>
      _OnboardSelectOwnerScreenState();
}

class _OnboardSelectOwnerScreenState
    extends ConsumerState<OnboardSelectOwnerScreen> {
  final _searchController = TextEditingController();
  String _debouncedQuery = '';
  Timer? _debounceTimer;
  OwnerSearchResult? _selectedOwner;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(onboardDraftControllerProvider);
    if (draft.ownerId.isNotEmpty) {
      _selectedOwner = OwnerSearchResult(
        id: draft.ownerId,
        name: draft.ownerName,
        email: draft.ownerEmail,
        avatar: draft.ownerAvatar,
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _debouncedQuery = query.trim();
        });
      }
    });
  }

  Color _getAccentColor() {
    return widget.type == OnboardType.library
        ? const Color(0xFF10B981)
        : const Color(0xFFF97316);
  }

  void _onContinue() {
    if (_selectedOwner == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an owner for this facility'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    ref
        .read(onboardDraftControllerProvider.notifier)
        .selectOwner(_selectedOwner!);

    context.push('/onboard/review');
  }

  @override
  Widget build(BuildContext context) {
    final accent = _getAccentColor();
    final isLibrary = widget.type == OnboardType.library;
    final facilityLabel = isLibrary ? 'Library' : 'Gym';
    final ownersAsync =
        ref.watch(searchOwnersProvider(query: _debouncedQuery));

    return Scaffold(
      appBar: AppBar(
        title: Text('$facilityLabel Onboard — Owner'),
        centerTitle: true,
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  children: [
                    // Progress Dots (Step 2 of 3)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                      'Select Owner',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Search and select the owner from existing users',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search input
                    TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        labelText: 'Search owner',
                        hintText: 'Search by name or email',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      _debouncedQuery.isEmpty
                          ? 'Popular Owners'
                          : 'Search Results',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ownersAsync.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      error: (err, _) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Failed to load users: $err',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      data: (users) {
                        if (users.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_search_rounded,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No users found matching "$_debouncedQuery"',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: users.map((user) {
                            final isSelected = _selectedOwner?.id == user.id;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isSelected
                                      ? accent
                                      : Colors.grey.shade200,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    _selectedOwner = user;
                                  });
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      accent.withValues(alpha: 0.15),
                                  child: Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: accent,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.5,
                                  ),
                                ),
                                subtitle: Text(
                                  user.email,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Icon(
                                        Icons.check_circle_rounded,
                                        color: accent,
                                        size: 24,
                                      )
                                    : const Icon(
                                        Icons.chevron_right_rounded,
                                        size: 20,
                                      ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
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
