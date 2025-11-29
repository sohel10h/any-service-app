import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static const String authToken = "authToken";
  static const String refreshToken = "refreshToken";
  static const String userId = "userId";
  static const String username = "username";
  static const String signInResponse = "signInResponse";
  static const String websocketVendorFoundResponse = "websocketVendorFoundResponse";
  static const String websocketVendorNotFoundResponse = "websocketVendorNotFoundResponse";
  static const String notificationPermissionAsked = "notificationPermissionAsked";
  static const String autoCompleteRecentResponse = "autoCompleteRecentResponse";
  static const String autoCompleteSuggestedResponse = "autoCompleteSuggestedResponse";
  static const String autoCompleteSavedResponse = "autoCompleteSavedResponse";

  static dynamic getValue(String key) {
    final box = GetStorage();
    return box.read(key);
  }

  static Future<dynamic> setValue(String key, dynamic value) {
    final box = GetStorage();
    return box.write(key, value);
  }

  static Future<dynamic> removeValue(String key) {
    final box = GetStorage();
    return box.remove(key);
  }

  static Future<dynamic> setObject(String key, dynamic object) {
    return GetStorage().write(key, json.encode(object));
  }

  static dynamic getObject(String key) {
    try {
      return json.decode(GetStorage().read(key));
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> removeAllLocalData() {
    final box = GetStorage();
    return box.erase();
  }
}
