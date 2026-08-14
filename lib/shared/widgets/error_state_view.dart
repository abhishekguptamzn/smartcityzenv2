import 'package:flutter/material.dart';

import '../../data/api/app_exception.dart';
import '../../l10n/gen/app_localizations.dart';

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  String _localizedMessage(AppLocalizations l10n) {
    final e = AppException.from(error);
    if (e == null) return l10n.errorGeneric;
    return switch (e.code) {
      AppExceptionCode.validation =>
        e.fieldErrors?.values.firstOrNull?.firstOrNull ?? (e.message.isNotEmpty ? e.message : l10n.errorValidation),
      AppExceptionCode.authentication =>
        e.message.isNotEmpty ? e.message : l10n.errorAuthentication,
      AppExceptionCode.authorization => l10n.errorAuthorization,
      AppExceptionCode.accountBlocked =>
        e.message.isNotEmpty ? e.message : l10n.errorAccountBlocked,
      AppExceptionCode.accountInactive =>
        e.message.isNotEmpty ? e.message : l10n.errorAccountInactive,
      AppExceptionCode.notFound =>
        e.message.isNotEmpty ? e.message : l10n.errorNotFound,
      AppExceptionCode.conflict =>
        e.message.isNotEmpty ? e.message : l10n.errorConflict,
      AppExceptionCode.badRequest =>
        e.message.isNotEmpty ? e.message : l10n.errorValidation,
      AppExceptionCode.rateLimited => l10n.errorRateLimited(
        e.retryAfterSeconds ?? 60,
      ),
      AppExceptionCode.server => l10n.errorServer,
      AppExceptionCode.network => l10n.noInternetConnection,
      AppExceptionCode.unknown =>
        e.message.isNotEmpty ? e.message : l10n.errorGeneric,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: scheme.error.withValues(alpha: 0.12),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: scheme.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.somethingWentWrong,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _localizedMessage(l10n),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
