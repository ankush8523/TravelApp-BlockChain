import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationHelper {
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel",
    'High Importance Notifications',
    description: 'This channel is used for imortant notifications',
    importance: Importance.high,
    playSound: true,
  );

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroudHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen(onMessageListener);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedAppListener);
  }

  static onMessageOpenedAppListener(RemoteMessage message) {
    print('A new onMessageOpendApp event was published!');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      //Do whatever you want to do when user tap on notification to open app
    }
  }

  static void onMessageListener(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      showLocalNotification(
        notification.hashCode,
        notification.title!,
        notification.body!,
      );
    }
  }

  static void showLocalNotification(int id, String title, String body) {
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: Colors.blue,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  static Future<void> _firebaseMessagingBackgroudHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('A bg message just showed up : ${message.messageId}');
  }

  static Future<String> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    return token!;
  }

  static Future<void> sendNotificationTo(
      String receiversToken, String title, String body) async {
    var data = {
      'to': receiversToken,
      'priority': 'high',
      'notification': {
        'title': title,
        'body': body,
      }
    };
    try {
      await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization':
              'key=${dotenv.env["FIREBASE_CLOUD_MESSAGING_API_SERVER_KEY"]!}'
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
