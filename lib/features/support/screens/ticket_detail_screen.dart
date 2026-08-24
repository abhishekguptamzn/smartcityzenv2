import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/tickets_providers.dart';
import '../../../data/repositories/tickets_repository.dart';
import '../../facility_management/widgets/facility_management_skeletons.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  const TicketDetailScreen({super.key, required this.ticketId});

  final int ticketId;

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  final _replyCtrl = TextEditingController();
  final _scrollController = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _replyCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendReply() async {
    final text = _replyCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      final repo = ref.read(ticketsRepositoryProvider);
      await repo.reply(widget.ticketId, message: text);
      _replyCtrl.clear();
      ref.invalidate(ticketDetailProvider(widget.ticketId));
      ref.invalidate(ticketListProvider);

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send reply: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/support');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticketAsync = ref.watch(ticketDetailProvider(widget.ticketId));
    final scheme = Theme.of(context).colorScheme;

    return ticketAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          leading: _buildBackButton(context),
          title: const Text('Support Ticket'),
        ),
        body: const ConversationChatSkeleton(),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(
          leading: _buildBackButton(context),
          title: const Text('Support Ticket'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text('Error loading ticket details: $err'),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.invalidate(ticketDetailProvider(widget.ticketId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (ticket) {
        final messages = ticket.messages;

        final statusConfig = switch (ticket.status) {
          'open' => (
              label: 'Open',
              bg: const Color(0xFFFEF3C7),
              fg: const Color(0xFFB45309),
            ),
          'in_progress' => (
              label: 'In Progress',
              bg: const Color(0xFFDBEAFE),
              fg: const Color(0xFF1D4ED8),
            ),
          'waiting_user' => (
              label: 'Waiting Citizen',
              bg: const Color(0xFFEDE9FE),
              fg: const Color(0xFF6D28D9),
            ),
          'resolved' => (
              label: 'Resolved',
              bg: const Color(0xFFECFDF5),
              fg: const Color(0xFF047857),
            ),
          _ => (
              label: ticket.status.toUpperCase(),
              bg: const Color(0xFFF1F5F9),
              fg: const Color(0xFF475569),
            ),
        };

        return Scaffold(
          appBar: AppBar(
            leading: _buildBackButton(context),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.ticketNumber,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  ticket.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusConfig.bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    statusConfig.label,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: statusConfig.fg,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Ticket Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  border: Border(
                    bottom: BorderSide(color: scheme.outlineVariant),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Priority: ${ticket.priority.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•  Registered: ${_formatDate(ticket.createdAt ?? '')}',
                          style: TextStyle(
                            fontSize: 11,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Conversation Messages List
              Expanded(
                child: messages.isEmpty
                    ? const Center(child: Text('No messages yet.'))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isAdmin = msg.isAdmin;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: isAdmin
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                // Author Header
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 3,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isAdmin) ...[
                                        const Icon(
                                          Icons.verified_user_rounded,
                                          size: 13,
                                          color: Color(0xFF0D9488),
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      Text(
                                        isAdmin
                                            ? (msg.user?.name != null
                                                ? '${msg.user!.name} (Support Team)'
                                                : 'Municipal Support Officer')
                                            : 'You',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isAdmin
                                              ? const Color(0xFF0D9488)
                                              : scheme.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatTime(msg.createdAt ?? ''),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: scheme.onSurfaceVariant
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bubble
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.82,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 11,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isAdmin
                                        ? const Color(0xFF0D9488)
                                        : scheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(16),
                                      topRight: const Radius.circular(16),
                                      bottomLeft: Radius.circular(
                                        isAdmin ? 4 : 16,
                                      ),
                                      bottomRight: Radius.circular(
                                        isAdmin ? 16 : 4,
                                      ),
                                    ),
                                    border: isAdmin
                                        ? null
                                        : Border.all(
                                            color: scheme.outlineVariant,
                                          ),
                                  ),
                                  child: Text(
                                    msg.message,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      height: 1.45,
                                      color: isAdmin
                                          ? Colors.white
                                          : scheme.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Bottom Reply Composer
              if (!ticket.isClosed)
                Container(
                  padding: EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 8,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    border: Border(
                      top: BorderSide(color: scheme.outlineVariant),
                    ),
                  ),
                  child: SafeArea(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _replyCtrl,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Type your reply…',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: scheme.surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: _isSending ? null : _sendReply,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF0D9488),
                          ),
                          icon: _isSending
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send_rounded, size: 20),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  color: scheme.surfaceContainerLow,
                  child: const Center(
                    child: Text(
                      '🔒 This ticket is closed. Please create a new ticket if you need further assistance.',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
