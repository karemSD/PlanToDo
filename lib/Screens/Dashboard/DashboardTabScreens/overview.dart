import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/categoryController.dart';
import 'package:mytest/controllers/manger_controller.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/user_task_controller.dart';

import '../../../BottomSheets/bottom_sheets.dart';
import '../../../Values/values.dart';
import '../../../constants/app_constans.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/BottomSheets/dashboard_settings_sheet.dart';
import '../../../widgets/Dashboard/overview_task_container.dart';
import '../../../widgets/Shapes/app_settings_icon.dart';

class DashboardOverview extends StatefulWidget {
  DashboardOverview({Key? key}) : super(key: key);
  static String id = "/DashboardOverviewScreen";

  @override
  State<DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<DashboardOverview> {
  final ValueNotifier<bool> _totalTaskTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalTaskToDoTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalCompletedTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalCategoriesTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalTeamsTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _totalProjectsTrigger = ValueNotifier(true);

  final ValueNotifier<bool> _workingOnTrigger = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    TaskCategoryController taskCategoryController =
        Get.put(TaskCategoryController());
    UserTaskController userTaskController = Get.put(UserTaskController());
    ProjectController projectController = Get.put(ProjectController());
    TeamController teamController = Get.put(TeamController());
    int catNumber = 0;
    int totalTaskNumber = 0;
    int toDoTaskNumber = 0;
    int completedtaskNumber = 0;
    int projectNumber = 0;
    int teamsNumber = 0;
    int workingOnNumber = 0;
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 30,
                  alignment: Alignment.centerRight,
                  child: AppSettingsIcon(
                    callback: () {
                      showAppBottomSheet(
                        DashboardSettingsBottomSheet(
                          totalTaskToDoTrigger: _totalTaskToDoTrigger,
                          totalCategoriesTrigger: _totalCategoriesTrigger,
                          totalProjectsTrigger: _totalProjectsTrigger,
                          totalTeamsTrigger: _totalTeamsTrigger,
                          totalTaskNotifier: _totalTaskTrigger,
                          totalworkingOnNotifier: _workingOnTrigger,
                          totalCompletedNotifier: _totalCompletedTrigger,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            triggerShow(
                valueListenable: _totalTaskTrigger,
                number: totalTaskNumber,
                stream: userTaskController
                    .getUserTasksStream(
                      userId:
                          AuthService.instance.firebaseAuth.currentUser!.uid,
                    )
                    .asBroadcastStream(),
                name: AppConstants.total_task_key.tr,
                colorHex: "EFA17D",
                imageUrl: "assets/project.png"),
            triggerShow(
                valueListenable: _totalTaskToDoTrigger,
                number: toDoTaskNumber,
                stream: userTaskController
                    .getUserTasksStartInADayForAStatusStream(
                        date: DateTime.now(),
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid,
                        status: statusNotStarted)
                    .asBroadcastStream(),
                name: AppConstants.to_do_today_key.tr,
                colorHex: "EFA17D",
                imageUrl: "assets/orange_pencil.png"),
            triggerShow(
                valueListenable: _workingOnTrigger,
                number: workingOnNumber,
                stream: userTaskController
                    .getUserTasksForAStatusStream(
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid,
                        status: statusDoing)
                    .asBroadcastStream(),
                name: AppConstants.working_on_key.tr,
                colorHex: "EFA17D",
                imageUrl: "assets/working_on.png"),
            triggerShow(
                valueListenable: _totalCompletedTrigger,
                number: completedtaskNumber,
                stream: userTaskController
                    .getUserTasksForAStatusStream(
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid,
                        status: statusDone)
                    .asBroadcastStream(),
                name: AppConstants.completed_task_key.tr,
                colorHex: "7FBC69",
                imageUrl: "assets/task_done.png"),
            triggerShow(
                valueListenable: _totalCategoriesTrigger,
                number: catNumber,
                stream: taskCategoryController
                    .getUserCategoriesStream(
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid)
                    .asBroadcastStream(),
                name: AppConstants.total_categories_key.tr,
                colorHex: "EDA7FA",
                imageUrl: "assets/category.png"),
            triggerShow(
                valueListenable: _totalProjectsTrigger,
                number: projectNumber,
                stream: projectController
                    .getProjectsOfUserStream(
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid)
                    .asBroadcastStream(),
                name: AppConstants.total_projects_key.tr,
                colorHex: "EDA7FA",
                imageUrl: "assets/project.png"),
            triggerShow(
                valueListenable: _totalTeamsTrigger,
                number: teamsNumber,
                stream: teamController
                    .getTeamsOfUserStream(
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid)
                    .asBroadcastStream(),
                name: AppConstants.total_teams_key.tr,
                colorHex: "EDA7FA",
                imageUrl: "assets/team.png"),
          ],
        ),
      ],
    );
  }

  ValueListenableBuilder<bool> triggerShow({
    required ValueListenable<bool> valueListenable,
    required int number,
    required Stream stream,
    required String name,
    required String colorHex,
    required String imageUrl,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: valueListenable,
      builder: (BuildContext context, bool value, Widget? child) {
        return Visibility(
          visible: value,
          child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  number = snapshot.data!.size;
                }
                return OverviewTaskContainer(
                    cardTitle: name,
                    numberOfItems: number.toString(),
                    imageUrl: imageUrl,
                    backgroundColor: HexColor.fromHex(colorHex));
              }),
        );
      },
    );
  }
}
