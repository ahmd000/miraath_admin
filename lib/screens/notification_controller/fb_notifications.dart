import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

//typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage remoteMessage) async {
  //BACKGROUND Notifications - iOS & Android
  await Firebase.initializeApp();
  print('Message: ${remoteMessage.messageId}');
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin localNotificationsPlugin;

mixin FbNotifications {
  String generalTopic = "users";
  String serverToken =
      "AAAAMsZDnA4:APA91bE7CJApoIf8xTIiESIybyE1Rm2QfhIBU4gqYJnL_qXZcD_Ep0SV9WyidmmKv8VLcv4RSrzTrtUGTyGOd8Z2jsHO109Z_ufzW-ezky9f_erVHUnPu1KBJZyXM9XMhJ_1A_HVm_Mp";

  /// CALLED IN main function between ensureInitialized <-> runApp(widget);
  static Future<void> initNotifications() async {
    //Connect the previous created function with onBackgroundMessage to enable
    //receiving notification when app in Background.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    //Channel
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'miraath_notification_channel',
        'Miraath Notifications Channel',
        description:
            'This channel will receive notifications specific to Miraath App',
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        ledColor: Color(0xff1b4070),
        showBadge: true,
        playSound: true,
      );
    }

    //Flutter Local Notifications Plugin (FOREGROUND) - ANDROID CHANNEL
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    //iOS Notification Setup (FOREGROUND)
    Platform.isIOS
        ? await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    )
        : null;
  }

  //iOS Notification Permission
  Future<void> requestNotificationPermissions() async {
    print('requestNotificationPermissions');

    await Firebase.initializeApp();
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print('GRANT PERMISSION');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      print('Permission Denied');
    }
  }

  //ANDROID
  void initializeForegroundNotificationForAndroid() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message Received: ${message.messageId}');
      print("====================== title Notify =======================");
      print(message.notification!.title);
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = notification?.android;
      if (notification != null && androidNotification != null) {
        localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  //GENERAL (Android & iOS)
  void manageNotificationAction() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _controlNotificationNavigation(message.data);
    });
  }

  void _controlNotificationNavigation(Map<String, dynamic> data) {
    print('Data: $data');
    if (data['page'] != null) {
      switch (data['page']) {
        case 'products':
          var productId = data['id'];
          print('Product Id: $productId');
          break;

        case 'settings':
          print('Navigate to settings');
          break;

        case 'profile':
          print('Navigate to Profile');
          break;
      }
    }
  }

  subscribeGeneralTopic() async {
    await FirebaseMessaging.instance.subscribeToTopic(generalTopic);
  }

  unSubscribeGeneralTopic() async {

    await FirebaseMessaging.instance.unsubscribeFromTopic(generalTopic);
  }

  sendGeneralNotify(String title, String body) async {
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(<String, dynamic>{
          "notification": <String, dynamic>{
            "body": body.toString(),
            "title": title.toString(),
          },
          "priority": "high",
          "data": <String, dynamic>{
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          },
          "to": "/topics/$generalTopic",
        }),
        headers: <String, String>{
          "Content-Type": "application/json",
          "Authorization": "key=$serverToken",
        });
  }
}
