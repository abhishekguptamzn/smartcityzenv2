import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/app_config.dart';
import '../../../data/models/facility_model.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/user_avatar.dart';

final singlePaymentDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String)>((ref, args) async {
  final (kind, facilityId, paymentId) = args;
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getPaymentDetails(kind, facilityId, paymentId);
});

void showPaymentDetailModal({
  required BuildContext context,
  required FacilityKind kind,
  required String facilityId,
  required String paymentId,
  Map<String, dynamic>? initialData,
  FacilityModel? facility,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => PaymentDetailModal(
      kind: kind,
      facilityId: facilityId,
      paymentId: paymentId,
      initialData: initialData,
      facility: facility,
    ),
  );
}

class PaymentDetailModal extends ConsumerStatefulWidget {
  const PaymentDetailModal({
    super.key,
    required this.kind,
    required this.facilityId,
    required this.paymentId,
    this.initialData,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final String paymentId;
  final Map<String, dynamic>? initialData;
  final FacilityModel? facility;

  @override
  ConsumerState<PaymentDetailModal> createState() => _PaymentDetailModalState();
}

class _PaymentDetailModalState extends ConsumerState<PaymentDetailModal> {
  bool _isSendingEmail = false;

  Future<void> _handleEmailInvoice(Map<String, dynamic> data) async {
    final user = data['user'] as Map<String, dynamic>?;
    final email = user?['email'] ?? '';

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Member does not have a registered email address.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSendingEmail = true);
    HapticFeedback.mediumImpact();

    try {
      final repo = ref.read(clientFacilityRepositoryProvider);
      final res = await repo.emailPaymentInvoice(widget.kind, widget.facilityId, widget.paymentId);
      final msg = res['message'] ?? 'Invoice PDF emailed successfully to $email';

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(msg)),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to email invoice: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSendingEmail = false);
    }
  }

  Future<void> _handleViewPdf(String? directUrl, String invoiceNumber) async {
    HapticFeedback.lightImpact();

    final config = ref.read(appConfigControllerProvider);
    final baseUrl = config.apiBaseUrl;
    final pathSegment = widget.kind == FacilityKind.gym ? 'gyms' : 'libraries';
    final rawUrl = directUrl ?? '$baseUrl/client/$pathSegment/${widget.facilityId}/payments/${widget.paymentId}/invoice';

    final uri = Uri.parse(rawUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open invoice URL: $rawUrl'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGym = widget.kind == FacilityKind.gym;
    final primaryColor = isGym ? const Color(0xFF0D9488) : const Color(0xFF0284C7);

    final paymentAsync = ref.watch(singlePaymentDetailProvider((widget.kind, widget.facilityId, widget.paymentId)));

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.90,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.receipt_long_rounded, color: primaryColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Payment & Invoice Details',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Flexible(
            child: paymentAsync.when(
              data: (data) => _buildDetailContent(context, data, primaryColor, isDark),
              loading: () {
                if (widget.initialData != null) {
                  return _buildDetailContent(context, widget.initialData!, primaryColor, isDark);
                }
                return const Center(child: Padding(padding: EdgeInsets.all(40), child: LoadingIndicator()));
              },
              error: (err, _) {
                if (widget.initialData != null) {
                  return _buildDetailContent(context, widget.initialData!, primaryColor, isDark);
                }
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Failed to load payment details: $err'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    Map<String, dynamic> data,
    Color primaryColor,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final invoiceNumber = data['invoice_number'] ?? 'INV-${widget.paymentId}';
    final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
    final currency = data['currency'] ?? 'INR';
    final status = (data['status'] ?? 'paid').toString().toLowerCase();
    final isPaid = status == 'paid';
    final paymentMethod = (data['payment_method'] ?? 'cash').toString().toUpperCase();
    final txnRef = data['transaction_reference']?.toString();
    final paidAtFormatted = data['paid_at_formatted'] ?? data['created_at_formatted'] ?? data['created_at'] ?? '';
    final planName = data['plan_name'] ?? data['notes'] ?? 'Membership Pass';
    final validFrom = data['valid_from_formatted'] ?? data['valid_from'] ?? '—';
    final validUntil = data['valid_until_formatted'] ?? data['valid_until'] ?? '—';
    final duration = data['duration']?.toString();
    final directDownloadUrl = data['download_url']?.toString();

    final user = data['user'] as Map<String, dynamic>?;
    final userName = user?['name'] ?? 'Citizen Member';
    final userEmail = user?['email'] ?? '—';
    final userPhone = user?['phone'] ?? '—';
    final userPhoto = user?['photo_url']?.toString();

    final facility = data['facility'] as Map<String, dynamic>?;
    final facilityName = facility?['name'] ?? widget.facility?.name ?? 'Facility';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        // Top Main Amount & Status Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withValues(alpha: 0.9),
                primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPaid ? const Color(0xFF10B981) : Colors.orange,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    invoiceNumber,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Total Amount Paid',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${amount.toStringAsFixed(0)} $currency',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule_rounded, color: Colors.white70, size: 15),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Paid on $paidAtFormatted',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Action Buttons Row (Download PDF & Email Receipt)
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                    ),
                  ),
                ),
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18, color: Color(0xFFEF4444)),
                label: const Text('View PDF', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                onPressed: () => _handleViewPdf(directDownloadUrl, invoiceNumber),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: _isSendingEmail
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.email_rounded, size: 18),
                label: Text(
                  _isSendingEmail ? 'Sending...' : 'Email Invoice',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
                onPressed: _isSendingEmail ? null : () => _handleEmailInvoice(data),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Section 1: Member Profile
        _buildSectionCard(
          context,
          title: 'Member Details',
          icon: Icons.person_rounded,
          isDark: isDark,
          child: Row(
            children: [
              UserAvatar(
                photoUrl: userPhoto,
                name: userName,
                radius: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      userEmail,
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '📞 $userPhone',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Section 2: Pass & Plan Details
        _buildSectionCard(
          context,
          title: 'Pass & Validity Details',
          icon: Icons.card_membership_rounded,
          isDark: isDark,
          child: Column(
            children: [
              _buildInfoRow('Facility', facilityName, isDark),
              _buildInfoRow('Plan Title', planName, isDark, isBold: true),
              if (duration != null && duration.isNotEmpty)
                _buildInfoRow('Plan Duration', duration, isDark),
              const Divider(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VALID FROM', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 3),
                        Text(validFrom, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 28, color: Colors.grey.shade300),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('VALID UNTIL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF059669))),
                        const SizedBox(height: 3),
                        Text(validUntil, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF059669))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Section 3: Payment & Transaction Info
        _buildSectionCard(
          context,
          title: 'Transaction Details',
          icon: Icons.payment_rounded,
          isDark: isDark,
          child: Column(
            children: [
              _buildInfoRow('Payment Method', paymentMethod, isDark, isBold: true),
              if (txnRef != null && txnRef.isNotEmpty)
                _buildInfoRow(
                  'Transaction Reference',
                  txnRef,
                  isDark,
                  onCopy: () {
                    Clipboard.setData(ClipboardData(text: txnRef));
                    HapticFeedback.selectionClick();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Transaction reference copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              _buildInfoRow('Invoice Number', invoiceNumber, isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDark, {
    bool isBold = false,
    VoidCallback? onCopy,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: InkWell(
              onTap: onCopy,
              borderRadius: BorderRadius.circular(6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  if (onCopy != null) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.copy_rounded, size: 13, color: Colors.grey),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
