import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NotificationsController extends GetxController {
  final dummyNotifications = [
    {
      "title": "New Message",
      "body": "You have received a new message from Alex.",
      "time": "2 min ago",
      "icon": Icons.message,
      "color": Colors.blue,
    },
    {
      "title": "Service Update",
      "body": "Your request has been accepted by a provider.",
      "time": "10 min ago",
      "icon": Icons.check_circle,
      "color": Colors.green,
    },
    {
      "title": "Reminder",
      "body": "Don’t forget your appointment tomorrow at 10 AM.",
      "time": "1 hr ago",
      "icon": Icons.alarm,
      "color": Colors.orange,
    },
    {
      "title": "Promotion",
      "body": "Get 20% off your next booking!",
      "time": "Yesterday",
      "icon": Icons.local_offer,
      "color": Colors.purple,
    },
  ];
}
