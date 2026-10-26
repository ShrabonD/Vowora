import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../core/services/supabase_service.dart';
import '../data/mock_halls_data.dart';

/*
PostgreSQL table (already created):

CREATE TABLE conference_booking (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(150) NOT NULL,
    hall_id VARCHAR(50),
    hall_name VARCHAR(150),
    category VARCHAR(50) NOT NULL DEFAULT 'hall',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    event_date DATE,
    base_price INT,
    total_price INT,
    pricing_details TEXT,
    status VARCHAR(30) DEFAULT 'pending',
    notes TEXT
);

Category values: 'hall' | 'photography' | 'restaurant' | 'decoration' |
'sound' | 'wedding' | 'gathering' | 'birthday'.

Bookings are written to and read from the conference_booking table in Supabase.
*/
class ConferenceBookingService {
  static Future<bool> bookHall({
    required String userName,
    required String userEmail,
    required ConferenceHall hall,
    DateTime? eventDate,
    String? notes,
  }) async {
    _ensureSupabaseReady();
    final email = userEmail.trim();
    if (email.isEmpty) {
      throw ArgumentError.value(userEmail, 'userEmail', 'Email is required.');
    }

    final payload = {
      'user_name': userName,
      'user_email': email,
      'hall_id': hall.id,
      'hall_name': hall.name,
      'category': 'hall',
      'event_date': _dateOnly(eventDate),
      'base_price': hall.basePrice,
      'total_price': hall.basePrice,
      'pricing_details': jsonEncode(hall.pricingDetails),
      'notes': notes,
      'status': 'pending',
    };

    await SupabaseService.client.from('conference_booking').insert(payload);
    debugPrint('Conference hall booking saved for ${hall.id}.');
    return true;
  }

  static Future<bool> bookService({
    required String userName,
    required String userEmail,
    required String category,
    required String serviceName,
    int? price,
    DateTime? eventDate,
  }) async {
    _ensureSupabaseReady();
    final email = userEmail.trim();
    if (email.isEmpty) {
      throw ArgumentError.value(userEmail, 'userEmail', 'Email is required.');
    }

    final payload = {
      'user_name': userName,
      'user_email': email,
      'hall_name': serviceName,
      'category': category,
      'event_date': _dateOnly(eventDate),
      'base_price': price,
      'total_price': price,
      'status': 'pending',
    };

    await SupabaseService.client.from('conference_booking').insert(payload);
    debugPrint('Conference service booking saved for $category.');
    return true;
  }

  static Future<List<Map<String, dynamic>>> getUserBookings(
    String userEmail,
  ) async {
    _ensureSupabaseReady();
    final email = userEmail.trim();
    if (email.isEmpty) return [];

    final response = await SupabaseService.client
        .from('conference_booking')
        .select()
        .eq('user_email', email)
        .order('booking_date', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static void _ensureSupabaseReady() {
    if (!SupabaseService.isInitialized) {
      throw StateError(
        'Supabase is not initialized. Check the app Supabase configuration.',
      );
    }
  }

  static String? _dateOnly(DateTime? date) {
    if (date == null) return null;
    final localDate = DateTime(date.year, date.month, date.day);
    return '${localDate.year.toString().padLeft(4, '0')}-'
        '${localDate.month.toString().padLeft(2, '0')}-'
        '${localDate.day.toString().padLeft(2, '0')}';
  }
}
