import 'dart:convert';

class BirthdayExpense {
  final String id;
  final String eventId;
  String category;
  String description;
  String vendorName;
  double estimatedCost;
  double actualCost;
  String paymentStatus; // pending, partial, paid
  String notes;
  DateTime? transactionDate;
  DateTime createdAt;

  BirthdayExpense({
    required this.id,
    required this.eventId,
    required this.category,
    this.description = '',
    this.vendorName = '',
    this.estimatedCost = 0,
    this.actualCost = 0,
    this.paymentStatus = 'pending',
    this.notes = '',
    this.transactionDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'category': category,
    'description': description,
    'vendorName': vendorName,
    'estimatedCost': estimatedCost,
    'actualCost': actualCost,
    'paymentStatus': paymentStatus,
    'notes': notes,
    'transactionDate': transactionDate?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory BirthdayExpense.fromJson(Map<String, dynamic> json) => BirthdayExpense(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    category: json['category'] as String,
    description: json['description'] as String? ?? '',
    vendorName: json['vendorName'] as String? ?? '',
    estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0,
    actualCost: (json['actualCost'] as num?)?.toDouble() ?? 0,
    paymentStatus: json['paymentStatus'] as String? ?? 'pending',
    notes: json['notes'] as String? ?? '',
    transactionDate: json['transactionDate'] != null ? DateTime.parse(json['transactionDate'] as String) : null,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );

  String encode() => jsonEncode(toJson());
  static BirthdayExpense decode(String source) => BirthdayExpense.fromJson(jsonDecode(source) as Map<String, dynamic>);

  static const List<String> categories = [
    'Venue',
    'Cake',
    'Decoration',
    'Food & Catering',
    'Photography',
    'Gifts',
    'Entertainment',
    'Invitations',
    'Transport',
    'Miscellaneous',
  ];
}
