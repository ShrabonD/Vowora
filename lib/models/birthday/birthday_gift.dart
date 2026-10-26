import 'dart:convert';

class BirthdayGift {
  final String id;
  final String eventId;
  String name;
  String description;
  double estimatedPrice;
  String purchaseLink;
  String assignedTo;
  bool isPurchased;
  bool isWrapped;
  String notes;
  DateTime createdAt;

  BirthdayGift({
    required this.id,
    required this.eventId,
    required this.name,
    this.description = '',
    this.estimatedPrice = 0,
    this.purchaseLink = '',
    this.assignedTo = '',
    this.isPurchased = false,
    this.isWrapped = false,
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'name': name,
    'description': description,
    'estimatedPrice': estimatedPrice,
    'purchaseLink': purchaseLink,
    'assignedTo': assignedTo,
    'isPurchased': isPurchased,
    'isWrapped': isWrapped,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BirthdayGift.fromJson(Map<String, dynamic> json) => BirthdayGift(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    name: json['name'] as String,
    description: json['description'] as String? ?? '',
    estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble() ?? 0,
    purchaseLink: json['purchaseLink'] as String? ?? '',
    assignedTo: json['assignedTo'] as String? ?? '',
    isPurchased: json['isPurchased'] as bool? ?? false,
    isWrapped: json['isWrapped'] as bool? ?? false,
    notes: json['notes'] as String? ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );

  String encode() => jsonEncode(toJson());
  static BirthdayGift decode(String source) => BirthdayGift.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
