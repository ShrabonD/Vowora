class ConferenceHall {
  final String id;
  final String name;
  final String location;
  final String slogan;
  final String thumbnailAsset;
  final List<String> galleryAssets;
  final String contactPerson;
  final String phone;
  final String whatsapp;
  final String email;
  final String? facebook;
  final String? instagram;
  final String? website;
  final int capacity;
  final bool hasParking;
  final int acCount;
  final int fanCount;
  final bool hasWifi;
  final bool foodIncluded;
  final bool outsideFoodAllowed;
  final bool decorationIncluded;
  final bool outsideDecorationAllowed;
  final bool soundSystemIncluded;
  final bool outsideSoundAllowed;
  final int basePrice;
  final Map<String, int> pricingDetails;

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

const List<ConferenceHall> mockHalls = [
  // 1. Aman Ullah Convention Center (has images ✅)
  ConferenceHall(
    id: 'h1',
    name: 'Aman Ullah Convention Center',
    location: 'Zindabazar, Sylhet',
    slogan: 'Very attractive & beautiful place for party or wedding ceremony.',
    thumbnailAsset: 'assets/conference/hall/amaulla/thumbnail.jpg',
    galleryAssets: [
      'assets/conference/hall/amaulla/thumbnail.jpg',
      'assets/conference/hall/amaulla/image_1.jpg',
      'assets/conference/hall/amaulla/image_2.jpg',
    ],
    contactPerson: 'Md. Aman Ullah',
    phone: '+8801711000001',
    whatsapp: '+8801711000001',
    email: 'info@amanullah.com',
    facebook: 'https://facebook.com/amanullah',
    instagram: 'https://instagram.com/amanullah',
    website: 'https://amanullah.com',
    capacity: 800,
    hasParking: true,
    acCount: 12,
    fanCount: 20,
    hasWifi: true,
    foodIncluded: true,
    outsideFoodAllowed: false,
    decorationIncluded: true,
    outsideDecorationAllowed: true,
    soundSystemIncluded: true,
    outsideSoundAllowed: false,
    basePrice: 120000,
    pricingDetails: {
      'AC Hall (8 hrs)': 120000,
      'Decoration Package': 35000,
      'Catering (per plate)': 850,
      'Sound & Light': 15000,
    },
  ),

  // 2. Khan's Palace Convention Hall (has images ✅)
  ConferenceHall(
    id: 'h2',
    name: "Khan's Palace Convention Hall",
    location: 'Ambarkhana, Sylhet',
    slogan: 'Royal ambiance for your unforgettable moments.',
    thumbnailAsset: 'assets/conference/hall/khanpalace/thumbnail.jpg',
    galleryAssets: [
      'assets/conference/hall/khanpalace/thumbnail.jpg',
      'assets/conference/hall/khanpalace/image_1.jpg',
      'assets/conference/hall/khanpalace/image_2.jpg',
    ],
    contactPerson: 'Khan Mohammad',
    phone: '+8801711000002',
    whatsapp: '+8801711000002',
    email: 'info@khanpalace.com',
    capacity: 1200,
    hasParking: true,
    acCount: 18,
    fanCount: 25,
    hasWifi: true,
    foodIncluded: false,
    outsideFoodAllowed: true,
    decorationIncluded: false,
    outsideDecorationAllowed: true,
    soundSystemIncluded: true,
    outsideSoundAllowed: true,
    basePrice: 200000,
    pricingDetails: {
      'AC Hall (10 hrs)': 200000,
      'Decoration (optional)': 50000,
      'Catering (per plate)': 1100,
      'Sound & Light': 20000,
    },
  ),

  // 3. Hill View Convention Centre (has images ✅)
  ConferenceHall(
    id: 'h3',
    name: 'Hill View Convention Centre',
    location: 'Shahi Eidgah, Sylhet',
    slogan: 'Scenic hills, serene views, perfect celebrations.',
    thumbnailAsset: 'assets/conference/hall/hillview/thumbnail.jpg',
    galleryAssets: [
      'assets/conference/hall/hillview/thumbnail.jpg',
      'assets/conference/hall/hillview/image_1.jpg',
      'assets/conference/hall/hillview/image_2.jpg',
      'assets/conference/hall/hillview/image_3.png',
    ],
    contactPerson: 'Sabbir Hossain',
    phone: '+8801711000003',
    whatsapp: '+8801711000003',
    email: 'hello@hillview.com',
    capacity: 500,
    hasParking: true,
    acCount: 8,
    fanCount: 15,
    hasWifi: true,
    foodIncluded: true,
    outsideFoodAllowed: false,
    decorationIncluded: true,
    outsideDecorationAllowed: false,
    soundSystemIncluded: true,
    outsideSoundAllowed: false,
    basePrice: 90000,
    pricingDetails: {
      'AC Hall (6 hrs)': 90000,
      'Decoration Package': 25000,
      'Catering (per plate)': 700,
    },
  ),

  // 4. Tushan's Dining & Banquet
  ConferenceHall(
    id: 'h4',
    name: "Tushan's Dining & Banquet",
    location: 'Subid Bazar, Sylhet',
    slogan: 'Elegant dining, royal banquet experience.',
    thumbnailAsset: 'assets/conference/hall/amaulla/thumbnail.jpg',
    galleryAssets: [
      'assets/conference/hall/amaulla/thumbnail.jpg',
      'assets/conference/hall/amaulla/image_1.jpg',
    ],
    contactPerson: 'Tushan Ahmed',
    phone: '+8801711000004',
    whatsapp: '+8801711000004',
    email: 'info@tushans.com',
    capacity: 350,
    hasParking: true,
    acCount: 6,
    fanCount: 10,
    hasWifi: true,
    foodIncluded: true,
    outsideFoodAllowed: false,
    decorationIncluded: true,
    outsideDecorationAllowed: true,
    soundSystemIncluded: true,
    outsideSoundAllowed: true,
    basePrice: 80000,
    pricingDetails: {
      'AC Hall (5 hrs)': 80000,
      'Catering (per plate)': 950,
    },
  ),

  // 5. Sundorbon Community Centre
  ConferenceHall(
    id: 'h5',
    name: 'Sundorbon Community Centre',
    location: 'Uposhohor, Sylhet',
    slogan: 'Community vibes with modern amenities.',
    thumbnailAsset: 'assets/conference/hall/hillview/thumbnail.jpg',
    galleryAssets: [
      'assets/conference/hall/hillview/thumbnail.jpg',
      'assets/conference/hall/hillview/image_1.jpg',
      'assets/conference/hall/hillview/image_2.jpg',
    ],
    contactPerson: 'Rafiq Islam',
    phone: '+8801711000005',
    whatsapp: '+8801711000005',
    email: 'contact@sundorbon.com',
    capacity: 400,
    hasParking: true,
    acCount: 5,
    fanCount: 12,
    hasWifi: false,
    foodIncluded: false,
    outsideFoodAllowed: true,
    decorationIncluded: false,
    outsideDecorationAllowed: true,
    soundSystemIncluded: false,
    outsideSoundAllowed: true,
    basePrice: 60000,
    pricingDetails: {
      'Hall (6 hrs)': 60000,
      'Catering (per plate)': 600,
    },
  ),

  // 6. The Agra Community Centre
  ConferenceHall(
    id: 'h6',
    name: 'The Agra Community Centre',
    location: 'Tilagarh, Sylhet',
    slogan: 'Affordable luxury for every occasion.',
    thumbnailAsset: 'assets/conference/hall/khanpalace/thumbnail.jpg',
    galleryAssets: [
      'assets/conference/hall/khanpalace/thumbnail.jpg',
      'assets/conference/hall/khanpalace/image_1.jpg',
    ],
    contactPerson: 'Agra Mia',
    phone: '+8801711000006',
    whatsapp: '+8801711000006',
    email: 'info@agracc.com',
    capacity: 600,
    hasParking: true,
    acCount: 10,
    fanCount: 18,
    hasWifi: true,
    foodIncluded: true,
    outsideFoodAllowed: false,
    decorationIncluded: true,
    outsideDecorationAllowed: false,
    soundSystemIncluded: true,
    outsideSoundAllowed: false,
    basePrice: 100000,
    pricingDetails: {
      'AC Hall (8 hrs)': 100000,
      'Decoration Package': 30000,
      'Catering (per plate)': 800,
    },
  ),

  // 7. S. R. Convention Hall
  ConferenceHall(
    id: 'h7',
    name: 'S. R. Convention Hall',
    location: 'Sylhet City Center, Sylhet',
    slogan: 'Your dream event starts here.',
    thumbnailAsset: 'assets/conference/hall/amaulla/thumbnail.jpg',
    galleryAssets: [
      'assets/conference/hall/amaulla/thumbnail.jpg',
      'assets/conference/hall/amaulla/image_2.jpg',
    ],
    contactPerson: 'S. R. Khan',
    phone: '+8801711000007',
    whatsapp: '+8801711000007',
    email: 'sr@convention.com',
    capacity: 700,
    hasParking: true,
    acCount: 14,
    fanCount: 20,
    hasWifi: true,
    foodIncluded: true,
    outsideFoodAllowed: true,
    decorationIncluded: true,
    outsideDecorationAllowed: true,
    soundSystemIncluded: true,
    outsideSoundAllowed: true,
    basePrice: 130000,
    pricingDetails: {
      'AC Hall (8 hrs)': 130000,
      'Catering (per plate)': 900,
      'Decoration (optional)': 40000,
    },
  ),
];
