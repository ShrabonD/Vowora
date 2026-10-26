import 'dart:convert';

class BirthdayEvent {
  final String id;
  String personName;
  DateTime? dateOfBirth;
  DateTime eventDate;
  int? age;
  String birthdayType;
  String theme;
  String location;
  String venueType; // indoor / outdoor
  int expectedGuestCount;
  double totalBudget;
  String colorPalette;
  String celebrationStyle;
  String foodPreference;
  String cakeStyle;
  String entertainmentOption;
  String photographyPreference;
  String status; // planning, confirmed, completed
  DateTime createdAt;

  String get eventType => birthdayType;
  set eventType(String value) => birthdayType = value;

  String get style => celebrationStyle;
  set style(String value) => celebrationStyle = value;

  BirthdayEvent({
    required this.id,
    required this.personName,
    this.dateOfBirth,
    required this.eventDate,
    this.age,
    this.birthdayType = 'Personal Birthday',
    this.theme = 'Minimal Classy',
    this.location = '',
    this.venueType = 'Indoor',
    this.expectedGuestCount = 20,
    this.totalBudget = 50000,
    this.colorPalette = 'Warm Neutrals',
    this.celebrationStyle = 'Elegant',
    this.foodPreference = 'Mixed',
    this.cakeStyle = 'Classic',
    this.entertainmentOption = 'Music',
    this.photographyPreference = 'Professional',
    this.status = 'planning',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get daysRemaining {
    final now = DateTime.now();
    final diff = eventDate.difference(DateTime(now.year, now.month, now.day)).inDays;
    return diff < 0 ? 0 : diff;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'personName': personName,
    'dateOfBirth': dateOfBirth?.toIso8601String(),
    'eventDate': eventDate.toIso8601String(),
    'age': age,
    'birthdayType': birthdayType,
    'theme': theme,
    'location': location,
    'venueType': venueType,
    'expectedGuestCount': expectedGuestCount,
    'totalBudget': totalBudget,
    'colorPalette': colorPalette,
    'celebrationStyle': celebrationStyle,
    'foodPreference': foodPreference,
    'cakeStyle': cakeStyle,
    'entertainmentOption': entertainmentOption,
    'photographyPreference': photographyPreference,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BirthdayEvent.fromJson(Map<String, dynamic> json) => BirthdayEvent(
    id: json['id'] as String,
    personName: json['personName'] as String,
    dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth'] as String) : null,
    eventDate: DateTime.parse(json['eventDate'] as String),
    age: json['age'] as int?,
    birthdayType: json['birthdayType'] as String? ?? 'Personal Birthday',
    theme: json['theme'] as String? ?? 'Minimal Classy',
    location: json['location'] as String? ?? '',
    venueType: json['venueType'] as String? ?? 'Indoor',
    expectedGuestCount: json['expectedGuestCount'] as int? ?? 20,
    totalBudget: (json['totalBudget'] as num?)?.toDouble() ?? 50000,
    colorPalette: json['colorPalette'] as String? ?? 'Warm Neutrals',
    celebrationStyle: json['celebrationStyle'] as String? ?? 'Elegant',
    foodPreference: json['foodPreference'] as String? ?? 'Mixed',
    cakeStyle: json['cakeStyle'] as String? ?? 'Classic',
    entertainmentOption: json['entertainmentOption'] as String? ?? 'Music',
    photographyPreference: json['photographyPreference'] as String? ?? 'Professional',
    status: json['status'] as String? ?? 'planning',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );

  String encode() => jsonEncode(toJson());
  static BirthdayEvent decode(String source) => BirthdayEvent.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
