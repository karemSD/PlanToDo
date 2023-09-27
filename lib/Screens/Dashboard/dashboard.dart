import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/User/User_model.dart';

import '../../BottomSheets/bottom_sheets.dart';
import '../../Values/values.dart';
import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/BottomSheets/dashboard_settings_sheet.dart';
import '../../widgets/Buttons/primary_tab_buttons.dart';
import '../../widgets/Navigation/dasboard_header.dart';
import '../../widgets/Shapes/app_settings_icon.dart';
import '../Chat/chat_screen.dart';
import '../Profile/profile_overview.dart';
import 'DashboardTabScreens/overview.dart';
import 'DashboardTabScreens/productivity.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  Dashboard({Key? key}) : super(key: key);
  final ValueNotifier<bool> _totalTaskTrigger = ValueNotifier(true);
  final ValueNotifier<bool> _totalDueTrigger = ValueNotifier(false);
  final ValueNotifier<bool> _totalCompletedTrigger = ValueNotifier(true);
  final ValueNotifier<bool> _workingOnTrigger = ValueNotifier(false);
  final ValueNotifier<int> _buttonTrigger = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardNav(
                image: "assets/man-head.png",
                notificationCount: "2",
                page: Container(),
                title: AppConstants.dashboard_key.tr,
                onImageTapped: () async {
                  bool fcmStutas =
                      await FcmNotifications.getNotificationStatus();
                  Get.to(() => ProfileOverview(
                        isSelected: fcmStutas,
                      ));
                  print(AuthService.instance.firebaseAuth.currentUser!.email);
                },
              ),
              AppSpaces.verticalSpace20,
              StreamBuilder<DocumentSnapshot<UserModel>>(
                  stream: UserController().getUserByIdStream(
                      id: AuthService.instance.firebaseAuth.currentUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    return Text(
                      "${AppConstants.hello_n_key.tr}  ,\n ${snapshot.data!.data()!.name} 👋",
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    );
                  }),
              AppSpaces.verticalSpace20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //tab indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PrimaryTabButton(
                          buttonText: AppConstants.overview_key.tr,
                          itemIndex: 0,
                          notifier: _buttonTrigger),
                      PrimaryTabButton(
                          buttonText: AppConstants.productivity_key.tr,
                          itemIndex: 1,
                          notifier: _buttonTrigger)
                    ],
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              ValueListenableBuilder(
                valueListenable: _buttonTrigger,
                builder: (BuildContext context, _, __) {
                  return _buttonTrigger.value == 0
                      ? DashboardOverview()
                      : const DashboardProductivity();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
