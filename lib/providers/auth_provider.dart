import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/storage_service.dart';
import '../core/services/supabase_service.dart';
import '../models/user_profile.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, guest }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;
  String? _savedEmail;
  StreamSubscription<AuthState>? _authSubscription;

  AuthStatus get status => _status;
  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  String? get savedEmail => _savedEmail;
  bool get isGuest => _status == AuthStatus.guest;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _init();
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    if (!SupabaseService.isInitialized) return;
    _authSubscription =
        SupabaseService.client.auth.onAuthStateChange.listen((data) {
          final session = data.session;
          final event = data.event;
          if (session != null) {
            _userProfile = _profileFromSupabaseUser(session.user);
            _status = AuthStatus.authenticated;
            notifyListeners();
            _refreshProfileInBackground();
          } else if (event == AuthChangeEvent.signedOut) {
            _userProfile = null;
            _status = AuthStatus.unauthenticated;
            notifyListeners();
          }
        });
  }

  UserProfile _profileFromSupabaseUser(User user) {
    final meta = user.userMetadata ?? {};
    final avatarUrl = (meta['avatar_url'] ?? meta['picture'] ?? meta['avatar']) as String?;
    final name = (meta['full_name'] as String?) ??
        (meta['name'] as String?) ??
        (user.email != null ? user.email!.split('@').first : 'Planner');
    final email = user.email ?? (meta['email'] as String?) ?? '';

    return UserProfile(
      id: user.id,
      fullName: name,
      email: email,
      phone: (meta['phone'] as String?) ?? '',
      location: (meta['location'] as String?) ?? '',
      avatarUrl: avatarUrl,
      role: (meta['role'] as String?) ?? 'normal_user',
    );
  }

  Future<void> _init() async {
    _rememberMe = await StorageService.getRememberMeStatus();
    _savedEmail = await StorageService.getSavedEmail();
    final isGuest = await StorageService.isGuestMode();

    if (isGuest) {
      _status = AuthStatus.guest;
      _userProfile = UserProfile(
        id: 'guest_user',
        fullName: 'Guest User',
        email: 'guest@vowora.app',
        phone: '+880 1700000000',
        location: 'Dhaka, Bangladesh',
      );
      notifyListeners();
      return;
    }

    if (SupabaseService.isInitialized && SupabaseService.currentUser != null) {
      _status = AuthStatus.authenticated;
      _userProfile = _profileFromSupabaseUser(SupabaseService.currentUser!);
      _refreshProfileInBackground();
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> _refreshProfileInBackground() async {
    if (_userProfile == null) return;
    if (!SupabaseService.isInitialized) return;
    try {
      final data = await SupabaseService.fetchUserProfile(_userProfile!.id);
      if (data != null) {
        _userProfile = UserProfile.fromJson(data);
        notifyListeners();
      }
    } catch (_) {}
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      if (SupabaseService.isInitialized) {
        try {
          final response = await SupabaseService.signInWithEmail(email, password);
          if (response?.user != null) {
            _userProfile = _profileFromSupabaseUser(response!.user!);
            _status = AuthStatus.authenticated;
            _refreshProfileInBackground();
          } else {
            throw Exception('Login failed. Please check your credentials.');
          }
        } catch (e) {
          final errStr = e.toString().toLowerCase();
          if (errStr.contains('socketexception') ||
              errStr.contains('failed host lookup') ||
              errStr.contains('clientexception') ||
              errStr.contains('network') ||
              errStr.contains('connection')) {
            // Fallback to local authenticated session on network lookup failure
            _userProfile = UserProfile(
              id: 'user_demo_${email.split('@').first}',
              fullName: email.split('@').first,
              email: email,
              phone: '+880 1700000000',
              location: 'Dhaka, Bangladesh',
            );
            _status = AuthStatus.authenticated;
          } else {
            rethrow;
          }
        }
      } else {
        // Offline / Local Mode Fallback
        _userProfile = UserProfile(
          id: 'user_demo_${email.split('@').first}',
          fullName: email.split('@').first,
          email: email,
          phone: '+880 1700000000',
          location: 'Dhaka, Bangladesh',
        );
        _status = AuthStatus.authenticated;
      }

      await StorageService.setRememberMe(rememberMe, email);
      await StorageService.setGuestMode(false);
      _rememberMe = rememberMe;
      _savedEmail = rememberMe ? email : null;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String location,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();
    try {
      final metadata = {
        'full_name': fullName,
        'phone': phone,
        'location': location,
      };

      if (SupabaseService.isInitialized) {
        try {
          final response = await SupabaseService.signUpWithEmail(
            email: email,
            password: password,
            data: metadata,
          );
          final user = response?.user;
          if (user != null) {
            _userProfile = _profileFromSupabaseUser(user);
            _status = AuthStatus.authenticated;
          } else {
            throw Exception('Signup failed. Please try again.');
          }
        } catch (e) {
          final errStr = e.toString().toLowerCase();
          if (errStr.contains('socketexception') ||
              errStr.contains('failed host lookup') ||
              errStr.contains('clientexception') ||
              errStr.contains('network') ||
              errStr.contains('connection')) {
            // Offline / Local Mode Fallback
            _userProfile = UserProfile(
              id: 'user_demo_${DateTime.now().millisecondsSinceEpoch}',
              fullName: fullName,
              email: email,
              phone: phone,
              location: location,
            );
            _status = AuthStatus.authenticated;
          } else {
            rethrow;
          }
        }
      } else {
        // Local Mode Fallback
        _userProfile = UserProfile(
          id: 'user_demo_${DateTime.now().millisecondsSinceEpoch}',
          fullName: fullName,
          email: email,
          phone: phone,
          location: location,
        );
        _status = AuthStatus.authenticated;
      }

      await StorageService.setGuestMode(false);
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<void> loginWithOAuth(OAuthProvider provider) async {
    _setLoading(true);
    _clearError();
    try {
      await SupabaseService.signInWithOAuth(provider);
      _setLoading(false);
    } catch (e) {
      _errorMessage = e
          .toString()
          .replaceAll('OAuthNotConfiguredException: ', '')
          .replaceAll('Exception: ', '');
      _setLoading(false);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> continueAsGuest() async {
    _status = AuthStatus.guest;
    _userProfile = UserProfile(
      id: 'guest_user',
      fullName: 'Guest User',
      email: 'guest@vowora.app',
      phone: '+880 1700000000',
      location: 'Dhaka, Bangladesh',
    );
    await StorageService.setGuestMode(true);
    notifyListeners();
  }

  Future<bool> sendPasswordReset(String email) async {
    _setLoading(true);
    _clearError();
    try {
      await SupabaseService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String location,
  }) async {
    if (_userProfile == null) return;
    _userProfile = _userProfile!.copyWith(
      fullName: fullName,
      phone: phone,
      location: location,
    );
    notifyListeners();
    if (SupabaseService.isInitialized) {
      try {
        await SupabaseService.client.from('users').update({
          'full_name': fullName,
          'phone': phone,
          'location': location,
        }).eq('id', _userProfile!.id);
      } catch (_) {}
    }
  }

  Future<bool> uploadAvatar(String filePath) async {
    if (_userProfile == null) return false;
    if (!SupabaseService.isInitialized) return false;
    _setLoading(true);
    _clearError();
    try {
      final url = await SupabaseService.uploadAvatar(
        userId: _userProfile!.id,
        filePath: filePath,
      );
      if (url != null) {
        _userProfile = _userProfile!.copyWith(avatarUrl: url);
        notifyListeners();
        _setLoading(false);
        return true;
      }
      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshProfile() async {
    await _refreshProfileInBackground();
  }

  Future<void> logout() async {
    _setLoading(true);
    await StorageService.setGuestMode(false);
    await StorageService.setRememberMe(false, '');
    await StorageService.clearSession();
    await SupabaseService.signOut();
    _status = AuthStatus.unauthenticated;
    _userProfile = null;
    _setLoading(false);
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}