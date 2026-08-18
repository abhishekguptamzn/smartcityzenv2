import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import 'payment_detail_modal.dart';

enum ChartPeriod { monthly, weekly }

class FacilityAnalyticsDashboardWidget extends StatefulWidget {
  const FacilityAnalyticsDashboardWidget({
    super.key,
    required this.kind,
    required this.facilityId,
    this.facility,
    required this.stats,
  });

  final FacilityKind kind;
  final String facilityId;
  final FacilityModel? facility;
  final FacilityDashboardStats stats;

  @override
  State<FacilityAnalyticsDashboardWidget> createState() => _FacilityAnalyticsDashboardWidgetState();
}

class _FacilityAnalyticsDashboardWidgetState extends State<FacilityAnalyticsDashboardWidget> {
  ChartPeriod _chartPeriod = ChartPeriod.monthly;
  bool _showAllTimeRevenue = true;

  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isGym = widget.kind == FacilityKind.gym;
    final primaryColor = isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);
    final stats = widget.stats;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title with Refresh / Live Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.insights_rounded, color: primaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Facility Analytics & Earnings',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(radius: 3, backgroundColor: Color(0xFF10B981)),
                  SizedBox(width: 5),
                  Text(
                    'LIVE STATS',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Primary Revenue Card with Switch
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isGym
                  ? [const Color(0xFF0D9488), const Color(0xFF047857)]
                  : [const Color(0xFF0284C7), const Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showAllTimeRevenue ? 'TOTAL COLLECTED REVENUE' : 'CURRENT MONTH REVENUE',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  InkWell(
                    onTap: () => setState(() => _showAllTimeRevenue = !_showAllTimeRevenue),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _showAllTimeRevenue ? 'All-Time' : 'This Month',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.swap_horiz_rounded, size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _currencyFormat.format(_showAllTimeRevenue ? stats.totalEarningsAllTime : stats.totalEarningsThisMonth),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 14),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Today's Net", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(
                          _currencyFormat.format(stats.totalEarningsToday),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 28, width: 1, color: Colors.white24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Month's Renewals", style: TextStyle(color: Colors.white70, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(
                          '${stats.totalRenewalsThisMonth} Passes',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  if (stats.totalRefundsAllTime > 0) ...[
                    Container(height: 28, width: 1, color: Colors.white24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Refunds", style: TextStyle(color: Colors.white70, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(
                            _currencyFormat.format(stats.totalRefundsAllTime),
                            style: const TextStyle(color: Color(0xFFFDE047), fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 4 KPI Summary Cards Grid
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.people_alt_rounded,
                iconColor: const Color(0xFF0D9488),
                title: 'Active Members',
                value: '${stats.activeMembers}',
                subtitle: 'of ${stats.totalMembers} total',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                icon: Icons.hourglass_top_rounded,
                iconColor: const Color(0xFFF59E0B),
                title: 'Expiring Soon',
                value: '${stats.expiringSoonMembers}',
                subtitle: 'in next 7 days',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.fact_check_outlined,
                iconColor: const Color(0xFF0284C7),
                title: "Today's Visits",
                value: '${stats.todayCheckins}',
                subtitle: 'Check-ins logged',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                icon: Icons.person_off_outlined,
                iconColor: const Color(0xFFEF4444),
                title: 'Expired / Unpaid',
                value: '${stats.expiredMembers}',
                subtitle: 'Needs renewal',
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Interactive Earning Trends Chart Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revenue & Earning Trends',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _chartPeriod == ChartPeriod.monthly ? 'Past 6 months collection' : 'Last 7 days collection',
                        style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  SegmentedButton<ChartPeriod>(
                    segments: const [
                      ButtonSegment(value: ChartPeriod.monthly, label: Text('Monthly', style: TextStyle(fontSize: 11))),
                      ButtonSegment(value: ChartPeriod.weekly, label: Text('Weekly', style: TextStyle(fontSize: 11))),
                    ],
                    selected: {_chartPeriod},
                    onSelectionChanged: (set) => setState(() => _chartPeriod = set.first),
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Render Bar Chart
              _buildBarChart(context, primaryColor),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Member Lifecycle & Health Status Distribution
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Membership Health Status',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Segmented visual bar
              _buildMemberHealthProgressBar(stats),
              const SizedBox(height: 14),

              // Chips Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatusIndicatorItem(
                    color: const Color(0xFF10B981),
                    label: 'Active',
                    count: stats.activeMembers,
                  ),
                  _StatusIndicatorItem(
                    color: const Color(0xFFF59E0B),
                    label: 'Expiring Soon',
                    count: stats.expiringSoonMembers,
                  ),
                  _StatusIndicatorItem(
                    color: const Color(0xFFEF4444),
                    label: 'Expired',
                    count: stats.expiredMembers,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Payment Collection by Mode
        if (stats.paymentMethodsBreakdown.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Channels & Modes',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                for (final method in stats.paymentMethodsBreakdown) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getPaymentIcon(method.method),
                            size: 16,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            method.method,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Text(
                        '${_currencyFormat.format(method.amount)} (${method.percentage}%)',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (method.percentage / 100).clamp(0.02, 1.0),
                      minHeight: 6,
                      backgroundColor: scheme.surfaceContainerHighest,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Recent Payments Stream
        if (stats.recentPayments.isNotEmpty) ...[
          Text(
            'Recent Payments & Renewals',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Material(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3)),
            ),
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: stats.recentPayments.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (ctx, i) {
                final p = stats.recentPayments[i];
                final isRefunded = p.status.toLowerCase() == 'refunded';
                return InkWell(
                  onTap: () {
                    showPaymentDetailModal(
                      context: context,
                      kind: widget.kind,
                      facilityId: widget.facilityId,
                      paymentId: p.id,
                      facility: widget.facility,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isRefunded ? const Color(0xFF7C3AED).withValues(alpha: 0.12) : const Color(0xFF10B981).withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isRefunded ? Icons.currency_exchange_rounded : Icons.receipt_rounded,
                            color: isRefunded ? const Color(0xFF7C3AED) : const Color(0xFF10B981),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            p.memberName,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isRefunded) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: const Text('REFUNDED', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _currencyFormat.format(p.amount),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isRefunded ? const Color(0xFF7C3AED) : const Color(0xFF059669),
                                      decoration: isRefunded ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      isRefunded && p.refundReason != null
                                          ? 'Reason: ${p.refundReason}'
                                          : '${p.paymentMethod} • ${p.date}',
                                      style: TextStyle(fontSize: 11, color: isRefunded ? const Color(0xFF7C3AED) : scheme.onSurfaceVariant),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    p.invoiceNumber,
                                    style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildBarChart(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final stats = widget.stats;

    final List<_ChartBarData> barData = [];

    if (_chartPeriod == ChartPeriod.monthly) {
      for (final item in stats.monthlyEarningsTrend) {
        barData.add(_ChartBarData(label: item.month, value: item.earnings));
      }
    } else {
      for (final item in stats.weeklyEarningsTrend) {
        barData.add(_ChartBarData(label: item.day, value: item.earnings));
      }
    }

    if (barData.isEmpty) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: Text('No revenue data recorded yet.', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12)),
      );
    }

    final maxVal = barData.map((e) => e.value).fold<double>(0.0, (prev, curr) => curr > prev ? curr : prev);
    final maxScale = maxVal > 0 ? maxVal : 1000.0;

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: barData.map((b) {
          final heightFactor = (b.value / maxScale).clamp(0.08, 1.0);
          final isPeak = b.value > 0 && b.value >= maxVal;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  b.value > 0 ? '₹${b.value >= 1000 ? "${(b.value / 1000).toStringAsFixed(1)}k" : b.value.toInt()}' : '-',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isPeak ? FontWeight.bold : FontWeight.w500,
                    color: isPeak ? primaryColor : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 100 * heightFactor,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: isPeak
                          ? [primaryColor.withValues(alpha: 0.8), primaryColor]
                          : [primaryColor.withValues(alpha: 0.3), primaryColor.withValues(alpha: 0.6)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  b.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isPeak ? FontWeight.bold : FontWeight.w500,
                    color: isPeak ? theme.colorScheme.onSurface : scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMemberHealthProgressBar(FacilityDashboardStats stats) {
    final total = stats.totalMembers > 0 ? stats.totalMembers : 1;
    final stableActive = (stats.activeMembers - stats.expiringSoonMembers).clamp(0, stats.totalMembers);
    final activePct = stableActive / total;
    final expiringPct = stats.expiringSoonMembers / total;
    final expiredPct = stats.expiredMembers / total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            if (activePct > 0)
              Expanded(
                flex: (activePct * 1000).toInt().clamp(1, 1000),
                child: Container(color: const Color(0xFF10B981)),
              ),
            if (expiringPct > 0)
              Expanded(
                flex: (expiringPct * 1000).toInt().clamp(1, 1000),
                child: Container(color: const Color(0xFFF59E0B)),
              ),
            if (expiredPct > 0)
              Expanded(
                flex: (expiredPct * 1000).toInt().clamp(1, 1000),
                child: Container(color: const Color(0xFFEF4444)),
              ),
            if (activePct == 0 && expiringPct == 0 && expiredPct == 0)
              Expanded(
                child: Container(color: Colors.grey.shade300),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    final lower = method.toLowerCase();
    if (lower.contains('upi') || lower.contains('qr')) return Icons.qr_code_2_rounded;
    if (lower.contains('card') || lower.contains('pos')) return Icons.credit_card_rounded;
    if (lower.contains('bank') || lower.contains('transfer')) return Icons.account_balance_rounded;
    return Icons.payments_rounded;
  }
}

class _ChartBarData {
  const _ChartBarData({required this.label, required this.value});
  final String label;
  final double value;
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10.5, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _StatusIndicatorItem extends StatelessWidget {
  const _StatusIndicatorItem({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(
          '$label: $count',
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
