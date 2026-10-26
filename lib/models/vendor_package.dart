class PackageItem {
  final String id;
  final String name;
  final String description;
  final double defaultPrice;
  final bool isDefaultIncluded;
  bool isSelected;
  int quantity;

  PackageItem({
    required this.id,
    required this.name,
    required this.description,
    required this.defaultPrice,
    this.isDefaultIncluded = true,
    this.isSelected = true,
    this.quantity = 1,
  });

  PackageItem copyWith({
    bool? isSelected,
    int? quantity,
  }) {
    return PackageItem(
      id: id,
      name: name,
      description: description,
      defaultPrice: defaultPrice,
      isDefaultIncluded: isDefaultIncluded,
      isSelected: isSelected ?? this.isSelected,
      quantity: quantity ?? this.quantity,
    );
  }
}

enum PackageTier { basic, moderate, premium }

class VendorPackage {
  final String id;
  final String name;
  final PackageTier tier;
  final double basePrice;
  final String description;
  final List<PackageItem> items;

  VendorPackage({
    required this.id,
    required this.name,
    required this.tier,
    required this.basePrice,
    required this.description,
    required this.items,
  });

  double calculateTotalPrice() {
    double total = basePrice;
    for (var item in items) {
      if (!item.isDefaultIncluded && item.isSelected) {
        total += (item.defaultPrice * item.quantity);
      } else if (item.isDefaultIncluded && !item.isSelected) {
        // Deduction if user unchecks default item
        total -= (item.defaultPrice * item.quantity);
      }
    }
    return total < 0 ? 0 : total;
  }
}

class NearbyVendor {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewsCount;
  final double distanceKm;
  final String address;
  final String imageUrl;
  final double startingPrice;
  final List<VendorPackage> packages;

  NearbyVendor({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.distanceKm,
    required this.address,
    required this.imageUrl,
    required this.startingPrice,
    required this.packages,
  });
}
