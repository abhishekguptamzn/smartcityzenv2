import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/facility_model.dart';
import '../../../data/models/facility_operations_models.dart';
import '../../../data/repositories/client_facility_repository.dart';
import '../../../shared/widgets/glass_container.dart';
import '../widgets/facility_management_skeletons.dart';
import 'facility_dashboard_screen.dart';

final enquiryDetailsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, (FacilityKind, String, String)>((ref, args) async {
  final repo = ref.watch(clientFacilityRepositoryProvider);
  return repo.getEnquiryDetails(args.$1, args.$2, args.$3);
});

class FacilityEnquiryConversationScreen extends ConsumerStatefulWidget {
  const FacilityEnquiryConversationScreen({
    super.key,
    required this.kind,
    required this.facilityId,
    required this.enquiryId,
    this.initialEnquiry,
    this.facility,
  });

  final FacilityKind kind;
  final String facilityId;
  final String enquiryId;
  final FacilityEnquiryItem? initialEnquiry;
  final FacilityModel? facility;

  @override
  ConsumerState<FacilityEnquiryConversationScreen> createState() => _FacilityEnquiryConversationScreenState();
}

class _FacilityEnquiryConversationScreenState extends ConsumerState<FacilityEnquiryConversationScreen> {
  final _replyController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _sendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref.read(clientFacilityRepositoryProvider).replyEnquiry(
        widget.kind,
        widget.facilityId,
        widget.enquiryId,
        text,
      );

      _replyController.clear();
      if (!mounted) return;

      ref.invalidate(enquiryDetailsProvider((widget.kind, widget.facilityId, widget.enquiryId)));
      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reply sent and emailed to citizen!'),
          backgroundColor: Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reply: $e'), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await ref.read(clientFacilityRepositoryProvider).updateEnquiryStatus(
        widget.kind,
        widget.facilityId,
        widget.enquiryId,
        newStatus,
      );
      ref.invalidate(enquiryDetailsProvider((widget.kind, widget.facilityId, widget.enquiryId)));
      ref.invalidate(facilityStatsProvider((widget.kind, widget.facilityId)));
      ref.invalidate(myOwnedFacilitiesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status changed to ${newStatus.toUpperCase()}'), behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status update failed: $e'), backgroundColor: Colors.red.shade700),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final detailsAsync = ref.watch(enquiryDetailsProvider((widget.kind, widget.facilityId, widget.enquiryId)));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/client/manage/enquiries/${widget.kind.pathSegment}/${widget.facilityId}');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialEnquiry?.name ?? 'Enquiry Conversation',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Enquiry #${widget.initialEnquiry?.enquiryNumber ?? widget.enquiryId}',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: _updateStatus,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'new', child: Text('Mark as New')),
              PopupMenuItem(value: 'replied', child: Text('Mark as Replied')),
              PopupMenuItem(value: 'closed', child: Text('Mark as Closed')),
            ],
          ),
        ],
      ),
      body: AmbientBackground(
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: detailsAsync.when(
                data: (data) {
                  final enquiry = data['enquiry'] as FacilityEnquiryItem?;
                  final messages = data['messages'] as List<EnquiryMessage>? ?? [];

                  if (messages.isEmpty && (enquiry?.message.isEmpty ?? true)) {
                    return const Center(child: Text('No messages in this thread'));
                  }

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Initial Citizen Query (if messages empty or first message)
                      if (enquiry != null && messages.isEmpty)
                        _ChatBubble(
                          message: enquiry.message,
                          time: enquiry.timeFormatted,
                          isOwner: false,
                        ),

                      for (final msg in messages)
                        _ChatBubble(
                          message: msg.message,
                          time: msg.time,
                          isOwner: msg.isOwner,
                        ),
                    ],
                  );
                },
                loading: () => const ConversationChatSkeleton(),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),

            // Reply Composer
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type your reply...',
                        hintStyle: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: theme.brightness == Brightness.dark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D9488),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: _isSending
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _isSending ? null : _sendReply,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.time,
    required this.isOwner,
  });

  final String message;
  final String time;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isOwner
        ? (isDark ? const Color(0xFF0F766E) : const Color(0xFFCCFBF1))
        : (isDark ? const Color(0xFF334155) : Colors.white);

    final textColor = isOwner
        ? (isDark ? Colors.white : const Color(0xFF115E59))
        : (isDark ? Colors.white : const Color(0xFF1E293B));

    return Align(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isOwner ? 16 : 4),
            bottomRight: Radius.circular(isOwner ? 4 : 16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isOwner ? (isDark ? const Color(0x99FFFFFF) : const Color(0xFF0F766E)) : Colors.grey,
                  ),
                ),
                if (isOwner) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all_rounded, size: 13, color: Color(0xFF0D9488)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
