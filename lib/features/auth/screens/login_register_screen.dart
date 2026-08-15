import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/api/app_exception.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/searchable_city_picker.dart';

class LoginRegisterScreen extends ConsumerStatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  ConsumerState<LoginRegisterScreen> createState() =>
      _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends ConsumerState<LoginRegisterScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _loginFormKey = GlobalKey<FormBuilderState>();
  final _registerFormKey = GlobalKey<FormBuilderState>();

  bool _loginObscure = true;
  bool _registerObscure = true;
  bool _submitting = false;
  String? _registerCityId;

  final List<DateTime> _recentFailedAttempts = [];
  DateTime? _cooldownUntil;

  int _activeTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index == _activeTab) {
        return;
      }
      setState(() => _activeTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isCoolingDown =>
      _cooldownUntil != null && DateTime.now().isBefore(_cooldownUntil!);

  void _registerFailedAttempt() {
    final now = DateTime.now();
    _recentFailedAttempts.add(now);
    _recentFailedAttempts.removeWhere(
      (t) => now.difference(t) > const Duration(minutes: 1),
    );
    // Mirrors the server's auth.login 5/min throttle so the UI doesn't wait
    // for a 429 before disabling the button.
    if (_recentFailedAttempts.length >= 5) {
      setState(() => _cooldownUntil = now.add(const Duration(minutes: 1)));
    }
  }

  Future<void> _submitLogin() async {
    final l10n = AppLocalizations.of(context);
    if (_isCoolingDown) return;
    final form = _loginFormKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    setState(() => _submitting = true);
    final email = form.value['email'] as String;
    final password = form.value['password'] as String;
    await ref
        .read(authControllerProvider.notifier)
        .login(email: email, password: password);
    if (!mounted) return;
    setState(() => _submitting = false);

    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        final appException = AppException.from(error);
        if (appException?.fieldErrors != null) {
          _applyServerFieldErrors(form, appException!.fieldErrors!);
        }
        _registerFailedAttempt();
        _showError(error, l10n);
      },
      data: (user) {
        if (user != null) context.go('/home');
      },
    );
  }

  Future<void> _submitRegister() async {
    final l10n = AppLocalizations.of(context);
    final form = _registerFormKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    setState(() => _submitting = true);
    final v = form.value;
    final cityId = _registerCityId ?? (v['city'] as String?) ?? '';
    await ref
        .read(authControllerProvider.notifier)
        .register(
          name: v['name'] as String,
          email: v['email'] as String,
          phone: v['phone'] as String?,
          cityId: cityId,
          password: v['password'] as String,
          passwordConfirmation: v['confirmPassword'] as String,
        );
    if (!mounted) return;
    setState(() => _submitting = false);

    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        final appException = AppException.from(error);
        if (appException?.fieldErrors != null) {
          _applyServerFieldErrors(form, appException!.fieldErrors!);
        }
        _showError(error, l10n);
      },
      data: (user) {
        if (user != null) context.go('/home');
      },
    );
  }

  void _applyServerFieldErrors(
    FormBuilderState form,
    Map<String, List<String>> fieldErrors,
  ) {
    const serverToFormField = {
      'name': 'name',
      'email': 'email',
      'phone': 'phone',
      'city_id': 'city',
      'password': 'password',
    };
    for (final entry in fieldErrors.entries) {
      final fieldName = serverToFormField[entry.key];
      if (fieldName == null) continue;
      form.fields[fieldName]?.invalidate(entry.value.first);
    }
  }

  void _showError(Object? error, AppLocalizations l10n) {
    final appException = AppException.from(error);
    final message = appException != null
        ? _messageFor(appException, l10n)
        : l10n.errorGeneric;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Prefer the API's own message for codes where the backend already crafts
  /// a specific, safe-to-display reason (wrong credentials, validation
  /// failures, duplicate account, etc.) — showing a generic string there hides
  /// real information the user needs. The top-level `message` on a 422 is a
  /// generic "The given data was invalid.", so the *specific* reason (e.g.
  /// "credentials do not match") lives in `fieldErrors` instead — prefer that
  /// when present. Codes that can carry sensitive internal detail, or that
  /// benefit from bespoke client-side phrasing (rate-limit countdown, offline
  /// detection), keep their localized strings instead.
  String _messageFor(AppException e, AppLocalizations l10n) {
    return switch (e.code) {
      AppExceptionCode.validation ||
      AppExceptionCode.authentication ||
      AppExceptionCode.badRequest ||
      AppExceptionCode.notFound ||
      AppExceptionCode.conflict =>
        _firstFieldError(e) ??
            (e.message.isNotEmpty && e.message != 'The given data was invalid.'
                ? e.message
                : (e.apiError?.message ?? l10n.errorAuthentication)),
      AppExceptionCode.accountBlocked =>
        e.message.isNotEmpty ? e.message : l10n.errorAccountBlocked,
      AppExceptionCode.accountInactive =>
        e.message.isNotEmpty ? e.message : l10n.errorAccountInactive,
      AppExceptionCode.rateLimited => l10n.errorRateLimited(
        e.retryAfterSeconds ?? 60,
      ),
      AppExceptionCode.network => l10n.noInternetConnection,
      _ => e.message.isNotEmpty ? e.message : l10n.errorGeneric,
    };
  }

  String? _firstFieldError(AppException e) {
    final fieldErrors = e.fieldErrors;
    if (fieldErrors == null || fieldErrors.isEmpty) return null;
    final firstList = fieldErrors.values.first;
    return firstList.isNotEmpty ? firstList.first : null;
  }

  Future<void> _handleGoogleSignIn() async {
    final l10n = AppLocalizations.of(context);
    try {
      final googleSignIn = GoogleSignIn();
      final account = await googleSignIn.signIn();
      if (account == null) return;
      final auth = await account.authentication;
      await ref
          .read(authControllerProvider.notifier)
          .oauthLogin(
            'google',
            idToken: auth.idToken,
            email: account.email,
            name: account.displayName,
            avatar: account.photoUrl,
            providerId: account.id,
          );
      if (!mounted) return;
      final state = ref.read(authControllerProvider);
      state.whenOrNull(
        error: (error, _) => _showError(error, l10n),
        data: (user) {
          if (user != null) context.go('/home');
        },
      );
    } catch (_) {
      if (!mounted) return;
      _showError(null, l10n);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    final l10n = AppLocalizations.of(context);
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success || result.accessToken == null) {
        return;
      }
      await ref
          .read(authControllerProvider.notifier)
          .oauthLogin('facebook', accessToken: result.accessToken!.tokenString);
      if (!mounted) return;
      final state = ref.read(authControllerProvider);
      state.whenOrNull(
        error: (error, _) => _showError(error, l10n),
        data: (user) {
          if (user != null) context.go('/home');
        },
      );
    } catch (_) {
      if (!mounted) return;
      _showError(null, l10n);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/logo_mark.png',
                      width: 72,
                      height: 72,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.appName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sora(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.appTagline,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    GlassContainer(
                      level: GlassLevel.largeCard,
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(text: l10n.login),
                              Tab(text: l10n.register),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Content determines height here (no TabBarView, which
                          // requires a bounded/guessed height from its parent) so
                          // the outer SingleChildScrollView can size to whichever
                          // form — login or the longer register form — is active.
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _activeTab == 0
                                ? _buildLoginForm(l10n)
                                : _buildRegisterForm(l10n),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: scheme.outlineVariant),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  l10n.orContinueWith,
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              ),
                              Expanded(
                                child: Divider(color: scheme.outlineVariant),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _submitting
                                      ? null
                                      : _handleGoogleSignIn,
                                  icon: const _GoogleGlyph(),
                                  label: Text(l10n.continueWithGoogle),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _submitting
                                      ? null
                                      : _handleFacebookSignIn,
                                  icon: Icon(
                                    Icons.facebook_rounded,
                                    size: 20,
                                    color: const Color(0xFF1877F2),
                                  ),
                                  label: Text(l10n.continueWithFacebook),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(AppLocalizations l10n) {
    return FormBuilder(
      key: _loginFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(labelText: l10n.emailAddress),
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: l10n.requiredField),
              FormBuilderValidators.email(errorText: l10n.invalidEmail),
            ]),
          ),
          const SizedBox(height: 16),
          StatefulBuilder(
            builder: (context, setInner) => FormBuilderTextField(
              name: 'password',
              obscureText: _loginObscure,
              decoration: InputDecoration(
                labelText: l10n.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    _loginObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setInner(() => _loginObscure = !_loginObscure),
                ),
              ),
              validator: FormBuilderValidators.required(
                errorText: l10n.requiredField,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => GoRouter.of(context).push('/forgot-password'),
              child: Text(l10n.forgotPassword),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: (_submitting || _isCoolingDown) ? null : _submitLogin,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.accessPortal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(AppLocalizations l10n) {
    return FormBuilder(
      key: _registerFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormBuilderTextField(
            name: 'name',
            decoration: InputDecoration(labelText: l10n.fullName),
            validator: FormBuilderValidators.required(
              errorText: l10n.requiredField,
            ),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'email',
            decoration: InputDecoration(labelText: l10n.emailAddress),
            keyboardType: TextInputType.emailAddress,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: l10n.requiredField),
              FormBuilderValidators.email(errorText: l10n.invalidEmail),
            ]),
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'phone',
            decoration: InputDecoration(labelText: l10n.mobileNumber),
            keyboardType: TextInputType.phone,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.match(
                RegExp(r'^\+?[0-9]{7,15}$'),
                errorText: l10n.invalidPhone,
              ),
            ]),
          ),
          const SizedBox(height: 16),
          SearchableCityPicker(
            selectedCityId: _registerCityId,
            labelText: l10n.selectYourCity,
            validator: (val) {
              if (_registerCityId == null || _registerCityId!.isEmpty) {
                return l10n.requiredField;
              }
              return null;
            },
            onCitySelected: (city) {
              setState(() {
                _registerCityId = city.id;
              });
              _registerFormKey.currentState?.patchValue({'city': city.id});
            },
          ),
          const SizedBox(height: 16),
          StatefulBuilder(
            builder: (context, setInner) => FormBuilderTextField(
              name: 'password',
              obscureText: _registerObscure,
              decoration: InputDecoration(
                labelText: l10n.createPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _registerObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () =>
                      setInner(() => _registerObscure = !_registerObscure),
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
          ),
          const SizedBox(height: 16),
          FormBuilderTextField(
            name: 'confirmPassword',
            obscureText: true,
            decoration: InputDecoration(labelText: l10n.confirmPassword),
            validator: (value) {
              final password =
                  _registerFormKey.currentState?.fields['password']?.value;
              if (value != password) return l10n.passwordsDoNotMatch;
              return null;
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submitRegister,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.createIdentity),
            ),
          ),
        ],
      ),
    );
  }
}

/// A Material-icon-only "G" badge in Google's brand colors, used instead of
/// [Icons.g_mobiledata_rounded] — that glyph is an Android data-status icon,
/// not a brand mark, and reads as a placeholder rather than a real button.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const SweepGradient(
        colors: [
          Color(0xFF4285F4),
          Color(0xFF34A853),
          Color(0xFFFBBC05),
          Color(0xFFEA4335),
          Color(0xFF4285F4),
        ],
      ).createShader(bounds),
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          height: 1,
          color: Colors.white,
        ),
      ),
    );
  }
}
