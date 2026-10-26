class Vendor {
  final String id;
  final String name;
  final String category;
  final String phone;
  final String email;
  final double price;
  final String status; // 'Shortlisted', 'Contacted', 'Booked', 'Completed'
  final String notes;

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    this.phone = '',
    this.email = '',
    this.price = 0.0,
    required this.status,
    this.notes = '',
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'Other',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Shortlisted',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'phone': phone,
      'email': email,
      'price': price,
      'status': status,
      'notes': notes,
    };
  }

  Vendor copyWith({
    String? name,
    String? category,
    String? phone,
    String? email,
    double? price,
    String? status,
    String? notes,
  }) {
    return Vendor(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      price: price ?? this.price,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
