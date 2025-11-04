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
import 'package:service_la/services/api_service/api_service.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/network/create_service_model.dart';
import 'package:service_la/data/model/network/upload_admin_picture_model.dart';

class CreateServiceController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController priceFromController = TextEditingController();
  final TextEditingController priceToController = TextEditingController();
  final FocusNode serviceNameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode priceFromFocusNode = FocusNode();
  final FocusNode priceToFocusNode = FocusNode();
  final RxBool isPriceRange = false.obs;
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final RxList<bool> imageLoadingFlags = <bool>[].obs;
  final ImagePicker _picker = ImagePicker();
  final AdminRepo _adminRepo = AdminRepo();
  RxList<Map<String, dynamic>> attachmentIds = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingCrateService = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

  void onTapCreateServiceButton() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    await _adminServices();
  }

  Future<void> _adminServices() async {
    HelperFunction.hideKeyboard();
    isLoadingCrateService.value = true;
    try {
      Map<String, dynamic> params = {
        ApiParams.name: serviceNameController.text.trim(),
        ApiParams.description: descriptionController.text.trim(),
        ApiParams.priceRange: isPriceRange.value,
        ApiParams.pictures: attachmentIds,
      };
      if (isPriceRange.value) {
        params[ApiParams.priceStart] = double.tryParse(priceFromController.text.trim());
        params[ApiParams.priceEnd] = double.tryParse(priceToController.text.trim());
      } else {
        params[ApiParams.price] = double.tryParse(priceController.text.trim());
      }
      log("CreateService POST Params: $params");
      var response = await _adminRepo.adminServices(params);

      if (response is String) {
        log("CreateService failed from controller response: $response");
      } else {
        CreateServiceModel createService = response as CreateServiceModel;
        if (createService.status == 200 || createService.status == 201) {
          Get.back(result: true);
          HelperFunction.snackbar(
            "Service created successfully!",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
        } else {
          HelperFunction.snackbar("CreateService failed");
          log("CreateService failed from controller: ${createService.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("CreateService failed");
      log("CreateService catch error from controller: ${e.toString()}");
    } finally {
      isLoadingCrateService.value = false;
    }
  }

  Future<void> pickImages() async {
    final List<XFile> pickedImages = await _picker.pickMultiImage(limit: 4);
    if (pickedImages.isEmpty) {
      log("No image selected.");
      return;
    }
    if (pickedImages.length > 4) {
      HelperFunction.snackbar(
        "You can only add up to 4 images at a time",
        title: "Limit Reached",
        icon: Icons.warning,
        backgroundColor: AppColors.yellow,
      );
      return;
    }

    for (XFile image in pickedImages) {
      try {
        final imageFile = await HelperFunction.getImageXFile(image);
        selectedImages.add(imageFile);
        final index = selectedImages.length - 1;
        imageLoadingFlags.insert(index, true);
        imageLoadingFlags.refresh();
        final success = await _uploadAdminPicture(imageFile, index);

        if (!success) {
          selectedImages.removeAt(index);
          imageLoadingFlags.removeAt(index);
        } else {
          imageLoadingFlags[index] = false;
        }
        selectedImages.refresh();
        imageLoadingFlags.refresh();
      } catch (e) {
        log("Error loading or uploading image: $e");
        HelperFunction.snackbar("Failed to process image.");
      }
    }
  }

  Future<bool> _uploadAdminPicture(XFile imageXFile, int index) async {
    try {
      final file = File(imageXFile.path);
      if (!await file.exists()) {
        log("File does not exist: ${imageXFile.path}");
        return false;
      }
      final fileName = file.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();
      final formData = dio.FormData.fromMap({
        ApiParams.file: await dio.MultipartFile.fromFile(
          file.path,
          contentType: MediaType("image", "image/$extension"),
          filename: fileName,
        ),
        ApiParams.mimeType: extension,
        ApiParams.seoFilename: fileName,
        ApiParams.altAttribute: "Uploaded Image",
        ApiParams.titleAttribute: "Admin Picture",
      });
      final response = await _adminRepo.uploadAdminPictures(formData);
      if (response is String) {
        HelperFunction.snackbar("Image upload failed");
        log("Image upload failed controller response: $response");
        return false;
      }
      final pictureModel = response as UploadAdminPictureModel;
      if (pictureModel.status == 200 || pictureModel.status == 201) {
        final id = pictureModel.data?.id ?? "";
        if (id.isNotEmpty) {
          attachmentIds.add({
            "picture_id": id,
            "display_order": attachmentIds.length,
          });
          attachmentIds.refresh();
        }
        log("Image uploaded successfully: ${pictureModel.status} ${attachmentIds.toJson()}");
        return true;
      }
      if (pictureModel.status == 401 ||
          (pictureModel.errors != null &&
              pictureModel.errors.any(
                  (error) => error.errorMessage.toLowerCase().contains("expired") || error.errorMessage.toLowerCase().contains("jwt")))) {
        log("Token expired detected, refreshing...");
        await ApiService().refreshTokenAndRetry(
          () => _adminRepo.uploadAdminPictures(formData),
        );
        return false;
      }
      HelperFunction.snackbar("Image upload failed");
      log("Image upload failed from controller: ${pictureModel.status}");
      return false;
    } catch (e) {
      HelperFunction.snackbar("Image upload failed");
      log("Image upload catch error from controller: ${e.toString()}");
      return false;
    } finally {
      if (index < imageLoadingFlags.length) {
        imageLoadingFlags[index] = false;
        imageLoadingFlags.refresh();
      }
    }
  }

  void removeImage(int index) {
    if (index < selectedImages.length) {
      selectedImages.removeAt(index);
      imageLoadingFlags.removeAt(index);
      if (index < attachmentIds.length) {
        attachmentIds.removeAt(index);
      }
      _refreshDisplayOrders();
    }
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final img = selectedImages.removeAt(oldIndex);
    final flag = imageLoadingFlags.removeAt(oldIndex);
    final attach = attachmentIds.removeAt(oldIndex);
    selectedImages.insert(newIndex, img);
    imageLoadingFlags.insert(newIndex, flag);
    attachmentIds.insert(newIndex, attach);
    _refreshDisplayOrders();
  }

  void _refreshDisplayOrders() {
    for (int i = 0; i < attachmentIds.length; i++) {
      attachmentIds[i]["display_order"] = i;
    }
    attachmentIds.refresh();
    log("AttachmentsId: ${attachmentIds.toJson()}");
  }

  void _addListenerFocusNodes() {
    serviceNameFocusNode.addListener(update);
    descriptionFocusNode.addListener(update);
    priceFocusNode.addListener(update);
    priceFromFocusNode.addListener(update);
    priceToFocusNode.addListener(update);
  }

  @override
  void onClose() {
    super.onClose();
    serviceNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    priceFromController.dispose();
    priceToController.dispose();
    serviceNameFocusNode.dispose();
    descriptionFocusNode.dispose();
    priceFocusNode.dispose();
    priceFromFocusNode.dispose();
    priceToFocusNode.dispose();
  }
}
