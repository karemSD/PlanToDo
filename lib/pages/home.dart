import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/controllers/statusController.dart';
import 'package:mytest/models/User/User_task_Model.dart';
import 'package:mytest/models/statusmodel.dart';
import 'package:mytest/pages/languageScreen.dart';

import 'package:mytest/services/notification_controller.dart';
import 'package:mytest/services/types.dart';

import '../Screens/splash_screen.dart';
import '../components/round_text_field.dart';
import '../controllers/userController.dart';
import '../controllers/user_task_controller.dart';
import '../services/auth_service.dart';
import '../services/collectionsrefrences.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Key key = const Key("");
  String token = "";
  @override
  void initState() {
    FcmNotifications notifications = Get.put(FcmNotifications());
    super.initState();
    on();
  }

  on() async {
    token = await getFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    TextEditingController titleCon = TextEditingController();
    TextEditingController bodyCon = TextEditingController();
    //  FcmNotifications notifications = Get.put(FcmNotifications());
    UserTaskController taskController = Get.put(UserTaskController());
    StatusController statusController = Get.put(StatusController());
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () async {
              userController.updateUser(data: {
                "tokenFcm": FieldValue.arrayRemove([await getFcmToken()]),
              }, id: AuthService.instance. firebaseAuth.currentUser!.uid );
              await AuthService.instance.firebaseAuth.signOut();
            },
            icon: const Icon(Icons.logout))
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              initialValue: token,
            ),
            const SizedBox(
              height: 10,
            ),
            RoundedInputField(
                hintText: "body",
                cursorColor: Colors.white,
                editTextBackgroundColor: Colors.white,
                iconColor: Colors.red,
                onChanged: (value) {},
                textEditingController: bodyCon,
                icon: Icons.abc),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                print(statusesRef.doc().id);

                String? token = await FirebaseMessaging.instance.getToken();
                FcmNotifications s = Get.put(FcmNotifications());
                await s.sendNotificationAsJson(
                  fcmTokens: [token!],
                  title: "title",
                  body: "body",
                  type: NotificationType.notification,
                );
              },
              child: const Text("send push notification"),
            ),
            TextButton(
                onPressed: () async {
                  // UserTaskModel userTaskModel = UserTaskModel(
                  //   userIdParameter: "11",
                  //   folderIdParameter: "folder1",
                  //   taskFatherIdParameter: null,
                  //   descriptionParameter: "Do laundry",
                  //   idParameter: usersTasksRef.doc().id,
                  //   nameParameter: "Laundry1",
                  //   statusIdParameter: "1",
                  //   importanceParameter: 3,
                  //   createdAtParameter: DateTime.now(),
                  //   updatedAtParameter:
                  //       DateTime.now().add(const Duration(days: 1)),
                  //   startDateParameter: DateTime.now(),
                  //   endDateParameter:
                  //       DateTime.now().add(const Duration(days: 2)),
                  // );

                  // await taskController.addUserTask(
                  //     userTaskModel: userTaskModel);
                },
                child: const Text("add task")),
            TextButton(
                onPressed: () {
                  Get.to(() => LanguagePage());
                },
                child: const Text("lang puge"))
          ],
        ),
      ),
    );
  }
}
//TODO:make use of this widget

                // ElegantNotification.success(
                //   width: 360,
                //   notificationPosition: NotificationPosition.topLeft,
                //   animation: AnimationType.fromTop,
                //   title: Text('Update'),
                //   description: Text('Your data has been updated'),
                //   onDismiss: () {
                //     print(
                //       'This print will be displayed when dismissing the popup',
                //     );
                //   },
                // ).show(context);
