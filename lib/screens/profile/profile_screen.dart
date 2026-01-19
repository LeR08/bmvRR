import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../auth/sign_in_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.appUser;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // Avatar et infos utilisateur
              _buildUserInfo(user),

              const SizedBox(height: AppSpacing.xl),

              // Statistiques
              _buildStatsCard(user),

              const SizedBox(height: AppSpacing.lg),

              // Abonnement
              _buildSubscriptionCard(user, context),

              const SizedBox(height: AppSpacing.lg),

              // Partenaire
              _buildPartnerCard(user, context),

              const SizedBox(height: AppSpacing.lg),

              // Paramètres
              _buildSettingsSection(context, authProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary,
          backgroundImage: user.photoUrl != null
              ? NetworkImage(user.photoUrl!)
              : null,
          child: user.photoUrl == null
              ? Text(
                  user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          user.displayName ?? 'Utilisateur',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          user.email,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard(user) {
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  Icons.quiz,
                  user.stats.quizzesCompleted.toString(),
                  'Quiz',
                ),
                _buildStatItem(
                  Icons.access_time,
                  '${user.stats.totalTimeSpentMinutes}min',
                  'Temps',
                ),
                _buildStatItem(
                  Icons.local_fire_department,
                  user.stats.daysStreak.toString(),
                  'Jours',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 32),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(user, BuildContext context) {
    final tierName = _getTierName(user.subscriptionTier);
    final isPremium = user.isPremium;

    return Card(
      elevation: 2,
      color: isPremium
          ? AppColors.primary.withOpacity(0.1)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPremium ? Icons.star : Icons.star_outline,
                  color: isPremium ? AppColors.accent : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'Abonnement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              tierName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isPremium ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
            if (isPremium && user.subscriptionExpiresAt != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Expire le ${_formatDate(user.subscriptionExpiresAt!)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            CustomButton(
              text: isPremium ? 'Gérer mon abonnement' : 'Passer à Premium',
              isOutlined: isPremium,
              onPressed: () {
                // TODO: Navigate to subscription screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fonctionnalité à venir !'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerCard(user, BuildContext context) {
    final hasPartner = user.hasPartner;

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
            Row(
              children: [
                const Icon(Icons.favorite, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'Partenaire',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (hasPartner) ...[
              const Text(
                'Partenaire associé',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              CustomButton(
                text: 'Voir le profil',
                isOutlined: true,
                onPressed: () {
                  // TODO: Navigate to partner profile
                },
              ),
            ] else ...[
              const Text(
                'Aucun partenaire associé',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Votre code d\'invitation: ${user.partnerInviteCode}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Copier le code',
                      icon: Icons.copy,
                      isOutlined: true,
                      onPressed: () {
                        // TODO: Copy code to clipboard
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Code copié !'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CustomButton(
                      text: 'Entrer un code',
                      onPressed: () {
                        // TODO: Show dialog to enter partner code
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Paramètres',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSettingTile(
          Icons.history,
          'Historique',
          () {
            // TODO: Navigate to history screen
          },
        ),
        _buildSettingTile(
          Icons.notifications_outlined,
          'Notifications',
          () {
            // TODO: Navigate to notifications settings
          },
        ),
        _buildSettingTile(
          Icons.language,
          'Langue',
          () {
            // TODO: Navigate to language settings
          },
        ),
        _buildSettingTile(
          Icons.help_outline,
          'Aide',
          () {
            // TODO: Navigate to help screen
          },
        ),
        const SizedBox(height: AppSpacing.md),
        CustomButton(
          text: 'Se déconnecter',
          backgroundColor: AppColors.error,
          icon: Icons.logout,
          onPressed: () async {
            await authProvider.signOut();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  String _getTierName(tier) {
    switch (tier.name) {
      case 'free':
        return 'Gratuit';
      case 'solo':
        return 'Solo Premium';
      case 'couple':
        return 'Couple Premium';
      case 'elite':
        return 'Elite';
      case 'lifetime':
        return 'À vie';
      default:
        return 'Gratuit';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
