import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/providers/auth_controller.dart';
import '../../../data/api/app_exception.dart';
import '../../../data/models/otp_sent_result.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../shared/widgets/loading/loading_button.dart';
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
      setState(() {
        _activeTab = _tabController.index;
        if (_activeTab == 0) {
          _registerCityId = null;
        }
      });
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
    final phone = (form.value['phone'] as String).trim();

    try {
      final result =
          await ref.read(authRepositoryProvider).sendLoginOtp(phone: phone);
      if (!mounted) return;
      setState(() => _submitting = false);

      _openOtpSheet(
        phone: phone,
        isLogin: true,
        initialResult: result,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      final appException = AppException.from(error);
      if (appException?.fieldErrors != null) {
        _applyServerFieldErrors(form, appException!.fieldErrors!);
      }
      _registerFailedAttempt();
      _showError(error, l10n);
    }
  }

  Future<void> _submitRegister() async {
    final l10n = AppLocalizations.of(context);
    final form = _registerFormKey.currentState;
    if (form == null || !form.saveAndValidate()) return;

    setState(() => _submitting = true);
    final v = form.value;
    final name = (v['name'] as String).trim();
    final email = (v['email'] as String).trim();
    final phone = (v['phone'] as String).trim();
    final cityId = _registerCityId ?? (v['city'] as String?) ?? '';

    try {
      final result = await ref.read(authRepositoryProvider).sendRegisterOtp(
            name: name,
            email: email,
            phone: phone,
            cityId: cityId,
          );
      if (!mounted) return;
      setState(() => _submitting = false);

      _openOtpSheet(
        phone: phone,
        isLogin: false,
        initialResult: result,
        registerName: name,
        registerEmail: email,
        registerCityId: cityId,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      final appException = AppException.from(error);
      if (appException?.fieldErrors != null) {
        _applyServerFieldErrors(form, appException!.fieldErrors!);
      }
      _showError(error, l10n);
    }
  }

  void _openOtpSheet({
    required String phone,
    required bool isLogin,
    required OtpSentResult initialResult,
    String? registerName,
    String? registerEmail,
    String? registerCityId,
  }) {
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: _OtpVerificationSheet(
          phone: phone,
          isLogin: isLogin,
          initialOtp: initialResult.otp,
          cooldownSeconds: initialResult.cooldownSeconds,
          registerName: registerName,
          registerEmail: registerEmail,
          registerCityId: registerCityId,
        ),
      ),
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
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _activeTab == 0
                                ? _buildLoginForm(l10n)
                                : _buildRegisterForm(l10n),
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
            name: 'phone',
            decoration: InputDecoration(
              labelText: l10n.mobileNumber,
              hintText: '10-digit mobile number',
              prefixText: '+91 ',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: l10n.requiredField),
              FormBuilderValidators.match(
                RegExp(r'^\d{10}$'),
                errorText: 'Mobile number must be exactly 10 digits',
              ),
            ]),
          ),
          const SizedBox(height: 20),
          LoadingButton.filled(
            width: double.infinity,
            isLoading: _submitting,
            loadingText: 'Sending OTP...',
            onPressed: (_submitting || _isCoolingDown) ? null : _submitLogin,
            child: Text(l10n.signInWithOtp),
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
            decoration: InputDecoration(
              labelText: l10n.mobileNumber,
              hintText: '10-digit mobile number',
              prefixText: '+91 ',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: l10n.requiredField),
              FormBuilderValidators.match(
                RegExp(r'^\d{10}$'),
                errorText: 'Mobile number must be exactly 10 digits',
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
          const SizedBox(height: 20),
          LoadingButton.filled(
            width: double.infinity,
            isLoading: _submitting,
            loadingText: 'Sending OTP...',
            onPressed: _submitting ? null : _submitRegister,
            child: Text(l10n.createIdentity),
          ),
        ],
      ),
    );
  }
}

class _OtpVerificationSheet extends ConsumerStatefulWidget {
  const _OtpVerificationSheet({
    required this.phone,
    required this.isLogin,
    this.initialOtp,
    this.cooldownSeconds = 60,
    this.registerName,
    this.registerEmail,
    this.registerCityId,
  });

  final String phone;
  final bool isLogin;
  final String? initialOtp;
  final int cooldownSeconds;
  final String? registerName;
  final String? registerEmail;
  final String? registerCityId;

  @override
  ConsumerState<_OtpVerificationSheet> createState() =>
      _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends ConsumerState<_OtpVerificationSheet> {
  late final TextEditingController _otpController;
  String? _currentOtp;
  late int _secondsLeft;
  Timer? _timer;
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _currentOtp = widget.initialOtp;
    _secondsLeft = widget.cooldownSeconds;
    _startCooldownTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _startCooldownTimer() {
    _timer?.cancel();
    if (_secondsLeft <= 0) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsLeft <= 1) {
        setState(() {
          _secondsLeft = 0;
          timer.cancel();
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_secondsLeft > 0 || _isResending) return;
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(authRepositoryProvider);
      final OtpSentResult result;
      if (widget.isLogin) {
        result = await repo.sendLoginOtp(phone: widget.phone);
      } else {
        result = await repo.sendRegisterOtp(
          name: widget.registerName ?? '',
          email: widget.registerEmail ?? '',
          phone: widget.phone,
          cityId: widget.registerCityId ?? '',
        );
      }
      if (!mounted) return;
      setState(() {
        _currentOtp = result.otp;
        _secondsLeft = result.cooldownSeconds;
        _isResending = false;
      });
      _startCooldownTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification code resent successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final appException = AppException.from(e);
      setState(() {
        _isResending = false;
        _errorMessage = appException?.message ?? 'Failed to resend code';
      });
    }
  }

  Future<void> _verifyOtp() async {
    final l10n = AppLocalizations.of(context);
    final code = _otpController.text.trim();
    if (code.length != 6) {
      setState(() {
        _errorMessage = l10n.invalidOtpLength;
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    if (widget.isLogin) {
      await ref.read(authControllerProvider.notifier).loginWithOtp(
            phone: widget.phone,
            otp: code,
          );
    } else {
      await ref.read(authControllerProvider.notifier).registerWithOtp(
            phone: widget.phone,
            otp: code,
            name: widget.registerName,
            email: widget.registerEmail,
            cityId: widget.registerCityId,
          );
    }

    if (!mounted) return;
    setState(() => _isVerifying = false);

    final state = ref.read(authControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        final appException = AppException.from(error);
        setState(() {
          _errorMessage = appException?.message ?? 'Verification failed';
        });
      },
      data: (user) {
        if (user != null) {
          Navigator.of(context).pop(true);
          context.go('/home');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.verifyMobileTitle,
                style: GoogleFonts.sora(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.enterOtpSubtitle('+91 ${widget.phone}'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 18),
          if (_currentOtp != null) ...[
            InkWell(
              onTap: () {
                _otpController.text = _currentOtp!;
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: scheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.testOtpBanner(_currentOtp!),
                            style: GoogleFonts.sora(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 1.5,
                              color: scheme.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.tapToAutoFill,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: scheme.onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.touch_app_outlined,
                      color: scheme.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Color(0xFFDC2626),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
          TextField(
            controller: _otpController,
            autofocus: true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: GoogleFonts.sora(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 12,
              color: scheme.onSurface,
            ),
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            decoration: InputDecoration(
              counterText: '',
              hintText: '------',
              hintStyle: GoogleFonts.sora(
                fontSize: 26,
                fontWeight: FontWeight.w400,
                letterSpacing: 12,
                color: scheme.outlineVariant,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onSubmitted: (_) => _verifyOtp(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_secondsLeft > 0)
                Text(
                  l10n.resendCodeIn(_secondsLeft),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                )
              else
                TextButton(
                  onPressed: _isResending ? null : _resendOtp,
                  child: _isResending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.resendCode),
                ),
            ],
          ),
          const SizedBox(height: 12),
          LoadingButton.filled(
            width: double.infinity,
            isLoading: _isVerifying,
            loadingText: 'Verifying...',
            onPressed: _isVerifying ? null : _verifyOtp,
            child: Text(l10n.verifyAndProceed),
          ),
        ],
      ),
    );
  }
}


