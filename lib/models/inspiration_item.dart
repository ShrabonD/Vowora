class InspirationItem {
  final String id;
  final String title;
  final String category; // 'Decor', 'Dress', 'Flowers', 'Cake', 'Invitation', 'Photography', etc.
  final String imageUrl;
  final bool isFavorite;

  InspirationItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory InspirationItem.fromJson(Map<String, dynamic> json) {
    return InspirationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'Decor',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      isFavorite: json['is_favorite'] ?? json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'image_url': imageUrl,
      'is_favorite': isFavorite,
    };
  }

  InspirationItem copyWith({
    String? title,
    String? category,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return InspirationItem(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
