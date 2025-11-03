import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static const String authToken = "authToken";
  static const String refreshToken = "refreshToken";

  static String getValue(String keyWord) {
    final box = GetStorage();
    return box.read(keyWord) ?? "";
  }

  static Future<dynamic> setValue(String keyWord, String value) {
    final box = GetStorage();
    return box.write(keyWord, value);
  }

  static Future<dynamic> removeValue(String keyWord) {
    final box = GetStorage();
    return box.remove(keyWord);
  }

  /// pass object to json
  static Future<dynamic> setObject(String keyWord, dynamic object) {
    return GetStorage().write(keyWord, json.encode(object));
  }

  ///  static ClassListModelResponse classListModelResponse = ClassListModelResponse.fromJson(Pref.getObject(KeyWord.CLASS_RESPONSE_MODEL));
  static dynamic getObject(String keyWord) {
    try {
      return json.decode(GetStorage().read(keyWord));
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> removeAllLocalData() {
    final box = GetStorage();
    return box.erase();
  }
}
