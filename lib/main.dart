import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service_la/routes/app_pages.dart';
import 'package:service_la/routes/app_routes.dart';
import 'package:service_la/common/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:service_la/bindings/view_model_bindings.dart';
import 'package:service_la/common/translations/text_languages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const ServiceLa());
}

class ServiceLa extends StatelessWidget {
  const ServiceLa({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: TextLanguages(),
          locale: const Locale("en", "US"),
          initialBinding: ViewModelBindings(),
          title: "Service La",
          theme: AppTheme.defaultTheme,
          getPages: AppPages.routes,
          initialRoute: AppRoutes.splashScreen,
        );
      },
    );
  }
}
