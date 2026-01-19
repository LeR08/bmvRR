import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/quiz_card.dart';
import '../../models/quiz.dart';
import '../profile/profile_screen.dart';
import '../quiz/quiz_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final quizProvider = context.read<QuizProvider>();

    if (authProvider.appUser != null) {
      await quizProvider.loadQuizzes(authProvider.appUser!);
      await quizProvider.loadUserResults(authProvider.appUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? _buildHomeTab() : _buildProfileTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildWelcomeSection(),
          _buildFeaturedSection(),
          _buildCategoriesSection(),
          _buildAllQuizzesSection(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.coupleGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Text(
            'Couples Distance',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SliverToBoxAdapter(
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.appUser;
          if (user == null) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppColors.coupleGradient,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour ${user.displayName ?? 'vous'} 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  user.hasPartner
                      ? 'Prêt(e) à renforcer votre relation ?'
                      : 'Invitez votre partenaire pour débloquer plus de contenus',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                if (!user.hasPartner) ...[
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to partner invite
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Inviter mon partenaire'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'Quiz recommandés',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              if (quizProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final featuredQuizzes = quizProvider.getFeaturedQuizzes();

              if (featuredQuizzes.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Text('Aucun quiz disponible'),
                );
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: featuredQuizzes.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: AppSpacing.md),
                      child: QuizCard(
                        quiz: featuredQuizzes[index],
                        onTap: () => _startQuiz(featuredQuizzes[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'Catégories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _buildCategoryChip('Communication', Icons.chat_bubble_outline, QuizType.precise),
                _buildCategoryChip('Fun', Icons.celebration, QuizType.fun),
                _buildCategoryChip('Personnalité', Icons.psychology, QuizType.personality),
                _buildCategoryChip('Astrologie', Icons.star, QuizType.astrology),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, QuizType type) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: InkWell(
        onTap: () {
          // TODO: Filter quizzes by type
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 32),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllQuizzesSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              'Tous les quiz',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              final quizzes = quizProvider.accessibleQuizzes;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: QuizCard(
                      quiz: quizzes[index],
                      onTap: () => _startQuiz(quizzes[index]),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return const ProfileScreen();
  }

  void _startQuiz(Quiz quiz) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.appUser;

    if (user == null) return;

    // Vérifier l'accès premium si nécessaire
    if (quiz.isPremium && !user.isPremium) {
      _showPremiumDialog();
      return;
    }

    // Démarrer le quiz
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizPlayerScreen(quiz: quiz),
      ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Abonnement requis'),
        content: const Text(
          'Ce contenu nécessite un abonnement premium. Passez à Premium pour accéder à tous les quiz !',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Plus tard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to subscription screen
            },
            child: const Text('Voir les offres'),
          ),
        ],
      ),
    );
  }
}
