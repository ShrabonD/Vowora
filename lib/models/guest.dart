class Guest {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String side; // 'Bride', 'Groom', 'Both'
  final String rsvp; // 'Pending', 'Attending', 'Not Attending'
  final String mealPreference; // 'Regular', 'Vegetarian', 'Other'
  final String? tableId;

  Guest({
    required this.id,
    required this.name,
    this.phone = '',
    this.email = '',
    required this.side,
    required this.rsvp,
    this.mealPreference = 'Regular',
    this.tableId,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      side: json['side'] ?? 'Bride',
      rsvp: json['rsvp'] ?? 'Pending',
      mealPreference: json['meal_preference'] ?? json['mealPreference'] ?? 'Regular',
      tableId: json['table_id'] ?? json['tableId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'side': side,
      'rsvp': rsvp,
      'meal_preference': mealPreference,
      'table_id': tableId,
    };
  }

  Guest copyWith({
    String? name,
    String? phone,
    String? email,
    String? side,
    String? rsvp,
    String? mealPreference,
    String? tableId,
  }) {
    return Guest(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      side: side ?? this.side,
      rsvp: rsvp ?? this.rsvp,
      mealPreference: mealPreference ?? this.mealPreference,
      tableId: tableId ?? this.tableId,
    );
  }
}
