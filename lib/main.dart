
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/Screens/Auth/authPage.dart';
import 'package:mytest/services/Notifications_Sender.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/services/notification_service.dart';
import 'package:sizer/sizer.dart';

import 'Utils/messages.dart';
import 'firebase_options.dart';
import 'utils/dep.dart' as dep;
import 'constants/app_constans.dart';
import 'controllers/languageController.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .then((value) => Get.put(AuthService()));
  }
  await AndroidAlarmManager.initialize();
  const int helloAlarmID = 0;
  await AndroidAlarmManager.periodic(
      const Duration(seconds: 45), helloAlarmID, checkAuth,
      wakeup: true, rescheduleOnReboot: true);
  await fcmHandler();
  Map<String, Map<String, String>> _languages = await dep.init();

  runApp(MyApp(
    languages: _languages,
  ));
}

@pragma('vm:entry-point')
Future<void> fcmHandler() async {
  print("object");
  FirebaseMessaging.onMessage.listen(FcmNotifications.handleMessageJson);
  FirebaseMessaging.onMessageOpenedApp
      .listen(FcmNotifications.handleMessageJson);
  FirebaseMessaging.onBackgroundMessage(FcmNotifications.handleMessageJson);
  RemoteMessage? remoteMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (remoteMessage != null) {
    await FcmNotifications.handleMessageJson(remoteMessage);
  }
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) =>
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return GetMaterialApp(
          locale: localizationController.locale,
          translations: Messages(languages: languages),
          fallbackLocale:
              Locale(AppConstants.languageCode[1], AppConstants.countryCode[1]),
          debugShowCheckedModeBanner: false,
          home: const AuthPage(),
        );
      }),
    );
  }
}
