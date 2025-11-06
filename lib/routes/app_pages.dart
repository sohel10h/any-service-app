import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/view/screens/init/splash_screen.dart';
import 'package:service_la/view/screens/landing/landing_screen.dart';
import 'package:service_la/view/screens/settings/settings_screen.dart';
import 'package:service_la/view/screens/auth/sign_in/sign_in_screen.dart';
import 'package:service_la/view/screens/auth/sign_up/sign_up_screen.dart';
import 'package:service_la/view/screens/ride_sharing/ride_sharing_screen.dart';
import 'package:service_la/view/screens/create_service/create_service_screen.dart';
import 'package:service_la/view/screens/service_details/service_details_screen.dart';
import 'package:service_la/view/screens/auth/verification/otp_verification_screen.dart';
import 'package:service_la/view/screens/create_service/create_service_details_screen.dart';
import 'package:service_la/view/screens/auth/sign_up_complete/sign_up_complete_screen.dart';

abstract class AppPages {
  static const initial = AppRoutes.splashScreen;

  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.landingScreen,
      page: () => const LandingScreen(),
    ),
    GetPage(
      name: AppRoutes.signInScreen,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.settingsScreen,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
    ),
    GetPage(
      name: AppRoutes.signUpCompleteScreen,
      page: () => const SignUpCompleteScreen(),
    ),
    GetPage(
      name: AppRoutes.serviceDetailsScreen,
      page: () => const ServiceDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.createServiceScreen,
      page: () => const CreateServiceScreen(),
    ),
    GetPage(
      name: AppRoutes.createServiceDetailsScreen,
      page: () => const CreateServiceDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.rideSharingScreen,
      page: () => const RideSharingScreen(),
    ),
  ];
}
