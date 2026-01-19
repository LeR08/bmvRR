import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../utils/constants.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image ou gradient
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: _getGradientForType(),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.md),
                  topRight: Radius.circular(AppBorderRadius.md),
                ),
              ),
              child: Stack(
                children: [
                  // Badge premium
                  if (quiz.isPremium)
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: const Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Icône du type
                  Center(
                    child: Icon(
                      _getIconForType(),
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Contenu
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    quiz.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Description
                  Text(
                    quiz.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Métadonnées
                  Row(
                    children: [
                      // Nombre de questions
                      Icon(
                        Icons.quiz_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${quiz.questions.length} questions',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(width: AppSpacing.md),

                      // Durée estimée
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '~${quiz.estimatedMinutes} min',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  // Tags
                  if (quiz.tags.isNotEmpty)
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: quiz.tags.take(3).map((tag) {
                        return Chip(
                          label: Text(
                            tag,
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          padding: EdgeInsets.zero,
                          labelPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                          ),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getGradientForType() {
    switch (quiz.type) {
      case QuizType.fun:
        return const LinearGradient(
          colors: [Color(0xFFFF6B9D), Color(0xFFFF9A9E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case QuizType.precise:
        return const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF5EC8F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case QuizType.personality:
        return const LinearGradient(
          colors: [Color(0xFF9B59B6), Color(0xFFBB69C6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case QuizType.astrology:
        return const LinearGradient(
          colors: [Color(0xFFFFC837), Color(0xFFFFE082)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getIconForType() {
    switch (quiz.type) {
      case QuizType.fun:
        return Icons.celebration;
      case QuizType.precise:
        return Icons.chat_bubble_outline;
      case QuizType.personality:
        return Icons.psychology;
      case QuizType.astrology:
        return Icons.star;
    }
  }
}
