import 'package:get/get.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/view/screens/init/splash_screen.dart';
import 'package:service_la/view/screens/landing/landing_screen.dart';

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
  ];
}
