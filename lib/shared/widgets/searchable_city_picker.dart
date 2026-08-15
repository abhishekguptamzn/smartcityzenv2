import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/cities_providers.dart';
import '../../data/models/city_model.dart';

/// A modern, searchable city picker that opens a modal bottom sheet
/// with real-time text filtering and instant selection.
class SearchableCityPicker extends ConsumerStatefulWidget {
  const SearchableCityPicker({
    super.key,
    required this.selectedCityId,
    required this.onCitySelected,
    this.labelText = 'Select City',
    this.prefixIcon,
    this.validator,
  });

  final String? selectedCityId;
  final ValueChanged<CityModel> onCitySelected;
  final String labelText;
  final Widget? prefixIcon;
  final FormFieldValidator<String>? validator;

  @override
  ConsumerState<SearchableCityPicker> createState() =>
      _SearchableCityPickerState();
}

class _SearchableCityPickerState extends ConsumerState<SearchableCityPicker> {
  @override
  Widget build(BuildContext context) {
    final citiesAsync = ref.watch(citiesListProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return citiesAsync.when(
      data: (cities) {
        CityModel? selectedCity;
        if (widget.selectedCityId != null) {
          try {
            selectedCity = cities.firstWhere(
              (c) => c.id == widget.selectedCityId,
            );
          } catch (_) {}
        }

        return FormField<String>(
          initialValue: widget.selectedCityId,
          validator: widget.validator,
          builder: (fieldState) {
            final hasError = fieldState.hasError;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => _openCitySearchSheet(context, cities, selectedCity),
                  borderRadius: BorderRadius.circular(14),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: widget.labelText,
                      prefixIcon: widget.prefixIcon ??
                          Icon(
                            Icons.location_city_rounded,
                            color: scheme.primary,
                          ),
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 24,
                      ),
                      errorText: fieldState.errorText,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      selectedCity?.name ?? 'Search and select your city…',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: selectedCity != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selectedCity != null
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                if (hasError && fieldState.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text(
                      fieldState.errorText!,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(minHeight: 3),
      ),
      error: (_, _) => Text(
        'Failed to load cities directory',
        style: TextStyle(color: scheme.error),
      ),
    );
  }

  void _openCitySearchSheet(
    BuildContext context,
    List<CityModel> allCities,
    CityModel? currentCity,
  ) {
    showModalBottomSheet<CityModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CitySearchBottomSheet(
        cities: allCities,
        selectedCity: currentCity,
      ),
    ).then((chosen) {
      if (chosen != null) {
        widget.onCitySelected(chosen);
      }
    });
  }
}

class _CitySearchBottomSheet extends StatefulWidget {
  const _CitySearchBottomSheet({
    required this.cities,
    required this.selectedCity,
  });

  final List<CityModel> cities;
  final CityModel? selectedCity;

  @override
  State<_CitySearchBottomSheet> createState() => _CitySearchBottomSheetState();
}

class _CitySearchBottomSheetState extends State<_CitySearchBottomSheet> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<CityModel> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = List.from(widget.cities);
    _searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCities = List.from(widget.cities);
      } else {
        _filteredCities = widget.cities.where((c) {
          final nameMatch = c.name.toLowerCase().contains(query);
          final stateMatch = c.state.toLowerCase().contains(query);
          return nameMatch || stateMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      margin: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: viewInsets.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle pill
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: scheme.outlineVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Header title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_city_rounded,
                    color: scheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Smart City',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Search across all verified citizen hubs',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search city or state (e.g. Muzaffarnagar, Delhi)...',
                hintStyle: TextStyle(
                  fontSize: 13.5,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => _searchCtrl.clear(),
                      )
                    : null,
                filled: true,
                fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Results List
          Flexible(
            child: _filteredCities.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_off_rounded,
                            size: 40,
                            color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No matching cities found',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _filteredCities.length,
                    separatorBuilder: (_, _) => const Divider(
                      height: 1,
                      indent: 60,
                      endIndent: 16,
                    ),
                    itemBuilder: (ctx, idx) {
                      final city = _filteredCities[idx];
                      final isSelected = widget.selectedCity?.id == city.id;

                      return ListTile(
                        onTap: () => Navigator.of(context).pop(city),
                        shape: RoundedRectangleMul(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [Color(0xFF0D9488), Color(0xFF0284C7)],
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : scheme.surfaceContainerHighest.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.apartment_rounded,
                            size: 20,
                            color: isSelected ? Colors.white : scheme.primary,
                          ),
                        ),
                        title: Text(
                          city.name,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 14.5,
                            color: isSelected ? scheme.primary : null,
                          ),
                        ),
                        subtitle: city.state.isNotEmpty
                            ? Text(
                                city.state,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: scheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                        trailing: isSelected
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0D9488),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      );
                    },
                  ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class RoundedRectangleMul extends RoundedRectangleBorder {
  const RoundedRectangleMul({super.borderRadius});
}
