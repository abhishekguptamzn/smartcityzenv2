import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../empty_state_view.dart';
import '../error_state_view.dart';

/// Smooth animated transition between skeleton and actual content.
class SkeletonCrossfade extends StatelessWidget {
  const SkeletonCrossfade({
    super.key,
    required this.isLoading,
    required this.skeleton,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
  });

  final bool isLoading;
  final Widget skeleton;
  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: isLoading
          ? KeyedSubtree(
              key: const ValueKey('skeleton_state'),
              child: skeleton,
            )
          : KeyedSubtree(
              key: const ValueKey('content_state'),
              child: child,
            ),
    );
  }
}

/// Declarative Riverpod AsyncValue builder that renders a screen-specific skeleton
/// during loading, an empty state when data is an empty collection, an error state with retry,
/// and the real data widget with smooth animated transition.
class AsyncSkeletonBuilder<T> extends StatelessWidget {
  const AsyncSkeletonBuilder({
    super.key,
    required this.asyncValue,
    required this.skeleton,
    required this.builder,
    this.errorBuilder,
    this.emptyBuilder,
    this.isEmpty,
    this.onRetry,
    this.duration = const Duration(milliseconds: 300),
  });

  final AsyncValue<T> asyncValue;
  final Widget skeleton;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final bool Function(T data)? isEmpty;
  final VoidCallback? onRetry;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: asyncValue.when(
        loading: () => KeyedSubtree(
          key: const ValueKey('async_skeleton'),
          child: skeleton,
        ),
        error: (error, _) => KeyedSubtree(
          key: const ValueKey('async_error'),
          child: errorBuilder != null
              ? errorBuilder!(context, error)
              : ErrorStateView(error: error, onRetry: onRetry),
        ),
        data: (data) {
          if (isEmpty != null && isEmpty!(data)) {
            return KeyedSubtree(
              key: const ValueKey('async_empty'),
              child: emptyBuilder != null
                  ? emptyBuilder!(context)
                  : const EmptyStateView(
                      icon: Icons.inbox_outlined,
                      message: 'No records found.',
                    ),
            );
          }
          return KeyedSubtree(
            key: const ValueKey('async_data'),
            child: builder(context, data),
          );
        },
      ),
    );
  }
}
