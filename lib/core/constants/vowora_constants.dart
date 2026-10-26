class VoworaConstants {
  static const String appName = 'VOWORA';
  static const String appTagline = 'Plan beautifully.\nCelebrate endlessly.';
  static const String appTaglineSingleLine = 'Plan beautifully. Celebrate endlessly.';
  
  // Supabase Configuration
  // REPLACE THESE WITH YOUR ACTUAL SUPABASE CREDENTIALS IN PRODUCTION
  static const String supabaseUrl = 'https://cgjjxmtwdylhaiflrdxv.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnamp4bXR3ZHlsaGFpZmxyZHh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODk5MDkzNjgsImV4cCI6MjEwNTQ4NTM2OH0.EjaBEofF0RkABwJNxL4cJrU8b_yJW-3ZWZEqMAb3euU';





  // ===== OAuth & Deep Link Configuration =====
  // এই scheme টি AndroidManifest.xml এবং Supabase Dashboard এও দিতে হবে
  static const String redirectUrl = 'com.vowora.app://login-callback';

  // Google OAuth (Cloud Console থেকে পাবেন)
  static const String googleWebClientId = 'YOUR_GOOGLE_WEB_CLIENT_ID';
  static const String googleIosClientId = 'YOUR_GOOGLE_IOS_CLIENT_ID';

  // Facebook OAuth (Meta for Developers থেকে পাবেন)
  static const String facebookAppId = 'YOUR_FACEBOOK_APP_ID';
  static const String facebookClientToken = 'YOUR_FACEBOOK_CLIENT_TOKEN';



  // Support & Help Contact Information (Configurable Demo Contacts)
  static const String supportEmail = 'support@vowora.app';
  static const String supportPhone = '+880 1700000000';
  static const String supportOffice = 'Dhaka, Bangladesh';

  // Assets Paths
  static const String bgWeddingHero = 'assets/images/wedding_hero.jpg';
  static const String defaultProfileImage = 'assets/images/wedding_hero.jpg';

  // Currencies
  static const List<String> currencies = ['USD (\$)', 'EUR (€)', 'GBP (£)', 'BDT (৳)', 'INR (₹)', 'CAD (\$)'];

  // Wedding Styles
  static const List<String> weddingStyles = [
    'Classic',
    'Modern',
    'Minimal',
    'Royal',
    'Bohemian',
    'Garden',
    'Traditional',
    'Luxury',
  ];

  // Budget Categories
  static const List<String> budgetCategories = [
    'Venue',
    'Catering',
    'Decoration',
    'Photography',
    'Videography',
    'Outfits',
    'Makeup',
    'Transportation',
    'Music / DJ',
    'Invitation',
    'Jewelry',
    'Other',
  ];

  // Vendor Categories
  static const List<String> vendorCategories = [
    'Venue',
    'Catering',
    'Photography',
    'Decoration',
    'Makeup',
    'Music/DJ',
    'Transportation',
    'Florist',
    'Cake',
    'Invitation',
    'Other',
  ];

  // Vendor Statuses
  static const List<String> vendorStatuses = [
    'Shortlisted',
    'Contacted',
    'Booked',
    'Completed',
  ];

  // Inspiration Categories
  static const List<String> inspirationCategories = [
    'Decor',
    'Dress',
    'Flowers',
    'Cake',
    'Invitation',
    'Photography',
    'Venue',
    'Mehendi',
    'Reception',
  ];
}
