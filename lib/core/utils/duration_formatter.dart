/// Utility functions for formatting durations (minutes, seconds) into
/// clean human-readable strings like '1h40m', '45m', '2h', etc.
library;

/// Formats a duration given in minutes to a human-readable string:
/// - 45 -> "45m"
/// - 60 -> "1h"
/// - 100 -> "1h40m" (or "1h 40m" if [spaced] is true)
/// - 0 -> "0m"
/// - null -> "--" (or custom [fallback])
String formatMinutes(
  num? minutes, {
  bool spaced = false,
  String fallback = '--',
}) {
  if (minutes == null) return fallback;
  final totalMins = minutes.round();
  if (totalMins <= 0) return '0m';

  final hours = totalMins ~/ 60;
  final remainingMins = totalMins % 60;

  if (hours == 0) return '${remainingMins}m';
  if (remainingMins == 0) return '${hours}h';

  final separator = spaced ? ' ' : '';
  return '${hours}h$separator${remainingMins}m';
}

/// Formats a duration given in seconds:
/// - 2700s (45 mins) -> "45m"
/// - 6000s (100 mins) -> "1h40m"
String? formatSeconds(
  num? seconds, {
  bool spaced = false,
  String? fallback,
}) {
  if (seconds == null || seconds <= 0) return fallback;
  return formatMinutes(seconds / 60, spaced: spaced, fallback: fallback ?? '--');
}
