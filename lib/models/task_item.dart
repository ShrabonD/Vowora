class TaskItem {
  final String id;
  final String title;
  final String category;
  final DateTime dueDate;
  final bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.dueDate,
    this.isCompleted = false,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'General',
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : DateTime.now().add(const Duration(days: 30)),
      isCompleted: json['is_completed'] ?? json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  TaskItem copyWith({
    String? title,
    String? category,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
