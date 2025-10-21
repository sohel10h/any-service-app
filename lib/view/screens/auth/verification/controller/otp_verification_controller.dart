import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/data/repository/auth_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/data/model/network/validate_otp_model.dart';

class OtpVerificationController extends GetxController {
  String email = "";
  String otpNumber = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();
  final AuthRepo _authRepo = AuthRepo();
  RxBool isLoadingValidateOtp = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getArguments();
    _addListenerFocusNodes();
  }

  void verifyEmailButtonOnTap() {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    _validateOtp();
  }

  Future<void> _validateOtp() async {
    HelperFunction.hideKeyboard();
    isLoadingValidateOtp.value = true;
    try {
      dynamic params = {
        ApiParams.otpCode: otpNumber,
        ApiParams.identifier: email,
        ApiParams.identifierType: ApiParams.email,
      };
      log("ValidateOtp POST Params: $params");
      var response = await _authRepo.validateOtp(params);

      if (response is String) {
        HelperFunction.snackbar("Verification failed. The code you entered is incorrect.");
        log("ValidateOtp failed from controller response: $response");
      } else {
        ValidateOtpModel validateOtp = response as ValidateOtpModel;
        if (validateOtp.status == 200 || validateOtp.status == 201) {
          HelperFunction.snackbar(
            "OTP verified successfully. Proceeding to the next step.",
            title: "Success",
            backgroundColor: AppColors.green,
          );
          _goToSignUpCompleteScreen(validateOtp.data?.sessionToken ?? "");
        } else {
          HelperFunction.snackbar("Verification failed. The code you entered is incorrect.");
          log("ValidateOtp failed from controller: ${validateOtp.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Verification failed. The code you entered is incorrect.");
      log("ValidateOtp catch error from controller: ${e.toString()}");
    } finally {
      isLoadingValidateOtp.value = false;
    }
  }

  void _goToSignUpCompleteScreen(String sessionToken) => Get.offAllNamed(
        AppRoutes.signUpCompleteScreen,
        arguments: {
          "sessionToken": sessionToken,
        },
      );

  void _addListenerFocusNodes() {
    otpFocusNode.addListener(update);
  }

  void _getArguments() {
    if (Get.arguments != null) {
      email = Get.arguments["email"] ?? "";
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }
}
