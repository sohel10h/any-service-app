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
  shortlisted(1),
  selected(2),
  rejected(3);

  final int typeValue;

  const ServiceRequestBidStatus(this.typeValue);
}
