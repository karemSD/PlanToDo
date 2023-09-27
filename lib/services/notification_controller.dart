import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/back_constants.dart';
import 'notification_service.dart';

class NotificationController {
  @pragma('vm:entry-point')
  static void requestPermission() {
    BuildContext context = Get.context!;

    Get.dialog(
      AlertDialog(
        title: const Text('Allow Notifications'),
        content: const Text(
            'Never miss an important task or deadline again! Enable notifications to receive timely reminders about your upcoming tasks, projects, and more'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(Get.context!);
            },
            child: const Text(
              'Don\'t Allow',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () => AwesomeNotifications()
                .requestPermissionToSendNotifications()
                .then((_) => Navigator.pop(Get.context!)),
            child: const Text(
              'Allow',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      initializeNotificationChannels(),
      channelGroups: initializeNotificationGroups(),
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          requestPermission();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  @pragma('vm:entry-point')
  static String constructFCMPayloadJson({
    required List<String> fcmTokens,
    required Map<String, dynamic> data,
  }) {
    return jsonEncode(
        {"registration_ids": fcmTokens, "data": data, "priority": "high"});
  }

  @pragma('vm:entry-point')
  static Future<void> sendPushMessageJson({
    required List<String> fcmTokens,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKeyK',
        },
        body: constructFCMPayloadJson(
          fcmTokens: fcmTokens,
          data: {
            "registration_ids": fcmTokens.toString(),
            "data": data,
            "priority": "high"
          },
        ),
      );
      if (response.statusCode == 200) {
        print('FCM notification sent successfully.');
      } else {
        print(
            'Failed to send FCM notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @pragma('vm:entry-point')
  static String constructFCMPayload({
    required List<String> fcmTokens,
    required Map<String, String> data,
    required String title,
    required String body,
  }) {
    data.addAll({
      "title": title,
      "body": body,
    });
    return jsonEncode(
        {"registration_ids": fcmTokens, "data": data, "priority": "high"});
  }

  @pragma('vm:entry-point')
  static Future<void> sendPushMessage({
    required List<String> fcmTokens,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    if (title.isEmpty || body.isEmpty) {
      print(
          'Unable to send FCM message, check if one of the following is empty fcmTokens,title,body.');
      return;
    }
    try {
      print(data);
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKeyK',
        },
        body: constructFCMPayload(
          body: body,
          fcmTokens: fcmTokens,
          title: title,
          data: data,
        ),
      );
      if (response.statusCode == 200) {
        print('FCM notification sent successfully.');
      } else {
        print(
            'Failed to send FCM notification. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  @pragma('vm:entry-point')
  static List<NotificationChannelGroup>? initializeNotificationGroups() {
    List<NotificationChannelGroup> groups = [];
    groups.addAll(
      [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
    );
    return groups;
  }

  @pragma('vm:entry-point')
  static List<NotificationChannel> initializeNotificationChannels() {
    List<NotificationChannel> channels = [];
    channels.addAll(
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color.fromARGB(255, 183, 221, 80),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
          soundSource: 'resource://raw/pikachu',
        ),
        // NotificationChannel(
        //   channelKey: 'highchannel',
        //   channelName: 'highchannel',
        //   channelDescription: 'Notification channel for basic tests',
        //   defaultColor: const Color(0xFF9D50DD),
        //   ledColor: Colors.white,
        //   importance: NotificationImportance.Max,
        //   channelShowBadge: true,
        //   onlyAlertOnce: true,
        //   playSound: true,
        //   criticalAlerts: true,
        //   soundSource: 'resource://raw/pikachu',
        // ),
        // NotificationChannel(
        //   channelKey: 'miscellaneous',
        //   channelName: 'miscellaneous',
        //   channelDescription: 'Notification channel for basic tests',
        //   defaultColor: const Color(0xFF9D50DD),
        //   ledColor: Colors.white,
        //   importance: NotificationImportance.Max,
        //   channelShowBadge: true,
        //   onlyAlertOnce: true,
        //   playSound: true,
        //   criticalAlerts: true,
        //   soundSource: 'resource://raw/pikachu',
        // ),
      ],
    );
    return channels;
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    await FcmNotifications.onActionReceivedMethod(receivedAction);
  }

  @pragma('vm:entry-point')
  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      requestPermission();
      return;
    }
    assert(!scheduled || (scheduled && interval != null));
    Random random = Random();

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: random.nextInt(999),
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        color: Colors.red,
        bigPicture: bigPicture,
        wakeUpScreen: true,
        displayOnBackground: true,
        displayOnForeground: true,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> showNotificationJson(Map<String, dynamic> data) async {
    // List<dynamic> buttonMap = data["actionButtons"];
    // List<NotificationActionButton> ss = [];
    // for (var element in buttonMap) {
    //   NotificationActionButton s =
    //       NotificationActionButton(key: key, label: label).fromMap(element)!;
    //   ss.add(s);
    // }
    // print(ss);
    // await AwesomeNotifications().createNotification(
    //   content: NotificationContent(
    //     id: data["content"]["id"],
    //     channelKey: 'high_importance_channel',
    //     title: data["content"]["title"],
    //     body: data["content"]["body"],
    //     payload: Map.from(data["content"]["payload"]) ?? null,
    //     wakeUpScreen: true,
    //     displayOnBackground: true,
    //     displayOnForeground: true,
    //   ),
    //   actionButtons: ss,
    // );
    await AwesomeNotifications().createNotificationFromJsonData(data);
  }
}
