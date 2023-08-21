import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';

import '../Routes/app_routes.dart';

class LocalNotificationService{
  static final FlutterLocalNotificationsPlugin  fln
  = FlutterLocalNotificationsPlugin();

  static   AndroidNotificationChannel androidNotificationChannel =  AndroidNotificationChannel(
      Random.secure().nextInt(1000).toString(),
      "pushNotificationAppChannel",
      importance: Importance.high,
  );





  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    fln.initialize( initializationSettings, onDidReceiveNotificationResponse:
        (NotificationResponse payload) async {
            if(payload.id  == 1){
              Get.toNamed(AppRoutes.getBottomNavigationPage());
            }
        },
    );
  }


  static void displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final notificationDetails = _configureNotificationDetails();
      _showNotification(id, notificationDetails, message);

    } on Exception catch (e) {
      print(e);
    }
  }


  static  NotificationDetails _configureNotificationDetails(){
     NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
                androidNotificationChannel.id,
                androidNotificationChannel.name,
                importance: Importance.max,
                priority: Priority.high,
          ),
       iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentBanner: true,
       ),
    );

    return notificationDetails;
  }

  static Future<void> _showNotification(id, notificationDetails, message) async{
    await fln.show(id,
      message.notification!.title, message.notification!.body,
      notificationDetails, payload: message.data['_id'],
    );
  }

}