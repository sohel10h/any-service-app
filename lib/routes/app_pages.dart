import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/view/screens/home/home_screen.dart';
import 'package:service_la/view/screens/init/splash_screen.dart';
import 'package:service_la/view/screens/landing/landing_screen.dart';
import 'package:service_la/view/screens/auth/sign_in/sign_in_screen.dart';
import 'package:service_la/view/screens/auth/sign_up/sign_up_screen.dart';

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
      name: AppRoutes.sigInScreen,
      page: () => const SigInScreen(),
    ),
    GetPage(
      name: AppRoutes.sigUpScreen,
      page: () => const SigUpScreen(),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomeScreen(),
    ),
  ];
}
