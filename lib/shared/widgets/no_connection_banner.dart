import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../l10n/gen/app_localizations.dart';

/// Wraps [child] and shows a persistent top banner whenever the device has
/// no network connectivity. Place once, near the root of the authenticated
/// shell, rather than per-screen.
class NoConnectionBanner extends StatefulWidget {
  const NoConnectionBanner({super.key, required this.child});

  final Widget child;

  @override
  State<NoConnectionBanner> createState() => _NoConnectionBannerState();
}

class _NoConnectionBannerState extends State<NoConnectionBanner> {
  bool _offline = false;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = Connectivity().onConnectivityChanged.listen(_handleResults);
    Connectivity().checkConnectivity().then(_handleResults);
  }

  void _handleResults(List<ConnectivityResult> results) {
    final offline =
        results.isEmpty || results.every((r) => r == ConnectivityResult.none);
    if (mounted) setState(() => _offline = offline);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _offline
              ? Container(
                  key: const ValueKey('offline-banner'),
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.noInternetConnection,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('online')),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}
