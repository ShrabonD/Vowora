import 'dart:convert';

class BirthdayTimelineItem {
  final String id;
  final String eventId;
  String time; // e.g. "05:00 PM"
  String title;
  String description;
  bool isCompleted;
  int sortOrder;
  DateTime createdAt;

  BirthdayTimelineItem({
    required this.id,
    required this.eventId,
    required this.time,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    this.sortOrder = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'time': time,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
    'sortOrder': sortOrder,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BirthdayTimelineItem.fromJson(Map<String, dynamic> json) => BirthdayTimelineItem(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    time: json['time'] as String,
    title: json['title'] as String,
    description: json['description'] as String? ?? '',
    isCompleted: json['isCompleted'] as bool? ?? false,
    sortOrder: json['sortOrder'] as int? ?? 0,
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );

  String encode() => jsonEncode(toJson());
  static BirthdayTimelineItem decode(String source) => BirthdayTimelineItem.fromJson(jsonDecode(source) as Map<String, dynamic>);

  static List<BirthdayTimelineItem> defaultTimeline(String eventId) => [
    BirthdayTimelineItem(id: 'tl_1_$eventId', eventId: eventId, time: '05:00 PM', title: 'Venue Preparation', description: 'Set up decorations and arrangements', sortOrder: 0),
    BirthdayTimelineItem(id: 'tl_2_$eventId', eventId: eventId, time: '05:30 PM', title: 'Guest Arrival', description: 'Welcome guests at the entrance', sortOrder: 1),
    BirthdayTimelineItem(id: 'tl_3_$eventId', eventId: eventId, time: '06:00 PM', title: 'Welcome & Photography', description: 'Group photos and candid moments', sortOrder: 2),
    BirthdayTimelineItem(id: 'tl_4_$eventId', eventId: eventId, time: '06:30 PM', title: 'Games & Entertainment', description: 'Fun activities and games', sortOrder: 3),
    BirthdayTimelineItem(id: 'tl_5_$eventId', eventId: eventId, time: '07:00 PM', title: 'Cake Cutting', description: 'The birthday cake moment', sortOrder: 4),
    BirthdayTimelineItem(id: 'tl_6_$eventId', eventId: eventId, time: '07:30 PM', title: 'Dinner', description: 'Dinner and refreshments', sortOrder: 5),
    BirthdayTimelineItem(id: 'tl_7_$eventId', eventId: eventId, time: '08:15 PM', title: 'Gifts & Group Photos', description: 'Gift opening and group photos', sortOrder: 6),
    BirthdayTimelineItem(id: 'tl_8_$eventId', eventId: eventId, time: '09:00 PM', title: 'Celebration Ends', description: 'Thank guests and farewell', sortOrder: 7),
  ];
}
