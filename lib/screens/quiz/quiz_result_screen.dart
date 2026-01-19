import 'package:flutter/material.dart';
import '../../models/quiz.dart';
import '../../models/quiz_result.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class QuizResultScreen extends StatelessWidget {
  final Quiz quiz;
  final QuizResult result;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Résultats',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Félicitations
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                gradient: AppColors.coupleGradient,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.celebration,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Quiz terminé !',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    quiz.title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Statistiques
            _buildStatsCard(context),

            const SizedBox(height: AppSpacing.lg),

            // Questions de discussion
            if (quiz.type == QuizType.precise || quiz.type == QuizType.personality)
              _buildDiscussionCard(context),

            const SizedBox(height: AppSpacing.xl),

            // Boutons d'action
            CustomButton(
              text: 'Partager avec mon partenaire',
              icon: Icons.share,
              onPressed: () {
                // TODO: Implement sharing
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir !'),
                  ),
                );
              },
            ),

            const SizedBox(height: AppSpacing.md),

            CustomButton(
              text: 'Retour à l\'accueil',
              isOutlined: true,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    final timeMinutes = (result.timeSpentSeconds / 60).ceil();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vos statistiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildStatRow(
              Icons.quiz_outlined,
              'Questions répondues',
              '${result.answers.length}/${quiz.questions.length}',
            ),
            const Divider(),
            _buildStatRow(
              Icons.access_time,
              'Temps passé',
              '$timeMinutes minute${timeMinutes > 1 ? 's' : ''}',
            ),
            const Divider(),
            _buildStatRow(
              Icons.grade,
              'Score',
              '${result.totalScore} points',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionCard(BuildContext context) {
    final discussionQuestions = [
      'Qu\'avez-vous découvert sur vous-même ?',
      'Y a-t-il des réponses qui vous ont surpris ?',
      'Comment pourriez-vous appliquer ces réflexions à votre relation ?',
    ];

    return Card(
      elevation: 2,
      color: AppColors.info.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.chat_bubble_outline, color: AppColors.info),
                SizedBox(width: AppSpacing.sm),
                Text(
                  'Questions à discuter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...discussionQuestions.map((question) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '•',
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        question,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
