import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_la/data/model/network/sign_in_model.dart';

class AppDIController extends GetxController {
  static Rx<SignInModel> signInDetails = SignInModel().obs;

  static SignInModel setSignInDetails(SignInModel signIn) {
    log("SignInResponse: storing signin model response... ${signIn.toJson()}");
    signInDetails.value = signIn;
    return signInDetails.value;
  }
}
