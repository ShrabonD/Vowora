import 'dart:convert';

class BirthdayGuest {
  final String id;
  final String eventId;
  String name;
  String phone;
  String email;
  String rsvpStatus; // pending, accepted, declined
  int accompaningGuests;
  String dietaryPreference;
  String notes;
  DateTime createdAt;

  BirthdayGuest({
    required this.id,
    required this.eventId,
    required this.name,
    this.phone = '',
    this.email = '',
    this.rsvpStatus = 'pending',
    this.accompaningGuests = 0,
    this.dietaryPreference = 'Regular',
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int get totalHeadcount => 1 + accompaningGuests;

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'name': name,
    'phone': phone,
    'email': email,
    'rsvpStatus': rsvpStatus,
    'accompaningGuests': accompaningGuests,
    'dietaryPreference': dietaryPreference,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BirthdayGuest.fromJson(Map<String, dynamic> json) => BirthdayGuest(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String? ?? '',
    email: json['email'] as String? ?? '',
    rsvpStatus: json['rsvpStatus'] as String? ?? 'pending',
    accompaningGuests: json['accompaningGuests'] as int? ?? 0,
    dietaryPreference: json['dietaryPreference'] as String? ?? 'Regular',
    notes: json['notes'] as String? ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );

  String encode() => jsonEncode(toJson());
  static BirthdayGuest decode(String source) => BirthdayGuest.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
