import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/user_task_controller.dart';

import 'package:tcard/tcard.dart';
import '../../../Data/data_model.dart';
import '../../../Values/values.dart';
import '../../../constants/app_constans.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/Dashboard/daily_goal_card.dart';
import '../../../widgets/Dashboard/productivity_chart.dart';
import '../../../widgets/Dashboard/task_progress_card.dart';

class DashboardProductivity extends StatefulWidget {
  const DashboardProductivity({Key? key}) : super(key: key);
  static String id = "/DashboardProductivityScreen";

  @override
  State<DashboardProductivity> createState() => _DashboardProductivityState();
}

class _DashboardProductivityState extends State<DashboardProductivity> {
  @override
  Widget build(BuildContext context) {
    List<double> precentage = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    DateTime todayDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final dynamic data = AppData.progressIndicatorList;
    UserTaskController userTaskController = Get.put(UserTaskController());
    List<Widget> cards = List.generate(
        5,
        (index) => TaskProgressCard(
              cardTitle: data[index]['cardTitle'],
              rating: data[index]['rating'],
              progressFigure: data[index]['progress'],
              percentageGap: int.parse(data[index]['progressBar']),
            ));

    return Column(
      children: [
        AppSpaces.verticalSpace10,
        DailyGoalCard(
          message: AppConstants.task_key.tr,
          allStream: userTaskController.getUserTasksStartInADayForAStatusStream(
              date: DateTime.now(),
              userId: AuthService.instance.firebaseAuth.currentUser!.uid,
              status: statusDone),
          forStatusStram: userTaskController.getUserTasksBetweenTowTimesStream(
              firstDate: todayDate,
              secondDate: todayDate.add(
                const Duration(days: 1),
              ),
              userId: AuthService.instance.firebaseAuth.currentUser!.uid),
        ),
        AppSpaces.verticalSpace20,
        StreamBuilder(
            stream: userTaskController
                .getPercentagesForLastSevenDaysforaUserforAStatusStream(
                    userId: AuthService.instance.firebaseAuth.currentUser!.uid,
                    startdate: DateTime.now(),
                    status: statusDone),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //       print(snapshot.data);
                precentage = snapshot.data!;
                return ProductivityChart(
                  percentages: precentage,
                  message: AppConstants.task_key.tr,
                );
              }
              return ProductivityChart(
                percentages: precentage,
                message: AppConstants.task_key.tr,
              );
            }),
      ],
    );
  }
}
