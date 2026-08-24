import 'package:flutter/material.dart';

import 'skeleton_card.dart';
import 'skeleton_primitives.dart';

/// Reusable list row skeleton.
class SkeletonListItem extends StatelessWidget {
  const SkeletonListItem({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = true,
    this.leadingSize = 44,
    this.leadingIsCircle = true,
    this.lines = 2,
    this.margin = const EdgeInsets.only(bottom: 12),
    this.padding = const EdgeInsets.all(14),
  });

  final bool hasLeading;
  final bool hasTrailing;
  final double leadingSize;
  final bool leadingIsCircle;
  final int lines;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      margin: margin,
      padding: padding,
      child: Row(
        children: [
          if (hasLeading) ...[
            leadingIsCircle
                ? SkeletonCircle(size: leadingSize)
                : SkeletonBox(
                    width: leadingSize,
                    height: leadingSize,
                    borderRadius: BorderRadius.circular(12),
                  ),
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SkeletonText(width: 140, height: 15),
                if (lines > 1) ...[
                  const SizedBox(height: 6),
                  const SkeletonText(width: 200, height: 12),
                ],
                if (lines > 2) ...[
                  const SizedBox(height: 6),
                  const SkeletonText(width: 110, height: 11),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 12),
            const SkeletonBox(
              width: 54,
              height: 24,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Chat / Message bubble skeleton for support & enquiry conversations.
class SkeletonConversationItem extends StatelessWidget {
  const SkeletonConversationItem({
    super.key,
    this.isMe = false,
    this.widthRatio = 0.65,
    this.margin = const EdgeInsets.only(bottom: 12),
  });

  final bool isMe;
  final double widthRatio;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: widthRatio,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                  : (Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMe ? 16 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 16),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                SkeletonText(lines: 2, height: 13, spacing: 6),
                SizedBox(height: 6),
                SkeletonBox(
                  width: 45,
                  height: 10,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Timeline item skeleton for City History & Timeline.
class SkeletonTimelineItem extends StatelessWidget {
  const SkeletonTimelineItem({
    super.key,
    this.isLast = false,
  });

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vertical spine with node
          Column(
            children: [
              const SizedBox(height: 4),
              const SkeletonCircle(size: 14),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Content card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: SkeletonCard(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonText(width: 90, height: 14),
                        SkeletonChip(width: 60, height: 18),
                      ],
                    ),
                    SizedBox(height: 8),
                    SkeletonText(width: 160, height: 16),
                    SizedBox(height: 6),
                    SkeletonText(lines: 2, height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
