import 'package:shared_preferences/shared_preferences.dart';




class StorageService {
  static const String keyRememberMe = 'vowora_remember_me';
  static const String keySavedEmail = 'vowora_saved_email';
  static const String keyOnboardingDone = 'vowora_onboarding_done';
  static const String keyIsGuest = 'vowora_is_guest';

  static Future<void> setRememberMe(bool remember, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyRememberMe, remember);
    if (remember) {
      await prefs.setString(keySavedEmail, email);
    } else {
      await prefs.remove(keySavedEmail);
    }
  }

  static Future<bool> getRememberMeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyRememberMe) ?? false;
  }

  static Future<String?> getSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keySavedEmail);
  }

  static Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyOnboardingDone, completed);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyOnboardingDone) ?? false;
  }

  static Future<void> setGuestMode(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsGuest, isGuest);
  }

  static Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsGuest) ?? false;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(keyIsGuest);
    await prefs.remove(keyRememberMe);
    await prefs.remove(keySavedEmail);
  }
}
