import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/statusController.dart';
import 'package:mytest/models/User/User_task_Model.dart';
import 'package:mytest/models/statusmodel.dart';
import 'package:mytest/models/team/Project_main_task_Model.dart';
import 'package:mytest/models/team/Project_model.dart';
import 'package:mytest/models/team/Project_sub_task_Model.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/widgets/Dashboard/select_color_dialog.dart';
import '../../BottomSheets/bottom_sheets.dart';
import '../../Values/values.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/projectController.dart';
import '../../controllers/project_main_task_controller.dart';
import '../../controllers/project_sub_task_controller.dart';
import '../../controllers/team_member_controller.dart';
import '../../controllers/userController.dart';
import '../../controllers/user_task_controller.dart';
import '../../models/task/UserTaskCategory_model.dart';
import '../../models/team/TeamMembers_model.dart';

import '../BottomSheets/bottom_sheet_holder.dart';
import '../Forms/form_input_with _label.dart';
import '../User/new_sheet_goto_calender.dart';
import '../add_sub_icon.dart';
import 'dashboard_add_project_sheet.dart';

// ignore: must_be_immutable
class NewCreateTaskBottomSheet extends StatefulWidget {
  NewCreateTaskBottomSheet({
    Key? key,
  }) : super(key: key);
  @override
  State<NewCreateTaskBottomSheet> createState() =>
      _NewCreateTaskBottomSheetState();
}

class _NewCreateTaskBottomSheetState extends State<NewCreateTaskBottomSheet> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();

  List<int> importancelist = [
    1,
    2,
    3,
    4,
    5,
  ];
  int? selectedDashboardOption;
  List<TeamMemberModel> membersList = [];
  String? teamMemberId;
  @override
  void initState() {
    super.initState();
    selectedDashboardOption = importancelist[0];
  }

  //void onChanged(String value) async {}

  DateTime startDate = DateTime.now();
  String color = "#FDA7FF";
  DateTime dueDate = DateTime.now();
  UserController userController = Get.put(UserController());
  UserTaskController userTaskController = Get.put(UserTaskController());
  ProjectMainTaskController projectMainTaskController =
      Get.put(ProjectMainTaskController());
  TaskCategoryController taskCategoryController =
      Get.put(TaskCategoryController());
  ProjectSubTaskController projectSubTaskController =
      Get.put(ProjectSubTaskController());
  ProjectController projectController = Get.put(ProjectController());
  TeamMemberController teamMemberController = Get.put(TeamMemberController());
  bool isTaked = false;
  String name = "";
  String desc = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("importance", style: AppTextStyles.header3),
                AppSpaces.horizontalSpace10,
                DropdownButton<String>(
                  icon: const Icon(Icons.label_important_outline_rounded),
                  dropdownColor: HexColor.fromHex("#181a1f"),
                  style: AppTextStyles.header3,
                  value: selectedDashboardOption.toString(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDashboardOption = int.parse(newValue!);
                    });
                  },
                  items:
                      importancelist.map<DropdownMenuItem<String>>((int num) {
                    return DropdownMenuItem<String>(
                      value: num.toString(),
                      child: Text(num.toString()),
                    );
                  }).toList(),
                )
              ],
            ),
            AppSpaces.verticalSpace10,

            AppSpaces.verticalSpace10,
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ColorSelectionDialog(
                          onSelectedColorChanged: handleColorChanged,
                          initialColor: color,
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor.fromHex(color)),
                  ),
                ),
                AppSpaces.horizontalSpace20,
                Expanded(
                  child: LabelledFormInput(
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (isTaked) {
                          return "Please use another taskName";
                        }
                      }
                      return null;
                    },
                    onClear: () {
                      setState(() {
                        name = "";
                        _taskNameController.text = "";
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    label: "Name",
                    readOnly: false,
                    autovalidateMode: AutovalidateMode.always,
                    placeholder: "Task Name ....",
                    keyboardType: "text",
                    controller: _taskNameController,
                    obscureText: false,
                  ),
                ),
              ],
            ),
            AppSpaces.verticalSpace20,
            LabelledFormInput(
              validator: (p0) {
                if (p0 == " ") {
                  return "description cannot be empy spaces";
                }
                return null;
              },
              onChanged: (p0) {
                setState(() {
                  desc = p0;
                });
              },
              onClear: () {
                setState(() {
                  desc = "";
                  _taskDescController.text = "";
                });
              },
              label: "Description",
              readOnly: false,
              autovalidateMode: AutovalidateMode.always,
              placeholder: "Task Description ....",
              keyboardType: "text",
              controller: _taskDescController,
              obscureText: false,
            ),
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              NewSheetGoToCalendarWidget(
                selectedDay: startDate,
                onSelectedDayChanged: handleStartDayChanged,
                cardBackgroundColor: HexColor.fromHex("7DBA67"),
                textAccentColor: HexColor.fromHex("A9F49C"),
                value: formatDateTime(startDate),
                label: 'Start Date',
              ),
              NewSheetGoToCalendarWidget(
                onSelectedDayChanged: handleDueDayChanged,
                selectedDay: dueDate,
                cardBackgroundColor: HexColor.fromHex("BA67A3"),
                textAccentColor: HexColor.fromHex("BA67A3"),
                value: "1",
                label: 'Due Date',
              )
            ]),
            // Spacer(),
            AppSpaces.verticalSpace20,
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              AddSubIcon(
                scale: 1,
                color: AppColors.primaryAccentColor,
                callback: _addProject,
              ),
            ])
          ]),
        ),
      ]),
    );
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd h:mma').format(dateTime);
    }
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.color = selectedColor;
    });
  }

  void handleDueDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.startDate = selectedDay;
    });
  }

  void handleStartDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.dueDate = selectedDay;
    });
  }

  void _addProject() {}
  // void _addProject() async {
  //   if (widget.taskType == "userTask") {
  //     StatusController statusController = Get.put(StatusController());
  //     StatusModel statusModel =
  //         await statusController.getStatusByName(status: "notDone");
  //     DocumentReference? taskfatherid;
  //     if (widget.fathertask != null) {
  //       DocumentSnapshot documentReference = await statusController.getDocById(
  //           reference: usersTasksRef, id: widget.fathertask!.id);
  //       taskfatherid = documentReference.reference;
  //     }
  //     UserTaskModel userTaskModel = UserTaskModel(
  //         userIdParameter: firebaseAuth.currentUser!.uid,
  //         folderIdParameter: widget.userTaskCategoryModel!.id,
  //         taskFatherIdParameter: taskfatherid,
  //         descriptionParameter: desc,
  //         idParameter: usersTasksRef.doc().id,
  //         nameParameter: name,
  //         statusIdParameter: statusModel.id,
  //         importanceParameter: selectedDashboardOption!,
  //         createdAtParameter: DateTime.now(),
  //         updatedAtParameter: DateTime.now(),
  //         startDateParameter: startDate,
  //         endDateParameter: dueDate);
  //     userTaskController.addUserTask(userTaskModel: userTaskModel);
  //   } else if (widget.taskType == "mainTask") {
  //   } else if (widget.taskType == "subTask") {}
  // }
}

class BottomSheetIcon extends StatelessWidget {
  final IconData icon;
  const BottomSheetIcon({
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      iconSize: 32,
      onPressed: null,
    );
  }
}
