class TimelineEvent {
  final String id;
  final String title;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String location;
  final String notes;

  TimelineEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.notes = '',
  });

  factory TimelineEvent.fromJson(Map<String, dynamic> json) {
    return TimelineEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      startTime: json['start_time'] ?? json['startTime'] ?? '10:00 AM',
      endTime: json['end_time'] ?? json['endTime'] ?? '02:00 PM',
      location: json['location'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'location': location,
      'notes': notes,
    };
  }

  TimelineEvent copyWith({
    String? title,
    DateTime? date,
    String? startTime,
    String? endTime,
    String? location,
    String? notes,
  }) {
    return TimelineEvent(
      id: id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }
}
