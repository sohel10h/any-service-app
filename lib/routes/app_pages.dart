import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/view/screens/init/splash_screen.dart';
import 'package:service_la/view/screens/landing/landing_screen.dart';
import 'package:service_la/view/screens/chats/chats_list_screen.dart';
import 'package:service_la/view/screens/chats/chats_room_screen.dart';
import 'package:service_la/view/screens/settings/settings_screen.dart';
import 'package:service_la/view/screens/auth/sign_in/sign_in_screen.dart';
import 'package:service_la/view/screens/auth/sign_up/sign_up_screen.dart';
import 'package:service_la/view/screens/category_screen/category_screen.dart';
import 'package:service_la/view/screens/chats/chats_archived_list_screen.dart';
import 'package:service_la/view/screens/ride_sharing/ride_sharing_screen.dart';
import 'package:service_la/view/screens/notification/notifications_screen.dart';
import 'package:service_la/view/screens/create_service/create_service_screen.dart';
import 'package:service_la/view/screens/ride_sharing/ride_sharing_map_screen.dart';
import 'package:service_la/view/screens/vendor_profile/vendor_profile_screen.dart';
import 'package:service_la/view/screens/auth/verification/otp_verification_screen.dart';
import 'package:service_la/view/screens/create_service/create_service_details_screen.dart';
import 'package:service_la/view/screens/auth/sign_up_complete/sign_up_complete_screen.dart';
import 'package:service_la/view/screens/best_selling_services/best_selling_services_screen.dart';
import 'package:service_la/view/screens/ride_sharing/ride_sharing_map_location_search_screen.dart';
import 'package:service_la/view/screens/service_request_details/service_request_details_screen.dart';

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
      name: AppRoutes.serviceRequestDetailsScreen,
      page: () => const ServiceRequestDetailsScreen(),
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
    GetPage(
      name: AppRoutes.rideSharingMapScreen,
      page: () => const RideSharingMapScreen(),
    ),
    GetPage(
      name: AppRoutes.rideSharingMapLocationSearchScreen,
      page: () => const RideSharingMapLocationSearchScreen(),
    ),
    GetPage(
      name: AppRoutes.bestSellingServicesScreen,
      page: () => const BestSellingServicesScreen(),
    ),
    GetPage(
      name: AppRoutes.categoryScreen,
      page: () => const CategoryScreen(),
    ),
    GetPage(
      name: AppRoutes.chatsListScreen,
      page: () => const ChatsListScreen(),
    ),
    GetPage(
      name: AppRoutes.chatsRoomScreen,
      page: () => const ChatsRoomScreen(),
    ),
    GetPage(
      name: AppRoutes.chatsArchivedListScreen,
      page: () => const ChatsArchivedListScreen(),
    ),
    GetPage(
      name: AppRoutes.notificationsScreen,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.vendorProfileScreen,
      page: () => const VendorProfileScreen(),
    ),
  ];
}
