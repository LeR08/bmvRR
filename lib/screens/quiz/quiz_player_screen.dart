import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/quiz.dart';
import '../../models/question.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import 'quiz_result_screen.dart';

class QuizPlayerScreen extends StatefulWidget {
  final Quiz quiz;

  const QuizPlayerScreen({
    super.key,
    required this.quiz,
  });

  @override
  State<QuizPlayerScreen> createState() => _QuizPlayerScreenState();
}

class _QuizPlayerScreenState extends State<QuizPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().startQuiz(widget.quiz);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldLeave = await _showExitDialog();
        return shouldLeave ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () async {
              final shouldLeave = await _showExitDialog();
              if (shouldLeave == true && mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            widget.quiz.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: Consumer<QuizProvider>(
              builder: (context, quizProvider, child) {
                return LinearProgressIndicator(
                  value: quizProvider.progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                );
              },
            ),
          ),
        ),
        body: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            if (quizProvider.currentQuiz == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final question = quizProvider.currentQuiz!
                .questions[quizProvider.currentQuestionIndex];

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Numéro de question
                        Text(
                          'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.currentQuiz!.questions.length}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Question
                        Text(
                          question.text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Réponses
                        _buildAnswers(question, quizProvider),
                      ],
                    ),
                  ),
                ),

                // Boutons de navigation
                _buildNavigationButtons(quizProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnswers(Question question, QuizProvider quizProvider) {
    switch (question.type) {
      case QuestionType.multipleChoice:
      case QuestionType.yesNo:
        return _buildMultipleChoice(question, quizProvider);
      case QuestionType.scale:
        return _buildScale(question, quizProvider);
      case QuestionType.multiSelect:
        return _buildMultiSelect(question, quizProvider);
    }
  }

  Widget _buildMultipleChoice(Question question, QuizProvider quizProvider) {
    final currentAnswer = quizProvider.currentAnswers[question.id];
    final selectedAnswerId = currentAnswer?.selectedAnswerIds.firstOrNull;

    return Column(
      children: question.answers.map((answer) {
        final isSelected = selectedAnswerId == answer.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: InkWell(
            onTap: () {
              quizProvider.answerQuestion(
                question.id,
                [answer.id],
                answer.value,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      answer.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScale(Question question, QuizProvider quizProvider) {
    final currentAnswer = quizProvider.currentAnswers[question.id];
    int? selectedValue = currentAnswer?.score;

    return Column(
      children: [
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              question.answers.first.text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              question.answers.last.text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),

        // Échelle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = selectedValue == value;

            return InkWell(
              onTap: () {
                final answer = question.answers.firstWhere(
                  (a) => a.value == value,
                  orElse: () => question.answers.first,
                );
                quizProvider.answerQuestion(
                  question.id,
                  [answer.id],
                  value,
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: AppSpacing.md),

        // Description sélection
        if (selectedValue != null)
          Text(
            'Sélectionné: $selectedValue/5',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildMultiSelect(Question question, QuizProvider quizProvider) {
    final currentAnswer = quizProvider.currentAnswers[question.id];
    final selectedAnswerIds = currentAnswer?.selectedAnswerIds ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vous pouvez sélectionner plusieurs réponses',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...question.answers.map((answer) {
          final isSelected = selectedAnswerIds.contains(answer.id);

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: InkWell(
              onTap: () {
                final newSelectedIds = List<String>.from(selectedAnswerIds);
                if (isSelected) {
                  newSelectedIds.remove(answer.id);
                } else {
                  newSelectedIds.add(answer.id);
                }

                final totalScore = newSelectedIds.fold<int>(
                  0,
                  (sum, id) {
                    final ans = question.answers.firstWhere((a) => a.id == id);
                    return sum + ans.value;
                  },
                );

                quizProvider.answerQuestion(
                  question.id,
                  newSelectedIds,
                  totalScore,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        answer.text,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNavigationButtons(QuizProvider quizProvider) {
    final isFirstQuestion = quizProvider.currentQuestionIndex == 0;
    final isLastQuestion = quizProvider.currentQuestionIndex ==
        quizProvider.currentQuiz!.questions.length - 1;
    final canContinue = quizProvider.canGoToNextQuestion();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isFirstQuestion)
            Expanded(
              child: CustomButton(
                text: 'Précédent',
                onPressed: quizProvider.previousQuestion,
                isOutlined: true,
              ),
            ),
          if (!isFirstQuestion) const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: CustomButton(
              text: isLastQuestion ? 'Terminer' : 'Suivant',
              onPressed: canContinue
                  ? () async {
                      if (isLastQuestion) {
                        await _finishQuiz();
                      } else {
                        quizProvider.nextQuestion();
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _finishQuiz() async {
    final authProvider = context.read<AuthProvider>();
    final quizProvider = context.read<QuizProvider>();

    if (authProvider.appUser == null) return;

    final result = await quizProvider.finishQuiz(
      authProvider.appUser!.id,
    );

    if (result != null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            quiz: widget.quiz,
            result: result,
          ),
        ),
      );
    }
  }

  Future<bool?> _showExitDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter le quiz ?'),
        content: const Text(
          'Votre progression sera perdue si vous quittez maintenant.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continuer le quiz'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Quitter',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
