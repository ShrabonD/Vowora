class BudgetItem {
  final String id;
  final String category;
  final String title;
  final double amount;
  final double paidAmount;
  final String? notes;
  final DateTime date;

  BudgetItem({
    required this.id,
    required this.category,
    required this.title,
    required this.amount,
    this.paidAmount = 0.0,
    this.notes,
    required this.date,
  });

  double get remaining => amount - paidAmount;
  bool get isFullyPaid => paidAmount >= amount;

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      id: json['id'] ?? '',
      category: json['category'] ?? 'Other',
      title: json['title'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] ?? json['paidAmount'] ?? 0.0 as num).toDouble(),
      notes: json['notes'],
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'amount': amount,
      'paid_amount': paidAmount,
      'notes': notes,
      'date': date.toIso8601String(),
    };
  }

  BudgetItem copyWith({
    String? category,
    String? title,
    double? amount,
    double? paidAmount,
    String? notes,
    DateTime? date,
  }) {
    return BudgetItem(
      id: id,
      category: category ?? this.category,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      notes: notes ?? this.notes,
      date: date ?? this.date,
    );
  }
}
