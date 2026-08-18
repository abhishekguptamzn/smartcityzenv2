import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/tickets_providers.dart';
import '../../../data/models/ticket_model.dart';
import '../../../data/repositories/tickets_repository.dart';
import '../../../shared/widgets/glass_container.dart';

class SupportTicketsScreen extends ConsumerStatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  ConsumerState<SupportTicketsScreen> createState() =>
      _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends ConsumerState<SupportTicketsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedStatus = 'all';
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  final _categories = [
    {'key': 'all', 'label': 'All Categories', 'icon': Icons.category_rounded},
    {'key': 'general', 'label': 'General Inquiry', 'icon': Icons.info_outline_rounded},
    {'key': 'gym', 'label': 'Gym & Sports', 'icon': Icons.fitness_center_rounded},
    {'key': 'library', 'label': 'Library Pass', 'icon': Icons.menu_book_rounded},
    {'key': 'payment', 'label': 'Billing & Fees', 'icon': Icons.receipt_long_rounded},
    {'key': 'identity', 'label': 'Citizen ID', 'icon': Icons.badge_outlined},
    {'key': 'technical', 'label': 'App & Technical', 'icon': Icons.build_rounded},
  ];

  final _statuses = [
    {'key': 'all', 'label': 'All'},
    {'key': 'open', 'label': 'Open'},
    {'key': 'in_progress', 'label': 'In Progress'},
    {'key': 'waiting_user', 'label': 'Waiting Action'},
    {'key': 'resolved', 'label': 'Resolved'},
    {'key': 'closed', 'label': 'Closed'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openNewTicketSheet() {
    showModalBottomSheet<TicketModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _NewTicketBottomSheet(
        onCreated: (ticket) {
          ref.invalidate(ticketListProvider);
          _showTicketSuccessDialog(ticket);
        },
      ),
    );
  }

  void _showTicketSuccessDialog(TicketModel ticket) {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 44,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ticket Registered!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your support inquiry has been submitted to the municipal helpdesk team.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF0D9488).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TICKET REFERENCE ID',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0D9488),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ticket.ticketNumber,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20),
                    tooltip: 'Copy Ticket ID',
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: ticket.ticketNumber),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ticket ID copied to clipboard!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Icon(Icons.email_outlined, size: 16, color: Color(0xFF0D9488)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'An email confirmation with your Ticket ID has been sent to your inbox.',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogCtx);
                      context.push('/support/tickets/${ticket.id}');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('View Thread'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final params = TicketListParams(
      status: _selectedStatus == 'all' ? null : _selectedStatus,
      category: _selectedCategory == 'all' ? null : _selectedCategory,
      search: _searchQuery.isEmpty ? null : _searchQuery,
    );

    final ticketsAsync = ref.watch(ticketListProvider(params));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: const Text('Support & Helpdesk'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Tickets',
            onPressed: () => ref.invalidate(ticketListProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewTicketSheet,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New Ticket',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tickets by ID, subject…',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
            ),
          ),

          // 2. Status Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _statuses.map((s) {
                final isSelected = _selectedStatus == s['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(s['label']!),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedStatus = s['key']!);
                    },
                    selectedColor: const Color(0xFF0D9488).withValues(alpha: 0.18),
                    checkmarkColor: const Color(0xFF0D9488),
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF0D9488) : null,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 3. Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: _categories.map((c) {
                final isSelected = _selectedCategory == c['key'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: Icon(
                      c['icon'] as IconData,
                      size: 15,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                    label: Text(c['label'] as String),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = c['key'] as String);
                    },
                    selectedColor: const Color(0xFF0D9488),
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.white : null,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 6),

          // 4. Ticket List View
          Expanded(
            child: ticketsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(
                        'Failed to load tickets',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        err.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                        onPressed: () => ref.invalidate(ticketListProvider),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (tickets) {
                if (tickets.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.support_agent_rounded,
                              size: 40,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Support Tickets Found',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Have a query or need assistance with municipal services? Create your first ticket.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          FilledButton.icon(
                            onPressed: _openNewTicketSheet,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0D9488),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create Support Ticket'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: tickets.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return _TicketCard(
                      ticket: ticket,
                      onTap: () => context.push('/support/tickets/${ticket.id}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.onTap});

  final TicketModel ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final statusConfig = switch (ticket.status) {
      'open' => (
          label: 'Open',
          bg: const Color(0xFFFEF3C7),
          fg: const Color(0xFFB45309),
          icon: Icons.access_time_rounded
        ),
      'in_progress' => (
          label: 'In Progress',
          bg: const Color(0xFFDBEAFE),
          fg: const Color(0xFF1D4ED8),
          icon: Icons.sync_rounded
        ),
      'waiting_user' => (
          label: 'Waiting Citizen',
          bg: const Color(0xFFEDE9FE),
          fg: const Color(0xFF6D28D9),
          icon: Icons.mark_chat_unread_rounded
        ),
      'resolved' => (
          label: 'Resolved',
          bg: const Color(0xFFECFDF5),
          fg: const Color(0xFF047857),
          icon: Icons.check_circle_outline_rounded
        ),
      _ => (
          label: 'Closed',
          bg: const Color(0xFFF1F5F9),
          fg: const Color(0xFF475569),
          icon: Icons.lock_outline_rounded
        ),
    };

    final priorityColor = switch (ticket.priority) {
      'urgent' => const Color(0xFFEF4444),
      'high' => const Color(0xFFF97316),
      'medium' => const Color(0xFF3B82F6),
      _ => const Color(0xFF10B981),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: GlassContainer(
        level: GlassLevel.card,
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Ticket ID & Status Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ticket.ticketNumber,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: priorityColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        ticket.priority.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: priorityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: statusConfig.bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusConfig.icon, size: 12, color: statusConfig.fg),
                      const SizedBox(width: 4),
                      Text(
                        statusConfig.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusConfig.fg,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Subject
            Text(
              ticket.subject,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            // Latest Message Snippet if available
            if (ticket.latestMessage != null)
              Text(
                '${ticket.latestMessage!.isAdmin ? '🏛️ Admin: ' : 'You: '}${ticket.latestMessage!.message}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),

            const SizedBox(height: 10),

            // Bottom Meta Row: Category & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    ticket.category.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ),
                if (ticket.updatedAt != null)
                  Text(
                    _formatDate(ticket.updatedAt!),
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}

class _NewTicketBottomSheet extends ConsumerStatefulWidget {
  const _NewTicketBottomSheet({required this.onCreated});

  final ValueChanged<TicketModel> onCreated;

  @override
  ConsumerState<_NewTicketBottomSheet> createState() =>
      _NewTicketBottomSheetState();
}

class _NewTicketBottomSheetState extends ConsumerState<_NewTicketBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _subjectCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _category = 'general';
  String _priority = 'medium';
  bool _isSubmitting = false;

  final _categories = [
    {'key': 'general', 'label': 'General Inquiry'},
    {'key': 'gym', 'label': 'Gym Pass & Sports'},
    {'key': 'library', 'label': 'Library Pass'},
    {'key': 'payment', 'label': 'Payment & Invoices'},
    {'key': 'identity', 'label': 'Citizen Identity & ID'},
    {'key': 'technical', 'label': 'App & Technical Issues'},
  ];

  final _priorities = [
    {'key': 'low', 'label': 'Low', 'color': Color(0xFF10B981)},
    {'key': 'medium', 'label': 'Medium', 'color': Color(0xFF3B82F6)},
    {'key': 'high', 'label': 'High', 'color': Color(0xFFF97316)},
    {'key': 'urgent', 'label': 'Urgent', 'color': Color(0xFFEF4444)},
  ];

  @override
  void dispose() {
    _subjectCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(ticketsRepositoryProvider);
      final newTicket = await repo.create(
        subject: _subjectCtrl.text.trim(),
        message: _messageCtrl.text.trim(),
        category: _category,
        priority: _priority,
      );

      if (mounted) {
        Navigator.pop(context);
        widget.onCreated(newTicket);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create ticket: $e'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Create Support Ticket',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Submit an inquiry or issue. Our municipal support team will respond promptly.',
                style: TextStyle(fontSize: 12.5, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Category Selector
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: 'Service Category *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.category_rounded, size: 20),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(
                          value: c['key'],
                          child: Text(c['label']!),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _category = val ?? 'general'),
              ),

              const SizedBox(height: 14),

              // Subject Input
              TextFormField(
                controller: _subjectCtrl,
                decoration: InputDecoration(
                  labelText: 'Subject *',
                  hintText: 'Brief summary of the issue…',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.subject_rounded, size: 20),
                ),
                validator: (val) =>
                    (val == null || val.trim().isEmpty) ? 'Please enter a subject' : null,
              ),

              const SizedBox(height: 14),

              // Priority Selector
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Priority Level',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: _priorities.map((p) {
                      final isSelected = _priority == p['key'];
                      final color = p['color'] as Color;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: InkWell(
                            onTap: () => setState(() => _priority = p['key'] as String),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withValues(alpha: 0.18)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? color
                                      : Colors.grey.withValues(alpha: 0.3),
                                  width: isSelected ? 1.8 : 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  p['label'] as String,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected ? color : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Detailed Message Input
              TextFormField(
                controller: _messageCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Message / Description *',
                  hintText: 'Provide complete details regarding your inquiry…',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Please enter your message'
                    : null,
              ),

              const SizedBox(height: 22),

              // Submit Button
              FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0D9488),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit Ticket',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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
