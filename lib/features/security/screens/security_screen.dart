import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../core/providers/login_history_providers.dart';
import '../../../data/api/app_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/empty_state_view.dart';
import '../../../shared/widgets/error_state_view.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading_indicator.dart';

class SecurityScreen extends ConsumerStatefulWidget {
  const SecurityScreen({super.key});

  @override
  ConsumerState<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends ConsumerState<SecurityScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(loginHistoryListProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showChangePasswordSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  Future<void> _confirmLogout({required bool allDevices}) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(allDevices ? l10n.logoutAllDevices : l10n.logout),
        content: Text(allDevices ? l10n.logoutAllDevices : l10n.logout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              MaterialLocalizations.of(dialogContext).cancelButtonLabel,
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final controller = ref.read(authControllerProvider.notifier);
    if (allDevices) {
      await controller.logoutAll();
    } else {
      await controller.logout();
    }
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final historyAsync = ref.watch(loginHistoryListProvider);

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/settings');
            }
          },
        ),
        title: Text(l10n.security),
      ),
      body: AmbientBackground(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.lock_rounded,
                    size: 20,
                    color: scheme.primary,
                  ),
                ),
                title: Text(l10n.changePassword),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: _showChangePasswordSheet,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.loginHistory,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            historyAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: LoadingIndicator(),
              ),
              error: (error, _) => ErrorStateView(
                error: error,
                onRetry: () => ref.invalidate(loginHistoryListProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return EmptyStateView(
                    icon: Icons.history_rounded,
                    message: l10n.noLoginHistoryYet,
                  );
                }
                return Column(
                  children: [
                    for (final entry in items)
                      Card(
                        color: entry.isSuspicious
                            ? scheme.error.withValues(alpha: 0.08)
                            : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                (entry.isSuccess
                                        ? scheme.secondary
                                        : scheme.error)
                                    .withValues(alpha: 0.14),
                            child: Icon(
                              entry.isSuccess
                                  ? Icons.check_circle_rounded
                                  : Icons.error_rounded,
                              color: entry.isSuccess
                                  ? scheme.secondary
                                  : scheme.error,
                              size: 20,
                            ),
                          ),
                          title: Text(entry.ipAddress ?? '—'),
                          subtitle: Text(
                            [
                              if (entry.createdAt != null)
                                DateFormat.yMMMd().add_jm().format(
                                  entry.createdAt!,
                                ),
                              if (entry.deviceType != null) entry.deviceType!,
                            ].join(' · '),
                          ),
                          trailing: entry.isSuspicious
                              ? Chip(
                                  avatar: Icon(
                                    Icons.warning_rounded,
                                    size: 14,
                                    color: scheme.tertiary,
                                  ),
                                  label: Text(l10n.suspiciousLogin),
                                )
                              : null,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _confirmLogout(allDevices: false),
              icon: const Icon(Icons.logout_rounded),
              label: Text(l10n.logout),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _confirmLogout(allDevices: true),
              icon: const Icon(Icons.phonelink_erase_rounded),
              label: Text(l10n.logoutAllDevices),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChangePasswordSheet extends ConsumerStatefulWidget {
  const _ChangePasswordSheet();

  @override
  ConsumerState<_ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitting = false;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    setState(() => _submitting = true);
    final v = form.value;
    try {
      await ref
          .read(authRepositoryProvider)
          .changePassword(
            currentPassword: v['currentPassword'] as String,
            newPassword: v['newPassword'] as String,
            newPasswordConfirmation: v['confirmPassword'] as String,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.changePassword)));
    } catch (e) {
      if (!mounted) return;
      final appException = AppException.from(e);
      final message = appException?.fieldErrors?.values.firstOrNull?.firstOrNull ??
          (appException != null && appException.message.isNotEmpty
              ? appException.message
              : l10n.errorGeneric);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.changePassword,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'currentPassword',
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.currentPassword,
                  prefixIcon: Icon(Icons.lock_rounded, color: scheme.primary),
                ),
                validator: FormBuilderValidators.required(
                  errorText: l10n.requiredField,
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'newPassword',
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.newPassword,
                  prefixIcon: Icon(
                    Icons.lock_reset_rounded,
                    color: scheme.primary,
                  ),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: l10n.requiredField),
                  FormBuilderValidators.minLength(
                    8,
                    errorText: l10n.passwordTooShort,
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'confirmPassword',
                obscureText: true,
                decoration: InputDecoration(
                  labelText: l10n.confirmPassword,
                  prefixIcon: Icon(Icons.lock_rounded, color: scheme.primary),
                ),
                validator: (value) {
                  final newPassword =
                      _formKey.currentState?.fields['newPassword']?.value;
                  if (value != newPassword) return l10n.passwordsDoNotMatch;
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.changePassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
