enum SubscriptionTier {
  free,
  solo,
  couple,
  elite,
  lifetime,
}

class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final SubscriptionTier subscriptionTier;
  final DateTime? subscriptionExpiresAt;
  final String? partnerId; // ID du partenaire si en couple
  final String? partnerInviteCode; // Code pour inviter le partenaire
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserPreferences preferences;
  final UserStats stats;

  AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.subscriptionTier = SubscriptionTier.free,
    this.subscriptionExpiresAt,
    this.partnerId,
    this.partnerInviteCode,
    required this.createdAt,
    required this.lastLoginAt,
    UserPreferences? preferences,
    UserStats? stats,
  })  : preferences = preferences ?? UserPreferences(),
        stats = stats ?? UserStats();

  bool get isPremium =>
      subscriptionTier != SubscriptionTier.free &&
      (subscriptionTier == SubscriptionTier.lifetime ||
          (subscriptionExpiresAt != null &&
              subscriptionExpiresAt!.isAfter(DateTime.now())));

  bool get hasPartner => partnerId != null && partnerId!.isNotEmpty;

  bool get canAccessSoloContent =>
      isPremium &&
      (subscriptionTier == SubscriptionTier.solo ||
          subscriptionTier == SubscriptionTier.couple ||
          subscriptionTier == SubscriptionTier.elite ||
          subscriptionTier == SubscriptionTier.lifetime);

  bool get canAccessCoupleContent =>
      isPremium &&
      hasPartner &&
      (subscriptionTier == SubscriptionTier.couple ||
          subscriptionTier == SubscriptionTier.elite ||
          subscriptionTier == SubscriptionTier.lifetime);

  bool get canAccessEliteContent =>
      isPremium &&
      (subscriptionTier == SubscriptionTier.elite ||
          subscriptionTier == SubscriptionTier.lifetime);

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      subscriptionTier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['subscriptionTier'],
        orElse: () => SubscriptionTier.free,
      ),
      subscriptionExpiresAt: json['subscriptionExpiresAt'] != null
          ? DateTime.parse(json['subscriptionExpiresAt'] as String)
          : null,
      partnerId: json['partnerId'] as String?,
      partnerInviteCode: json['partnerInviteCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: DateTime.parse(json['lastLoginAt'] as String),
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'] as Map<String, dynamic>)
          : UserPreferences(),
      stats: json['stats'] != null
          ? UserStats.fromJson(json['stats'] as Map<String, dynamic>)
          : UserStats(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'subscriptionTier': subscriptionTier.name,
      'subscriptionExpiresAt': subscriptionExpiresAt?.toIso8601String(),
      'partnerId': partnerId,
      'partnerInviteCode': partnerInviteCode,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    SubscriptionTier? subscriptionTier,
    DateTime? subscriptionExpiresAt,
    String? partnerId,
    String? partnerInviteCode,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
    UserStats? stats,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionExpiresAt: subscriptionExpiresAt ?? this.subscriptionExpiresAt,
      partnerId: partnerId ?? this.partnerId,
      partnerInviteCode: partnerInviteCode ?? this.partnerInviteCode,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

class UserPreferences {
  final bool notificationsEnabled;
  final String language; // 'fr', 'en'
  final bool showAds; // Si false, l'utilisateur a payé pour enlever les pubs

  UserPreferences({
    this.notificationsEnabled = true,
    this.language = 'fr',
    this.showAds = true,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      language: json['language'] as String? ?? 'fr',
      showAds: json['showAds'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'language': language,
      'showAds': showAds,
    };
  }
}

class UserStats {
  final int quizzesCompleted;
  final int totalTimeSpentMinutes;
  final int daysStreak;
  final DateTime? lastQuizCompletedAt;
  final Map<String, int> categoriesCompleted; // category -> count

  UserStats({
    this.quizzesCompleted = 0,
    this.totalTimeSpentMinutes = 0,
    this.daysStreak = 0,
    this.lastQuizCompletedAt,
    this.categoriesCompleted = const {},
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      quizzesCompleted: json['quizzesCompleted'] as int? ?? 0,
      totalTimeSpentMinutes: json['totalTimeSpentMinutes'] as int? ?? 0,
      daysStreak: json['daysStreak'] as int? ?? 0,
      lastQuizCompletedAt: json['lastQuizCompletedAt'] != null
          ? DateTime.parse(json['lastQuizCompletedAt'] as String)
          : null,
      categoriesCompleted: json['categoriesCompleted'] != null
          ? Map<String, int>.from(json['categoriesCompleted'])
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizzesCompleted': quizzesCompleted,
      'totalTimeSpentMinutes': totalTimeSpentMinutes,
      'daysStreak': daysStreak,
      'lastQuizCompletedAt': lastQuizCompletedAt?.toIso8601String(),
      'categoriesCompleted': categoriesCompleted,
    };
  }
}
