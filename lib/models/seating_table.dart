class SeatingTable {
  final String id;
  final String tableName;
  final int capacity;
  final List<String> guestIds;

  SeatingTable({
    required this.id,
    required this.tableName,
    required this.capacity,
    required this.guestIds,
  });

  int get assignedCount => guestIds.length;
  bool get isFull => assignedCount >= capacity;

  factory SeatingTable.fromJson(Map<String, dynamic> json) {
    return SeatingTable(
      id: json['id'] ?? '',
      tableName: json['table_name'] ?? json['tableName'] ?? '',
      capacity: (json['capacity'] as num?)?.toInt() ?? 8,
      guestIds: (json['guest_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'table_name': tableName,
      'capacity': capacity,
      'guest_ids': guestIds,
    };
  }

  SeatingTable copyWith({
    String? tableName,
    int? capacity,
    List<String>? guestIds,
  }) {
    return SeatingTable(
      id: id,
      tableName: tableName ?? this.tableName,
      capacity: capacity ?? this.capacity,
      guestIds: guestIds ?? this.guestIds,
    );
  }
}
