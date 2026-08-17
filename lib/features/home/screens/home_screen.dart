import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/cities_providers.dart';
import '../../../core/providers/facilities_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/models/my_membership_summary.dart';
import '../../../data/models/user_model.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/user_avatar.dart';
import '../widgets/citizen_qr_modal.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String value) {
    if (value.trim().isEmpty) {
      context.push('/services');
      return;
    }
    context.push('/services?search=${Uri.encodeQueryComponent(value.trim())}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authControllerProvider).value;
    final membershipsAsync = ref.watch(myMembershipSummariesProvider);
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => context.push('/profile'),
              child: UserAvatar(
                user: user,
                radius: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.welcomeBack,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    user?.name ?? '',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          if (user?.isOnboardingUser == true)
            IconButton(
              tooltip: 'Onboard User / Facility',
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 18,
                  color: Color(0xFF6366F1),
                ),
              ),
              onPressed: () => context.push('/onboard'),
            ),
          const SizedBox(width: 2),
          IconButton(
            tooltip: l10n.comingSoon,
            icon: Icon(
              Icons.notifications_none_rounded,
              color: scheme.onSurfaceVariant,
            ),
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.comingSoon))),
          ),
          IconButton(
            tooltip: l10n.comingSoon,
            icon: Icon(
              Icons.chat_bubble_outline_rounded,
              color: scheme.onSurfaceVariant,
            ),
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.comingSoon))),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AmbientBackground(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myMembershipSummariesProvider);
            await ref.read(myMembershipSummariesProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _CityzenIdHeroCard(user: user),
              const SizedBox(height: 16),
              _DashboardQuickActions(user: user),
              if (user?.isClientUser == true) ...[
                const SizedBox(height: 16),
                const _ClientFacilityHubBanner(),
              ],
              if (user?.isOnboardingUser == true) ...[
                const SizedBox(height: 16),
                const _OnboardHubBanner(),
              ],
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: _submitSearch,
                      decoration: InputDecoration(
                        hintText: l10n.searchServicesHint,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: scheme.onSurfaceVariant,
                        ),
                        filled: true,
                        fillColor: scheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(999),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _SearchFilterButton(onTap: () => context.push('/services')),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.exploreCityServices,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () => context.push('/services'),
                    child: Text(l10n.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ServiceGrid(l10n: l10n, user: user),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.myMemberships,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  TextButton(
                    onPressed: () => context.push('/profile'),
                    child: Text(l10n.manage),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              membershipsAsync.when(
                loading: () =>
                    const SizedBox(height: 96, child: LoadingIndicator()),
                error: (_, _) => EmptyStateView(
                  icon: Icons.error_outline_rounded,
                  message: l10n.errorGeneric,
                ),
                data: (summaries) {
                  if (summaries.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.card_membership_rounded,
                      message: l10n.noMembershipsYet,
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < summaries.length; i++) ...[
                        if (i > 0) const SizedBox(height: 12),
                        _MembershipCard(summary: summaries[i]),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                l10n.myCity,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              _MyCitySection(l10n: l10n),
              const SizedBox(height: 24),
              _OneAppPromoBanner(l10n: l10n),
            ],
          ),
        ),
      ),
    ),
  );
}
}

class _SearchFilterButton extends StatelessWidget {
  const _SearchFilterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          child: Icon(Icons.tune_rounded, color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _OneAppPromoBanner extends StatelessWidget {
  const _OneAppPromoBanner({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.secondaryFixed.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            bottom: -16,
            child: Icon(
              Icons.location_city_rounded,
              size: 110,
              color: scheme.secondary.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: Icon(
              Icons.location_on_rounded,
              color: scheme.secondary,
              size: 22,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.oneAppTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.oneAppSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.push('/services'),
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.secondary,
                    foregroundColor: scheme.onSecondary,
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  child: Text(l10n.exploreNow),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyCitySection extends StatelessWidget {
  const _MyCitySection({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return const _MyCityCard();
  }
}

class _MyCityCard extends ConsumerWidget {
  const _MyCityCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final infoAsync = ref.watch(cityInformationProvider());

    return infoAsync.when(
      loading: () => _buildBanner(
        context: context,
        scheme: scheme,
        cityName: 'Muzaffarnagar',
        tagline: 'A city with rich history, culture and heritage',
        heroImage:
            'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80',
      ),
      error: (_, _) => _buildBanner(
        context: context,
        scheme: scheme,
        cityName: 'Muzaffarnagar',
        tagline: 'A city with rich history, culture and heritage',
        heroImage:
            'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80',
      ),
      data: (info) {
        final city = info.city;
        final cityName = city?.name ?? 'Muzaffarnagar';
        final tagline = info.nickname ??
            city?.tagline ??
            'A city with rich history, culture and heritage';
        final heroImage = info.heroImageUrl ??
            'https://images.unsplash.com/photo-1590050752117-238cb0fb12b1?auto=format&fit=crop&w=1200&q=80';

        return _buildBanner(
          context: context,
          scheme: scheme,
          cityName: cityName,
          tagline: tagline,
          heroImage: heroImage,
        );
      },
    );
  }

  Widget _buildBanner({
    required BuildContext context,
    required ColorScheme scheme,
    required String cityName,
    required String tagline,
    required String heroImage,
  }) {
    return GestureDetector(
      onTap: () => context.push('/city/information'),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: NetworkImage(heroImage),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: scheme.primary.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cityName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tagline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Explore',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 14),
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

class _CityzenIdHeroCard extends StatelessWidget {
  const _CityzenIdHeroCard({required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final cityName = user?.city?.name ?? 'Muzaffarnagar';
    final initial = (user?.name != null && user!.name.trim().isNotEmpty)
        ? user!.name.trim()[0].toUpperCase()
        : 'C';
    final citizenId = (user?.displayCitizenId != null && user!.displayCitizenId.isNotEmpty)
        ? user!.displayCitizenId
        : 'CID-SCCSK6';

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: GestureDetector(
          onTap: () => context.push('/id-card'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF082236), // Deep Dark Navy Blue
              Color(0xFF0A3C52), // Teal Navy Transition
              Color(0xFF065F53), // Deep Emerald
              Color(0xFF059669), // Emerald 600
              Color(0xFF10B981), // Vibrant Mint/Emerald
            ],
            stops: [0.0, 0.35, 0.65, 0.85, 1.0],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x300A3C52),
              blurRadius: 22,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -15,
              child: Opacity(
                opacity: 0.12,
                child: const Icon(
                  Icons.location_city_rounded,
                  size: 140,
                  color: Colors.white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF34D399),
                              width: 2,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.hexagon_outlined,
                              size: 14,
                              color: Color(0xFF34D399),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CITYZEN IDENTITY',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 1.1,
                              ),
                            ),
                            Text(
                              'Official Citizen ID',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.contactless_rounded,
                      color: Color(0xFFD1FAE5),
                      size: 26,
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Middle Section: Avatar + Name + Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF2DD4BF),
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x332DD4BF),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: (user?.effectiveAvatarUrl != null && user!.effectiveAvatarUrl!.isNotEmpty)
                            ? Image.network(
                                user!.effectiveAvatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Center(
                                  child: Text(
                                    initial,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E40AF),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  initial,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF1E40AF),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CUSTOMER',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white70,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.name ?? 'Abhui',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.white70,
                                size: 13,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  cityName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
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
                const SizedBox(height: 20),

                // Bottom Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CITYZEN ID',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          citizenId,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF34D399),
                            letterSpacing: 0.7,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF042F2E).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: const Color(0xFF059669).withValues(alpha: 0.5),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 7,
                                color: Color(0xFF34D399),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFE6FFFA),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (user is UserModel) {
                                showCitizenQrModal(context, user as UserModel);
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x20000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.qr_code_2_rounded,
                                color: Color(0xFF0F172A),
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);
}
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid({required this.l10n, this.user});

  final AppLocalizations l10n;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final items = <(IconData, String, Color, VoidCallback?)>[
      if (user?.isClientUser == true)
        (
          Icons.business_center_rounded,
          'My Facility',
          const Color(0xFF0D9488),
          () => context.push('/client/manage'),
        ),
      (
        Icons.menu_book_rounded,
        l10n.libraries,
        const Color(0xFF2E9E5B),
        () => context.push('/services?kind=library'),
      ),
      (
        Icons.fitness_center_rounded,
        l10n.gyms,
        const Color(0xFF8B5CF6),
        () => context.push('/services?kind=gym'),
      ),
      (
        Icons.qr_code_scanner_rounded,
        l10n.quickCheckIn,
        const Color(0xFF00E3FD),
        () => context.push('/checkin'),
      ),
      (
        Icons.local_hospital_rounded,
        l10n.hospitals,
        const Color(0xFF2E7BF6),
        () => context.push('/services'),
      ),
      (
        Icons.self_improvement_rounded,
        l10n.yoga,
        const Color(0xFFF2A93B),
        () => context.push('/services'),
      ),
      (
        Icons.directions_run_rounded,
        l10n.dance,
        const Color(0xFFEC4899),
        () => context.push('/services'),
      ),
      (
        Icons.explore_rounded,
        l10n.more,
        scheme.primary,
        () => context.push('/services'),
      ),
    ];

    final width = MediaQuery.sizeOf(context).width;
    final crossCount = width > 900 ? 8 : (width > 600 ? 6 : 4);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 8,
        childAspectRatio: width > 900 ? 0.95 : (width > 600 ? 0.9 : 0.8),
      ),
      itemBuilder: (context, i) {
        final (icon, label, accent, onTap) = items[i];
        final enabled = onTap != null;
        return InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: enabled
              ? onTap
              : () => ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.comingSoon))),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: enabled
                      ? accent.withValues(alpha: 0.14)
                      : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: enabled
                        ? accent.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Icon(icon, color: accent, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MembershipCard extends StatelessWidget {
  const _MembershipCard({required this.summary});

  final MyMembershipSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.appColors;
    final dateStr = summary.latestPaidAt != null
        ? DateFormat.yMMMd().format(summary.latestPaidAt!)
        : '—';
    final isLibrary = summary.kind == FacilityKind.library;

    return GlassContainer(
      level: GlassLevel.card,
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      onTap: () =>
          context.push('/membership/${summary.kind.name}/${summary.payableId}'),
      gradientOverlay: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [colors.idCardGradientStart, colors.idCardGradientEnd],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLibrary
                  ? Icons.menu_book_rounded
                  : Icons.fitness_center_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLibrary ? l10n.libraries : l10n.gyms,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.validTill(dateStr),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: colors.idCardGlow.withValues(alpha: 0.2),
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
                    color: colors.idCardGlow,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.active,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.idCardGlow,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white70,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class _OnboardHubBanner extends StatelessWidget {
  const _OnboardHubBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.push('/onboard'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Onboard Portal',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Register new User, Library, or Gym',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Open',
                            style: TextStyle(
                              color: Color(0xFF4F46E5),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF4F46E5),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _OnboardPill(
                        icon: Icons.person_add_alt_1_rounded,
                        label: 'User',
                        onTap: () => context.push('/onboard/select/user'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _OnboardPill(
                        icon: Icons.menu_book_rounded,
                        label: 'Library',
                        onTap: () => context.push('/onboard/select/library'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _OnboardPill(
                        icon: Icons.fitness_center_rounded,
                        label: 'Gym',
                        onTap: () => context.push('/onboard/select/gym'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardPill extends StatelessWidget {
  const _OnboardPill({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardQuickActions extends StatelessWidget {
  const _DashboardQuickActions({this.user});

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (user?.isClientUser == true)
          _QuickActionCircle(
            icon: Icons.business_center_rounded,
            label: 'My Facility',
            accent: const Color(0xFF0D9488),
            onTap: () => context.push('/client/facilities'),
          )
        else if (user?.isOnboardingUser == true)
          _QuickActionCircle(
            icon: Icons.rocket_launch_rounded,
            label: 'Onboard',
            accent: const Color(0xFF6366F1),
            onTap: () => context.push('/onboard'),
          ),
        _QuickActionCircle(
          icon: Icons.qr_code_scanner_rounded,
          label: 'Check-in',
          accent: const Color(0xFF06B6D4),
          onTap: () => context.push('/checkin'),
        ),
        _QuickActionCircle(
          icon: Icons.badge_outlined,
          label: 'Citizen ID',
          accent: const Color(0xFF8B5CF6),
          onTap: () => context.push('/id-card'),
        ),
        _QuickActionCircle(
          icon: Icons.apps_rounded,
          label: 'Services',
          accent: const Color(0xFF10B981),
          onTap: () => context.push('/services'),
        ),
      ],
    );
  }
}

class _ClientFacilityHubBanner extends StatelessWidget {
  const _ClientFacilityHubBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF0284C7), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.push('/client/facilities'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.business_center_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Facility Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Manage Gym/Library details, plans & members',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Manage',
                            style: TextStyle(
                              color: Color(0xFF0D9488),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF0D9488),
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionCircle extends StatelessWidget {
  const _QuickActionCircle({
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.18),
                    accent.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: accent.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: accent, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


