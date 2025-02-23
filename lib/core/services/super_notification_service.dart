import 'dart:convert';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:neuss_utils/utils/helpers.dart';
import 'package:ready_extensions/ready_extensions.dart';
import '../../app/controllers/app_controller.dart';
import '../../firebase_options.dart';
import '../utils/app_constants.dart';
import '../utils/app_enums.dart';

@pragma("vm:entry-point")
Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
  mPrint2('Handling onBackgroundMessage ${remoteMessage.toMap()}');
}

class SuperNotificationService extends GetxService {
  static SuperNotificationService get to => Get.find();

  static const String channelName = 'basic_channel';
  static const String topicAll = 'Topic_All';

  static const String serverKey =
      'AAAA2DIHLF8:APA91bGy9X8GpCE1CvWUGHrFlglEhrMpHh2aCxhh9a_YTpbM03extKKUbYqnSajJU55w2SvcP6xRzCP1JOeayHzR6PljAaurZ1fK1A5iPXIbG2cPRjKKSM2h0iDdt-nLw5cybtd-gR-5';
  static const String fcmPostUrl = 'https://fcm.googleapis.com/fcm/send';

  void initAll() async {
    await FCMConfig.instance.init(
        options: DefaultFirebaseOptions.currentPlatform,
        // defaultAndroidForegroundIcon: "@mipmap/ic_launcher",
        defaultAndroidChannel: const AndroidNotificationChannel(
          channelName,
          AppConstants.appName,
          importance: Importance.max,
          playSound: true,
        ),
        displayInForeground: (notification) => true,
        onBackgroundMessage: onBackgroundMessage);

    await updateMyFCMToken();
    FCMConfig.instance.messaging.onTokenRefresh.listen(myFcmTokenHandle);

    FCMConfig.instance.onMessage.listen(onNotificationReceived);
    FCMConfig.instance.onTap.listen(onNotificationTapped);
    FCMConfig.instance.messaging.subscribeToTopic(topicAll);
    3.seconds.delay(() async {
      RemoteMessage? initMsg = await FCMConfig.instance.getInitialMessage();
      if (initMsg != null) {
        mPrint('initMsg = $initMsg');
        onNotificationReceived(initMsg);
      }
    });
  }

  Future updateMyFCMToken() async {
    await getFirebaseMessagingToken().then(myFcmTokenHandle);
  }

  @pragma("vm:entry-point")
  Future<void> onNotificationReceived(RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    mPrint('onMessage = ${message.toMap()}');

    if (message.data['payload'] != null) {
      AppController controller = AppController.to;
      Map<String, dynamic> payload = jsonDecode(message.data['payload']);
      if (payload['type'] == 'Test' && payload['userID'] != null) {}

      mHide();
    }
  }

  @pragma("vm:entry-point")
  Future<void> onNotificationTapped(RemoteMessage message) async {
    WidgetsFlutterBinding.ensureInitialized();
    mPrint('onTap = ${message.toMap()}');

    if (message.data['payload'] != null) {
      AppController controller = AppController.to;
      Map<String, dynamic> payload = jsonDecode(message.data['payload']);
    }
  }

  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String? token) async {
    mPrint('Generated FCM Token: "$token"');
    AppController.to.updateMyFCMToken(token);
  }

  Future<String> getFirebaseMessagingToken() async {
    String firebaseAppToken = '';
    try {
      firebaseAppToken = await FCMConfig.instance.messaging.getToken() ?? '';
      // mPrint('fcm_token: $firebaseAppToken');
    } catch (exception) {
      mPrintError('$exception');
    }
    return firebaseAppToken;
  }

  void updateMyTopics() {
    if (AppController.to.isConnected) {
      try {
        if (AppController.to.successfullyLoggedIn) {
          FCMConfig.instance.messaging.subscribeToTopic(FCMTopics.topicAll.name).timeout(10.seconds);

          if (AppController.to.mUser!.gender == true) {
            FCMConfig.instance.messaging.subscribeToTopic(FCMTopics.topicMale.name).timeout(10.seconds);
            FCMConfig.instance.messaging.unsubscribeFromTopic(FCMTopics.topicFemale.name).timeout(10.seconds);
          } else if (AppController.to.mUser!.gender == false) {
            FCMConfig.instance.messaging.subscribeToTopic(FCMTopics.topicFemale.name).timeout(10.seconds);
            FCMConfig.instance.messaging.unsubscribeFromTopic(FCMTopics.topicMale.name).timeout(10.seconds);
          }
        } else {
          try {
            for (var topic in FCMTopics.values) {
              FCMConfig.instance.messaging.unsubscribeFromTopic(topic.name).timeout(10.seconds);
            }
          } on Exception {
            /// TODO
          }
        }
      } on Exception catch (e) {
        mPrintException(e);
      }
    }
  }

  ///region Send FCM Notification
  void sendToMySelf() async {
    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': 'this is a body', 'title': 'this is a title'},
          'priority': 'high',
          'data': <String, dynamic>{
            'id': '1',
            'status': 'done',
          },
          'to': await FirebaseMessaging.instance.getToken(),
        },
      ),
    );
    mPrint({
      "statusCode": response.statusCode,
      "body": response.body,
    });
  }

  static Future<(bool, String)> sendFCMNotification(
      {String title = AppConstants.appName,
      String body = 'Test',
      bool addDismiss = true,
      required List<String> to,
      String? action1,
      String? action2,
      String? dismissLabel = 'Dismiss',
      Map<String, String?>? payload}) async {
    if (to.isEmptyOrNull || to.any((element) => element.isNullOrEmptyOrWhiteSpace)) {
      return (false, "Sending failed: No target");
    }
    var bodyJson = jsonEncode({
      "registration_ids": to.map((e) => e.toString()).toList(),
      "mutable_content": true,
      "priority": "high",
      "notification": {
        "badge": 1,
        "title": title,
        "body": body,
      },
      "data": {
        if (payload != null) "payload": payload,
        "android": {
          "notification": {"sound": "default"}
        },
        "apns": {
          "payload": {"sound": "default"}
        },
      }
    });
    mPrint('Sending FCMNotification: $bodyJson');
    // return;
    try {
      http.Response response =
          await http.post(Uri.parse(fcmPostUrl), body: bodyJson, headers: {'Authorization': 'key=$serverKey', 'Content-Type': 'application/json'});
      mPrint2('sendFCMNotification response ${({
        'request body': bodyJson,
        'response': {'statusCode': response.statusCode, 'body': response.body}
      })}');
      return (true, "Sent successfully");
    } on Exception catch (e) {
      mPrintError('FCM Exception: $e');
      return (false, "Sending failed: $e");
    }
  }

  static Future<(bool, String)> sendFCMNotificationToTopic(
      {String title = AppConstants.appName,
      String body = 'Test',
      required String topic,
      bool addDismiss = true,
      String? action1,
      String? action2,
      String? dismissLabel = 'Dismiss',
      Map<String, String?>? payload}) async {
    var bodyJson = jsonEncode({
      "to": "/topics/$topic",
      "mutable_content": true,
      "priority": "high",
      "notification": {
        "badge": 1,
        "title": title,
        "body": body,
      },
      "data": {
        if (payload != null) "payload": payload,
        "android": {
          "notification": {"sound": "default"}
        },
        "apns": {
          "payload": {"sound": "default"}
        },
      }
    });
    mPrint('Sending FCMNotification: $bodyJson');
    // return;
    try {
      http.Response response =
          await http.post(Uri.parse(fcmPostUrl), body: bodyJson, headers: {'Authorization': 'key=$serverKey', 'Content-Type': 'application/json'});
      mPrint2('sendFCMNotification response ${({
        'request body': bodyJson,
        'response': {'statusCode': response.statusCode, 'body': response.body}
      })}');
      return (true, "Sent successfully");
    } on Exception catch (e) {
      mPrintError('FCM Exception: $e');
      return (false, "Sending failed: $e");
    }
  }

  ///endregion Send FCM Notification
}
