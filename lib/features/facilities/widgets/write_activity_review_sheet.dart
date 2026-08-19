import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/activities_providers.dart';
import '../../../data/repositories/activities_repository.dart';

class WriteActivityReviewSheet extends ConsumerStatefulWidget {
  const WriteActivityReviewSheet({
    super.key,
    required this.activityId,
    required this.activityName,
  });

  final String activityId;
  final String activityName;

  static const Color _primary = Color(0xFF1565D8);

  static Future<bool?> show(BuildContext context, {required String activityId, required String activityName}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => WriteActivityReviewSheet(
        activityId: activityId,
        activityName: activityName,
      ),
    );
  }

  @override
  ConsumerState<WriteActivityReviewSheet> createState() => _WriteActivityReviewSheetState();
}

class _WriteActivityReviewSheetState extends ConsumerState<WriteActivityReviewSheet> {
  int _selectedRating = 5;
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      setState(() => _errorMessage = 'Please write a few words about your experience.');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(activitiesRepositoryProvider);
      await repo.submitReview(
        widget.activityId,
        rating: _selectedRating,
        title: _titleController.text.trim().isNotEmpty ? _titleController.text.trim() : null,
        comment: comment,
      );

      // Invalidate providers to refresh live rating & reviews
      ref.invalidate(activityDetailsProvider(widget.activityId));
      ref.invalidate(activityReviewsProvider(widget.activityId));

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Thank you! Your review has been submitted.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF181B26) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Write a Citizen Review',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                widget.activityName,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 20),

              // Star selection
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final star = index + 1;
                    return IconButton(
                      onPressed: () => setState(() => _selectedRating = star),
                      icon: Icon(
                        star <= _selectedRating ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 38,
                        color: star <= _selectedRating ? const Color(0xFFF59E0B) : const Color(0xFF94A3B8),
                      ),
                    );
                  }),
                ),
              ),
              Center(
                child: Text(
                  _getRatingLabel(_selectedRating),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFF59E0B),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Review Title Input
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title (Optional)',
                  hintText: 'e.g. Great coaching & supportive instructors!',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
              const SizedBox(height: 14),

              // Comment Input
              TextField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Your Experience *',
                  hintText: 'Share details about the coaching quality, facilities, discipline, cleanliness...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
              ],

              const SizedBox(height: 20),

              // Submit CTA Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WriteActivityReviewSheet._primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Submit Review',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 5:
        return '5.0 — Excellent, Highly Recommended!';
      case 4:
        return '4.0 — Very Good';
      case 3:
        return '3.0 — Average';
      case 2:
        return '2.0 — Poor Experience';
      case 1:
        return '1.0 — Terrible';
      default:
        return '';
    }
  }
}
