import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/common/utils/enum_helper.dart';
import 'package:service_la/services/api_constants/api_const.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';
import 'package:service_la/services/websocket/websocket_service.dart';

class HelperFunction {
  static String placeholderImageUrl42 = "https://placehold.co/42x42.png";
  static String placeholderImageUrl48 = "https://placehold.co/48x48.png";
  static String placeholderImageUrl17 = "https://placehold.co/17x17.png";
  static String placeholderImageUrl30 = "https://placehold.co/30x30.png";
  static String placeholderImageUrl35 = "https://placehold.co/35x35.png";
  static String placeholderImageUrl70 = "https://placehold.co/70x70.png";
  static String placeholderImageUrl178_84 = "https://placehold.co/178x84.png";
  static String placeholderImageUrl412_320 = "https://placehold.co/412x320.png";
  static String imageUrl1 = "https://i.imgur.com/mqtYQc6.png";
  static String imageUrl2 = "https://i.imgur.com/uCa4vK8.png";
  static String userImage1 = "https://i.pravatar.cc/150?img=2";
  static String userImage2 = "https://i.pravatar.cc/150?img=4";
  static String userImage3 = "https://i.pravatar.cc/150?img=60";

  static void changeStatusBarColor() => SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppColors.primary,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
        ),
      );

  static Future<void> hideKeyboard() async {
    await Future.delayed(const Duration(milliseconds: 100));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((Get.context?.mounted ?? false)) FocusScope.of(Get.context!).unfocus();
    });
  }

  static void snackbar(
    String message, {
    String? title,
    Color? textColor,
    Color? backgroundColor,
    IconData? icon,
    Color? iconColor,
  }) {
    final ctx = Get.context;
    if (ctx == null || !ctx.mounted) return;
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon ?? Icons.error, color: iconColor ?? AppColors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "${title ?? "Error"}: $message",
              style: TextStyle(color: textColor ?? AppColors.white),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor ?? AppColors.red,
      duration: const Duration(milliseconds: 1000),
      action: SnackBarAction(
        label: "OK",
        textColor: AppColors.white,
        onPressed: () => ScaffoldMessenger.of(ctx).hideCurrentSnackBar(),
      ),
      persist: false,
    );
    ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }

  static Future<XFile> getImageXFile(XFile picked) async {
    File imageFile = File(picked.path);
    int originalSize = await imageFile.length();
    log("📸 Original image path: ${imageFile.path}");
    log("📦 Original image size: ${originalSize / (1024 * 1024)} MB");

    // If image is larger than 2 MB
    if (originalSize > 2 * 1024 * 1024) {
      log("⚠️ Image exceeds 2 MB, starting compression...");

      final compressed = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: 1080,
        minHeight: 1080,
        quality: 70,
      );

      if (compressed != null) {
        final compressedFile = await _writeToTempFile(compressed);
        int compressedSize = await compressedFile.length();
        log("✅ Compression complete.");
        log("📦 Compressed image path: ${compressedFile.path}");
        log("📦 Compressed image size: ${compressedSize / (1024 * 1024)} MB");

        return XFile(compressedFile.path);
      } else {
        log("❌ Compression failed. Using original image.");
      }
    } else {
      log("✅ Image is under 2 MB. No compression needed.");
    }
    return picked;
  }

  static Future<File> _writeToTempFile(Uint8List bytes) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    return await tempFile.writeAsBytes(bytes);
  }

  static Future<WebSocketService?> initWebSockets(String accessToken) async {
    try {
      final ws = WebSocketService(
        baseUrl: ApiConstant.websocketBaseUrl,
        reconnectInterval: const Duration(seconds: 10),
        autoReconnect: true,
        queryParamsBuilder: () => {
          ApiParams.token: accessToken,
          ApiParams.clientPlatform: ClientPlatform.app.name,
        },
      );
      final initializedWs = await Get.putAsync(() => ws.init());
      await ws.connect();
      return initializedWs;
    } catch (e) {
      log('[WebSocket] init failed: $e');
      return null;
    }
  }

  static Future<void> logOut() async {
    StorageHelper.removeAllLocalData();
    await Get.find<WebSocketService>().disconnect();
    Get.delete<WebSocketService>();
    _goToSignInScreen();
  }

  static void _goToSignInScreen() => Get.offAllNamed(AppRoutes.signInScreen);

  static int? getWebsocketNotificationType(Map<String, dynamic> response) {
    try {
      final dataString = response["notification"]?["data"];
      if (dataString == null) return null;
      final dataJson = jsonDecode(dataString);
      return dataJson["Type"] as int?;
    } catch (e) {
      log("Error parsing notification type: $e");
      return null;
    }
  }

  static List<Color> getCategoriesColors(String randomValue) {
    final hash = randomValue.hashCode;
    final index = hash % CategoryColors.values.length;
    return CategoryColors.values[index].colors;
  }

  static String getServiceIconPath(String randomValue) {
    final hash = randomValue.hashCode;
    final index = hash % ServiceIcon.values.length;
    return ServiceIcon.values[index].path;
  }
}
