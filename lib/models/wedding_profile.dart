class WeddingProfile {
  final String id;
  final String userId;
  final String coupleName;
  final DateTime weddingDate;
  final String location;
  final int estimatedGuestCount;
  final double estimatedBudget;
  final String currency;
  final String style;
  final String? primaryColor;

  WeddingProfile({
    required this.id,
    required this.userId,
    required this.coupleName,
    required this.weddingDate,
    required this.location,
    required this.estimatedGuestCount,
    required this.estimatedBudget,
    required this.currency,
    required this.style,
    this.primaryColor,
  });

  int get daysUntilWedding {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(weddingDate.year, weddingDate.month, weddingDate.day);
    return target.difference(today).inDays;
  }

  factory WeddingProfile.fromJson(Map<String, dynamic> json) {
    return WeddingProfile(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      coupleName: json['couple_name'] ?? json['coupleName'] ?? 'Shrabonti & Alex',
      weddingDate: json['wedding_date'] != null
          ? DateTime.parse(json['wedding_date'])
          : DateTime.now().add(const Duration(days: 120)),
      location: json['location'] ?? 'Dhaka, Bangladesh',
      estimatedGuestCount: (json['estimated_guest_count'] ?? json['estimatedGuestCount'] ?? 250) as int,
      estimatedBudget: (json['estimated_budget'] ?? json['estimatedBudget'] ?? 15000.0) as double,
      currency: json['currency'] ?? 'USD (\$)',
      style: json['style'] ?? 'Luxury',
      primaryColor: json['primary_color'] ?? json['primaryColor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'couple_name': coupleName,
      'wedding_date': weddingDate.toIso8601String(),
      'location': location,
      'estimated_guest_count': estimatedGuestCount,
      'estimated_budget': estimatedBudget,
      'currency': currency,
      'style': style,
      'primary_color': primaryColor,
    };
  }

  WeddingProfile copyWith({
    String? coupleName,
    DateTime? weddingDate,
    String? location,
    int? estimatedGuestCount,
    double? estimatedBudget,
    String? currency,
    String? style,
    String? primaryColor,
  }) {
    return WeddingProfile(
      id: id,
      userId: userId,
      coupleName: coupleName ?? this.coupleName,
      weddingDate: weddingDate ?? this.weddingDate,
      location: location ?? this.location,
      estimatedGuestCount: estimatedGuestCount ?? this.estimatedGuestCount,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      currency: currency ?? this.currency,
      style: style ?? this.style,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}
