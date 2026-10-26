import 'dart:convert';

class BirthdayTask {
  final String id;
  final String eventId;
  String title;
  bool isCompleted;
  DateTime? dueDate;
  String priority; // low, medium, high
  String notes;
  DateTime createdAt;

  BirthdayTask({
    required this.id,
    required this.eventId,
    required this.title,
    this.isCompleted = false,
    this.dueDate,
    this.priority = 'medium',
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'title': title,
    'isCompleted': isCompleted,
    'dueDate': dueDate?.toIso8601String(),
    'priority': priority,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BirthdayTask.fromJson(Map<String, dynamic> json) => BirthdayTask(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    title: json['title'] as String,
    isCompleted: json['isCompleted'] as bool? ?? false,
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : null,
    priority: json['priority'] as String? ?? 'medium',
    notes: json['notes'] as String? ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );

  String encode() => jsonEncode(toJson());
  static BirthdayTask decode(String source) => BirthdayTask.fromJson(jsonDecode(source) as Map<String, dynamic>);

  static List<BirthdayTask> defaultTasks(String eventId) => [
    BirthdayTask(id: 'dt_1_$eventId', eventId: eventId, title: 'Finalize theme', priority: 'high'),
    BirthdayTask(id: 'dt_2_$eventId', eventId: eventId, title: 'Book venue', priority: 'high'),
    BirthdayTask(id: 'dt_3_$eventId', eventId: eventId, title: 'Order cake', priority: 'high'),
    BirthdayTask(id: 'dt_4_$eventId', eventId: eventId, title: 'Confirm guest list', priority: 'medium'),
    BirthdayTask(id: 'dt_5_$eventId', eventId: eventId, title: 'Send invitations', priority: 'medium'),
    BirthdayTask(id: 'dt_6_$eventId', eventId: eventId, title: 'Arrange decorations', priority: 'medium'),
    BirthdayTask(id: 'dt_7_$eventId', eventId: eventId, title: 'Buy gifts', priority: 'medium'),
    BirthdayTask(id: 'dt_8_$eventId', eventId: eventId, title: 'Confirm catering', priority: 'medium'),
    BirthdayTask(id: 'dt_9_$eventId', eventId: eventId, title: 'Prepare playlist', priority: 'low'),
    BirthdayTask(id: 'dt_10_$eventId', eventId: eventId, title: 'Confirm photographer', priority: 'low'),
    BirthdayTask(id: 'dt_11_$eventId', eventId: eventId, title: 'Final venue check', priority: 'high'),
  ];
}
