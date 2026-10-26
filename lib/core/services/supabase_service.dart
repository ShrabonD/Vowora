import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/vowora_constants.dart';

class SupabaseService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static SupabaseClient get client {
    if (!_isInitialized) {
      throw Exception(
          'Supabase is not initialized. Please configure credentials in vowora_constants.dart.');
    }
    return Supabase.instance.client;
  }

  static Future<void> initialize() async {
    try {
      if (VoworaConstants.supabaseUrl.contains('YOUR_SUPABASE') ||
          VoworaConstants.supabaseAnonKey.contains('YOUR_SUPABASE')) {
        if (kDebugMode) {
          print('Supabase credentials are placeholder values. Operating in local/demo mode.');
        }
        _isInitialized = false;
        return;
      }

      await Supabase.initialize(
        url: VoworaConstants.supabaseUrl,
        publishableKey: VoworaConstants.supabaseAnonKey,
      );
      _isInitialized = true;

      if (kDebugMode) {
        print('✅ Supabase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing Supabase: $e');
      }
      _isInitialized = false;
    }
  }

  // ===== Auth Getters =====
  static User? get currentUser {
    if (!_isInitialized) return null;
    return client.auth.currentUser;
  }

  static Session? get currentSession {
    if (!_isInitialized) return null;
    return client.auth.currentSession;
  }

  // ===== Email/Password Auth =====
  static Future<AuthResponse?> signInWithEmail(
      String email, String password) async {
    if (!_isInitialized) return null;
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
          'Unable to sign in. Please check your network connection.');
    }
  }

  static Future<AuthResponse?> signUpWithEmail({
    required String email,
    required String password,
    required Map<String, dynamic> data,
  }) async {
    if (!_isInitialized) return null;
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
          'Unable to create account. Please check your network connection.');
    }
  }

  // ===== OAuth (Google / Facebook) =====
  static Future<void> signInWithOAuth(OAuthProvider provider) async {
    if (!_isInitialized) {
      final providerName =
          provider.name.toUpperCase()[0] + provider.name.substring(1);
      throw OAuthNotConfiguredException(
        '$providerName sign-in is not configured yet. Please use email and password.',
      );
    }

    try {
      await client.auth.signInWithOAuth(
        provider,
        redirectTo: VoworaConstants.redirectUrl,
        authScreenLaunchMode: LaunchMode.inAppBrowserView,
      );
    } on AuthException catch (e) {
      final providerName =
          provider.name.toUpperCase()[0] + provider.name.substring(1);
      throw OAuthNotConfiguredException(
        '$providerName sign-in error: ${e.message}. Please use email and password.',
      );
    } catch (e) {
      final providerName =
          provider.name.toUpperCase()[0] + provider.name.substring(1);
      throw OAuthNotConfiguredException(
        '$providerName sign-in is not configured yet. Please use email and password.',
      );
    }
  }

  // ===== Password Reset =====
  static Future<void> resetPassword(String email) async {
    if (!_isInitialized) return;
    try {
      await client.auth.resetPasswordForEmail(
        email,
        redirectTo: VoworaConstants.redirectUrl,
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
          'Unable to send password reset email. Please try again.');
    }
  }

  // ===== Sign Out =====
  static Future<void> signOut() async {
    if (!_isInitialized) return;
    try {
      await client.auth.signOut();
    } catch (_) {}
  }

  // ===== Avatar Upload =====
  /// ইউজারের avatar আপলোড করে public URL ফেরত দেয়
  static Future<String?> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    if (!_isInitialized) {
      throw Exception('Supabase is not initialized.');
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$userId/avatar_$timestamp.jpg';

      final bytes = await File(filePath).readAsBytes();

      await client.storage.from('avatars').uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);

      await client
          .from('users')
          .update({'avatar_url': publicUrl}).eq('id', userId);

      return publicUrl;
    } on StorageException catch (e) {
      throw Exception('Avatar upload failed: ${e.message}');
    } catch (e) {
      throw Exception('Avatar upload failed. Please try again.');
    }
  }

  // ===== Fetch user from database =====
  /// Supabase-এর users টেবিল থেকে সম্পূর্ণ প্রোফাইল আনে
  static Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    if (!_isInitialized) return null;
    try {
      final response = await client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } on PostgrestException catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching profile: ${e.message}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching profile: $e');
      }
      return null;
    }
  }
}

class OAuthNotConfiguredException implements Exception {
  final String message;
  OAuthNotConfiguredException(this.message);

  @override
  String toString() => message;
}