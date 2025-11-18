import 'package:get/get.dart';
import 'package:service_la/services/di/app_di_controller.dart';
import 'package:service_la/view/screens/home/controller/home_controller.dart';
import 'package:service_la/view/screens/init/controller/splash_controller.dart';
import 'package:service_la/view/screens/landing/controller/landing_controller.dart';
import 'package:service_la/view/screens/settings/controller/settings_controller.dart';
import 'package:service_la/view/screens/auth/sign_in/controller/sign_in_controller.dart';
import 'package:service_la/view/screens/auth/sign_up/controller/sign_up_controller.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_controller.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_controller.dart';
import 'package:service_la/view/screens/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:service_la/view/screens/ride_sharing/controller/ride_sharing_map_controller.dart';
import 'package:service_la/view/screens/auth/verification/controller/otp_verification_controller.dart';
import 'package:service_la/view/screens/create_service/controller/create_service_details_controller.dart';
import 'package:service_la/view/screens/auth/sign_up_complete/controller/sign_up_complete_controller.dart';
import 'package:service_la/view/screens/service_request_details/controller/service_request_details_controller.dart';

class ViewModelBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<LandingController>(() => LandingController(), fenix: true);
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.put(AppDIController());
    Get.lazyPut<SignUpController>(() => SignUpController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    Get.lazyPut<OtpVerificationController>(() => OtpVerificationController(), fenix: true);
    Get.lazyPut<SignUpCompleteController>(() => SignUpCompleteController(), fenix: true);
    Get.lazyPut<ServiceRequestDetailsController>(() => ServiceRequestDetailsController(), fenix: true);
    Get.lazyPut<VendorProfileController>(() => VendorProfileController(), fenix: true);
    Get.lazyPut<CreateServiceController>(() => CreateServiceController(), fenix: true);
    Get.lazyPut<CreateServiceDetailsController>(() => CreateServiceDetailsController(), fenix: true);
    Get.lazyPut<RideSharingController>(() => RideSharingController(), fenix: true);
    Get.lazyPut<RideSharingMapController>(() => RideSharingMapController(), fenix: true);
  }
}
