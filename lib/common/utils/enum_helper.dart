import 'package:flutter/material.dart';
import 'package:service_la/common/utils/app_colors.dart';

enum AppDeviceType {
  android(1),
  ios(2);

  final int typeValue;

  const AppDeviceType(this.typeValue);
}

enum ClientPlatform { app }

enum NotificationType {
  email(0),
  sms(1),
  serviceRequest(2),
  bid(3),
  vendorFound(4),
  vendorNotFound(5);

  final int typeValue;

  const NotificationType(this.typeValue);
}

enum PayLoadType {
  joined,
  left,
  message,
  notification,
  error,
}

enum ServiceRequestBidStatus {
  pending(0),
  approved(1),
  rejected(2);

  final int typeValue;

  const ServiceRequestBidStatus(this.typeValue);
}

enum ServiceRequestStatus {
  all(0),
  active(1),
  inProgress(2),
  completed(3),
  canceled(4);

  final int typeValue;

  const ServiceRequestStatus(this.typeValue);
}

enum CategoryColors {
  blue([AppColors.container51A2FF, AppColors.container155DFC]),
  purple([AppColors.containerC27AFF, AppColors.container9810FA]),
  orange([AppColors.containerFF8904, AppColors.containerF54900]),
  yellow([AppColors.containerFDC700, AppColors.containerD08700]),
  green([AppColors.container05DF72, AppColors.container00A63E]),
  cyan([AppColors.container00D3F2, AppColors.container0092B8]),
  pink([AppColors.containerFB64B6, AppColors.containerE60076]),
  red([AppColors.containerFF6467, AppColors.containerE7000B]);

  final List<Color> colors;

  const CategoryColors(this.colors);
}

enum ServiceIcon {
  homeCleaning("assets/svgs/home_cleaning.svg"),
  plumbing("assets/svgs/plumbing.svg"),
  haircut("assets/svgs/haircut.svg"),
  locksmith("assets/svgs/locksmith.svg"),
  chef("assets/svgs/chef.svg"),
  carCleaning("assets/svgs/car_cleaning.svg"),
  swimming("assets/svgs/swimming.svg"),
  settingsServices("assets/svgs/settings_services.svg");

  final String path;

  const ServiceIcon(this.path);
}
