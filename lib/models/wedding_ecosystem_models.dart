import 'wedding_booking_model.dart';

enum UserRole { client, guest, serviceProvider, admin }

enum ServiceProviderType {
  photographer,
  videographer,
  decorator,
  caterer,
  venueProvider,
  entertainment,
}

enum BookingRequestStatus { pending, accepted, rejected, completed }

enum PhotoVisibility { publicToGuests, clientOnly, private }

enum PhotoApprovalStatus { pendingApproval, approved, rejected }

// --- 1. Service Provider Profile Model ---
class ServiceProviderModel {
  final String id;
  final String name;
  final ServiceProviderType type;
  final String location;
  final double rating;
  final int reviewsCount;
  final double startingPrice;
  final int portfolioCount;
  final bool isAvailable;
  final String profileImageUrl;
  final String bio;
  final List<String> portfolioImages;
  final List<WeddingPackageModel> packages;

  ServiceProviderModel({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    required this.startingPrice,
    required this.portfolioCount,
    this.isAvailable = true,
    required this.profileImageUrl,
    required this.bio,
    required this.portfolioImages,
    required this.packages,
  });
}

// --- 2. Service Booking Request Model ---
class ServiceBookingRequestModel {
  final String id;
  final String providerId;
  final String providerName;
  final ServiceProviderType providerType;
  final String clientId;
  final String clientName;
  final String weddingId;
  final String weddingName;
  final DateTime weddingDate;
  final String venueName;
  final String packageName;
  final double totalPrice;
  final double advancePaid;
  BookingRequestStatus status;
  String paymentStatus; // Pending, Partially Paid, Paid

  ServiceBookingRequestModel({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerType,
    required this.clientId,
    required this.clientName,
    required this.weddingId,
    required this.weddingName,
    required this.weddingDate,
    required this.venueName,
    required this.packageName,
    required this.totalPrice,
    this.advancePaid = 0.0,
    this.status = BookingRequestStatus.pending,
    this.paymentStatus = 'Pending',
  });
}

// --- 3. Wedding Gallery Photo Model ---
class WeddingGalleryPhotoModel {
  final String id;
  final String weddingId;
  final String albumName; // Pre-Wedding, Ceremony, Couple, Family, Guests, Reception, Candid
  final String imageUrl;
  final String uploaderId;
  final String uploaderName;
  final UserRole uploaderRole; // client, serviceProvider, guest
  final DateTime uploadTime;
  PhotoVisibility visibility;
  PhotoApprovalStatus approvalStatus;

  WeddingGalleryPhotoModel({
    required this.id,
    required this.weddingId,
    required this.albumName,
    required this.imageUrl,
    required this.uploaderId,
    required this.uploaderName,
    required this.uploaderRole,
    required this.uploadTime,
    this.visibility = PhotoVisibility.publicToGuests,
    this.approvalStatus = PhotoApprovalStatus.approved,
  });
}

// --- 4. Wedding Schedule Event Model ---
class WeddingScheduleItemModel {
  final String id;
  final String weddingId;
  String timeString; // e.g. "05:00 PM"
  String title; // e.g. "Guest Arrival & Welcome Drink"
  String description;
  String location;

  WeddingScheduleItemModel({
    required this.id,
    required this.weddingId,
    required this.timeString,
    required this.title,
    required this.description,
    required this.location,
  });
}
