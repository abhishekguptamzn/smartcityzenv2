import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../../data/api/app_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitting = false;
  bool _sent = false;
  String? _email;
  String? _devResetToken;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final form = _formKey.currentState;
    if (form == null || !form.saveAndValidate()) return;
    setState(() => _submitting = true);
    final email = form.value['email'] as String;
    try {
      final token = await ref
          .read(authRepositoryProvider)
          .forgotPassword(email: email);
      if (!mounted) return;
      setState(() {
        _sent = true;
        _email = email;
        _devResetToken = token.isNotEmpty ? token : null;
      });
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
        title: Text(l10n.resetPassword),
      ),
      body: AmbientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: GlassContainer(
                  level: GlassLevel.largeCard,
                  borderRadius: BorderRadius.circular(24),
                  padding: const EdgeInsets.all(24),
                  child: _sent
                      ? _buildSentState(context, l10n)
                      : _buildForm(l10n),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AppLocalizations l10n) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.resetPassword,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.contactStaffBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(labelText: l10n.emailAddress),
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: l10n.requiredField),
              FormBuilderValidators.email(errorText: l10n.invalidEmail),
            ]),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
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
                  : Text(l10n.sendResetCode),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/login'),
            child: Text(l10n.backToLogin),
          ),
        ],
      ),
    );
  }

  Widget _buildSentState(BuildContext context, AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.mark_email_read_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 16),
        Text(
          l10n.sendResetCode,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _email ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => context.push(
              '/reset-password',
              extra: {'email': _email, 'token': _devResetToken},
            ),
            child: Text(l10n.resetPassword),
          ),
        ),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(l10n.backToLogin),
        ),
      ],
    );
  }
}
