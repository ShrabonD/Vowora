class ConferenceHall {
  final String id;
  final String name;
  final String location;
  final String slogan;
  final String thumbnailAsset;
  final List<String> galleryAssets;

  // Contact
  final String contactPerson;
  final String phone;
  final String whatsapp;
  final String email;
  final String? facebook;
  final String? instagram;
  final String? website;

  // Capacity & facilities
  final int capacity;
  final bool hasParking;
  final int acCount;
  final int fanCount;
  final bool hasWifi;

  // Food
  final bool foodIncluded;
  final bool outsideFoodAllowed;

  // Decoration
  final bool decorationIncluded;
  final bool outsideDecorationAllowed;

  // Sound
  final bool soundSystemIncluded;
  final bool outsideSoundAllowed;

  // Pricing
  final int basePrice;              // overall
  final Map<String, int> pricingDetails; // e.g. {'ac_hall': 50000, 'decoration': 15000}

  const ConferenceHall({
    required this.id,
    required this.name,
    required this.location,
    required this.slogan,
    required this.thumbnailAsset,
    required this.galleryAssets,
    required this.contactPerson,
    required this.phone,
    required this.whatsapp,
    required this.email,
    this.facebook,
    this.instagram,
    this.website,
    required this.capacity,
    required this.hasParking,
    required this.acCount,
    required this.fanCount,
    required this.hasWifi,
    required this.foodIncluded,
    required this.outsideFoodAllowed,
    required this.decorationIncluded,
    required this.outsideDecorationAllowed,
    required this.soundSystemIncluded,
    required this.outsideSoundAllowed,
    required this.basePrice,
    required this.pricingDetails,
  });
}