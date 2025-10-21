import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/data/repository/auth_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/send_otp_model.dart';
import 'package:service_la/services/api_constants/api_params.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  RxString password = "".obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isAgreeWithTAndC = false.obs;
  final AuthRepo _authRepo = AuthRepo();
  RxBool isLoadingSendOtp = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

  void registerButtonOnTap() {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    _sendOtp();
  }

  Future<void> _sendOtp() async {
    HelperFunction.hideKeyboard();
    isLoadingSendOtp.value = true;
    try {
      dynamic params = {
        ApiParams.identifier: emailController.text,
        ApiParams.identifierType: ApiParams.email,
      };
      log("SendOtp POST Params: $params");
      var response = await _authRepo.sendOtp(params);

      if (response is String) {
        log("SendOtp failed from controller = $response");
      } else {
        SendOtpModel sendOtp = response as SendOtpModel;
        if (sendOtp.status == 200 || sendOtp.status == 201) {
          HelperFunction.snackbar(
            "OTP sent successfully to your email.",
            title: "Success",
            backgroundColor: AppColors.green,
          );
          _goToOtpVerificationScreen();
        } else {
          HelperFunction.snackbar("Failed to send OTP. Please try again.");
        }
      }
    } catch (e) {
      log("SendOtp catch error from controller: ${e.toString()}");
    } finally {
      isLoadingSendOtp.value = false;
    }
  }

  void _goToOtpVerificationScreen() => Get.offAllNamed(
        AppRoutes.otpVerificationScreen,
        arguments: {
          "email": emailController.text,
        },
      );

  void goToSignInScreen() => Get.offAllNamed(AppRoutes.signInScreen);

  void _addListenerFocusNodes() {
    firstNameFocusNode.addListener(update);
    lastNameFocusNode.addListener(update);
    emailFocusNode.addListener(update);
    phoneFocusNode.addListener(update);
    passwordFocusNode.addListener(update);
    confirmPasswordFocusNode.addListener(update);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}
