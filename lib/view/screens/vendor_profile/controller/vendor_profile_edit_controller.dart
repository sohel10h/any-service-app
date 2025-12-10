import 'dart:io';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/data/repository/admin_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/network/admin_user_model.dart';

class VendorProfileEditController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var user = AppDIController.adminUser.value.obs;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final nameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final picker = ImagePicker();
  RxBool isLoadingUpdateAdminUser = false.obs;
  final AdminRepo _adminRepo = AdminRepo();
  static Rx<AdminUser> adminUser = AdminUser().obs;

  @override
  void onInit() {
    _addListenerFocusNodes();
    _loadInitialData();
    super.onInit();
  }

  void onTapSaveChanges() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    await _updateAdminUser();
  }

  Future<void> _updateAdminUser() async {
    HelperFunction.hideKeyboard();
    isLoadingUpdateAdminUser.value = true;
    try {
      final formData = await buildProfileFormData(
        name: nameController.text,
        mobile: phoneController.text,
        imagePath: selectedImage.value?.path,
      );
      var response = await _adminRepo.putAdminUser(AppDIController.loginUserId, formData);
      if (response is String) {
        log("AdminUser put failed from controller response: $response");
      } else {
        AdminUserModel adminUserModel = response as AdminUserModel;
        if (adminUserModel.status == 200 || adminUserModel.status == 201) {
          log("AdminUser put successful from controller response: ${adminUserModel.toJson()}");
          adminUser.value = adminUserModel.adminUser ?? AdminUser();
          AppDIController.updateAdminUser(adminUser.value);
          Get.back();
          HelperFunction.snackbar(
            "User details updated successfully",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          if (adminUserModel.status == 401 ||
              (adminUserModel.errors != null &&
                  adminUserModel.errors.any((error) =>
                      error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
            log("Token expired detected, refreshing...");
            final retryResponse = await ApiService().postRefreshTokenAndRetry(
              () => _adminRepo.putAdminUser(AppDIController.loginUserId, formData),
            );
            if (retryResponse is AdminUserModel && (retryResponse.status == 200 || retryResponse.status == 201)) {
              adminUser.value = retryResponse.adminUser ?? AdminUser();
            } else {
              log("Retry request failed after token refresh");
            }
            return;
          }
          log("AdminUser put failed from controller: ${adminUserModel.status}");
          return;
        }
      }
    } catch (e) {
      log("AdminUser put catch error from controller: ${e.toString()}");
    } finally {
      isLoadingUpdateAdminUser.value = false;
    }
  }

  Future<dio.FormData> buildProfileFormData({required String name, required String mobile, String? imagePath}) async {
    final Map<String, dynamic> data = {
      ApiParams.name: name.trim(),
      ApiParams.mobile: mobile.trim(),
    };
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (await file.exists()) {
        final fileName = file.path.split('/').last;
        final extension = fileName.split('.').last.toLowerCase();
        data[ApiParams.file] = await dio.MultipartFile.fromFile(
          file.path,
          contentType: MediaType("image", "image/$extension"),
          filename: fileName,
        );
      } else {
        log("File does not exist: $imagePath");
      }
    }
    return dio.FormData.fromMap(data);
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 65);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  void _loadInitialData() {
    nameController.text = user.value.name ?? "";
    phoneController.text = user.value.mobile ?? "";
  }

  void _addListenerFocusNodes() {
    nameFocusNode.addListener(update);
    phoneController.addListener(update);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    super.onClose();
  }
}
