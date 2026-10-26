import 'dart:convert';

class BirthdayMemory {
  final String id;
  final String eventId;
  String imagePath; // local file path
  String caption;
  String type; // photo, note, highlight
  String content; // for notes/messages
  DateTime createdAt;

  BirthdayMemory({
    required this.id,
    required this.eventId,
    this.imagePath = '',
    this.caption = '',
    this.type = 'photo',
    this.content = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventId': eventId,
    'imagePath': imagePath,
    'caption': caption,
    'type': type,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BirthdayMemory.fromJson(Map<String, dynamic> json) => BirthdayMemory(
    id: json['id'] as String,
    eventId: json['eventId'] as String,
    imagePath: json['imagePath'] as String? ?? '',
    caption: json['caption'] as String? ?? '',
    type: json['type'] as String? ?? 'photo',
    content: json['content'] as String? ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
  );

  String encode() => jsonEncode(toJson());
  static BirthdayMemory decode(String source) => BirthdayMemory.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
