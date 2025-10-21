import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/utils/app_colors.dart';
import 'package:service_la/data/repository/auth_repo.dart';
import 'package:service_la/common/utils/helper_function.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';
import 'package:service_la/services/api_constants/api_params.dart';
import 'package:service_la/common/utils/storage/storage_helper.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final RxBool isPasswordVisible = false.obs;
  final RxBool isRememberMe = false.obs;
  final AuthRepo _authRepo = AuthRepo();
  RxBool isLoadingSignIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _addListenerFocusNodes();
  }

  void signInButtonOnTap() async {
    if (!(formKey.currentState?.validate() ?? true)) {
      return;
    }
    _signIn();
  }

  Future<void> _signIn() async {
    HelperFunction.hideKeyboard();
    isLoadingSignIn.value = true;
    try {
      dynamic params = {
        ApiParams.identifier: emailController.text,
        ApiParams.password: passwordController.text,
      };
      log("SignIn POST Params: $params");
      var response = await _authRepo.signIn(params);

      if (response is String) {
        HelperFunction.snackbar("Sign in failed. Please check your email and password.");
        log("SignIn failed from controller response: $response");
      } else {
        SignInModel signIn = response as SignInModel;
        if (signIn.status == 200 || signIn.status == 201) {
          StorageHelper.setValue(StorageHelper.authToken, signIn.data?.accessToken ?? "");
          HelperFunction.snackbar(
            "Signed in successfully. Redirecting to your dashboard...",
            title: "Success",
            icon: Icons.check,
            backgroundColor: AppColors.green,
          );
          _goToLandingScreen();
        } else {
          HelperFunction.snackbar("Sign in failed. Please check your email and password.");
          log("SignIn failed from controller: ${signIn.status}");
        }
      }
    } catch (e) {
      HelperFunction.snackbar("Sign in failed. Please check your email and password.");
      log("SignIn catch error from controller: ${e.toString()}");
    } finally {
      isLoadingSignIn.value = false;
    }
  }

  void _goToLandingScreen() => Get.offAllNamed(AppRoutes.landingScreen);

  void goToSignUpScreen() => Get.offAllNamed(AppRoutes.signUpScreen);

  void _addListenerFocusNodes() {
    emailFocusNode.addListener(update);
    passwordFocusNode.addListener(update);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
