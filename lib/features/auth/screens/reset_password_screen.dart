import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../../../data/api/app_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.initialEmail, this.initialToken});

  final String? initialEmail;
  final String? initialToken;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
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
          .resetPassword(
            email: v['email'] as String,
            token: v['token'] as String,
            password: v['password'] as String,
            passwordConfirmation: v['confirmPassword'] as String,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.resetPassword)));
      context.go('/login');
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
                  child: FormBuilder(
                    key: _formKey,
                    initialValue: {
                      if (widget.initialEmail != null)
                        'email': widget.initialEmail!,
                      if (widget.initialToken != null)
                        'token': widget.initialToken!,
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FormBuilderTextField(
                          name: 'email',
                          decoration: InputDecoration(
                            labelText: l10n.emailAddress,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: l10n.requiredField,
                            ),
                            FormBuilderValidators.email(
                              errorText: l10n.invalidEmail,
                            ),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'token',
                          decoration: InputDecoration(
                            labelText: l10n.resetCode,
                          ),
                          validator: FormBuilderValidators.required(
                            errorText: l10n.requiredField,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'password',
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.newPassword,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: l10n.requiredField,
                            ),
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
                          ),
                          validator: (value) {
                            final password = _formKey
                                .currentState
                                ?.fields['password']
                                ?.value;
                            if (value != password) {
                              return l10n.passwordsDoNotMatch;
                            }
                            return null;
                          },
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
                                : Text(l10n.resetPassword),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(l10n.backToLogin),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
