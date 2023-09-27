import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mytest/widgets/Dashboard/select_color_dialog.dart';

import '../../Values/values.dart';
import '../../constants/back_constants.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/statusController.dart';
import '../../controllers/topController.dart';
import '../../controllers/user_task_controller.dart';
import '../../models/User/User_task_Model.dart';
import '../../models/statusmodel.dart';
import '../../models/task/UserTaskCategory_model.dart';
import '../../models/team/Task_model.dart';
import '../../models/team/TeamMembers_model.dart';

import '../../services/collectionsrefrences.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../Forms/form_input_with _label.dart';
import '../Snackbar/custom_snackber.dart';
import '../User/new_sheet_goto_calender.dart';
import '../add_sub_icon.dart';

class CheckboxController extends GetxController {
  RxBool isChecked = false.obs;

  void toggleCheckbox() {
    isChecked.toggle();
  }
}

// ignore: must_be_immutable
class CreateUserTask extends StatefulWidget {
  CreateUserTask(
      {required this.addTask,
      Key? key,
      this.userTaskModel,
      required this.addLateTask,
      required this.isEditMode,
      required this.checkExist,
      required this.isUserTask})
      : super(key: key);
  final bool isEditMode;
  TaskClass? userTaskModel;
  final bool isUserTask;
  final Future<void> Function(
      {required int priority,
      required String taskName,
      required DateTime startDate,
      required DateTime dueDate,
      required String? desc,
      required String color}) addLateTask;
  final Future<void> Function(
      {required int priority,
      required String taskName,
      required DateTime startDate,
      required DateTime dueDate,
      required String? desc,
      required String color}) addTask;
  final Future<bool> Function({required String name}) checkExist;

  @override
  State<CreateUserTask> createState() => _CreateUserTaskState();
}

class _CreateUserTaskState extends State<CreateUserTask> {
  final CheckboxController checkboxController = Get.put(CheckboxController());

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<int> importancelist = [
    1,
    2,
    3,
    4,
    5,
  ];
  int? selectedDashboardOption;
  @override
  void initState() {
    super.initState();

    if (widget.isEditMode && widget.userTaskModel != null) {
      _taskNameController.text = widget.userTaskModel!.name!;
      _taskDescController.text = widget.userTaskModel!.description!;
      name = widget.userTaskModel!.name!;
      desc = widget.userTaskModel!.description!;
      startDate = widget.userTaskModel!.startDate;
      dueDate = widget.userTaskModel!.endDate!;
      print(startDate.toString());
      selectedDashboardOption = importancelist.singleWhere(
          (element) => element == widget.userTaskModel!.importance);
      color = widget.userTaskModel!.hexcolor;
      formattedStartDate = formatDateTime(startDate);
      formattedDueDate = formatDateTime(dueDate);
    } else {
      selectedDashboardOption = importancelist[0];
      formattedStartDate = formatDateTime(startDate);
      formattedDueDate = formatDateTime(dueDate);
    }
  }

  String formattedStartDate = "";
  String formattedDueDate = "";
  Future onChanged(String value) async {
    name = value;
    print("hellli");
    if (name.isNotEmpty) {
      isTaked = await widget.checkExist(name: name);

      print(isTaked);
      setState(() {
        isTaked;
      });
    }
  }

  DateTime startDate = DateTime.now();
  String color = "#FDA7FF";
  DateTime dueDate = DateTime.now();
  UserTaskController userTaskController = Get.put(UserTaskController());
  TaskCategoryController taskCategoryController =
      Get.put(TaskCategoryController());

  bool isTaked = false;
  String name = "";
  String desc = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
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
                  Text("importance", style: AppTextStyles.header2),
                  AppSpaces.horizontalSpace10,
                  DropdownButton<String>(
                    icon: Icon(Icons.label_important_outline_rounded),
                    dropdownColor: HexColor.fromHex("#181a1f"),
                    style: AppTextStyles.header2,
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
              Visibility(
                visible:
                    (widget.isEditMode == false && widget.isUserTask == true),
                child: Row(
                  children: [
                    Text("checked already?", style: AppTextStyles.header2),
                    Obx(
                      () => Checkbox(
                        value: checkboxController.isChecked.value,
                        onChanged: (value) {
                          checkboxController.toggleCheckbox();
                          print(checkboxController.isChecked.value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                        if (value!.isEmpty) {
                          return "pls enter name";
                        }
                        if (value.isNotEmpty) {
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
                      onChanged: (String name) async {
                        await onChanged(name);
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
                  desc = p0;
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
                  value: formattedStartDate,
                  label: 'Start Date',
                ),
                NewSheetGoToCalendarWidget(
                  onSelectedDayChanged: handleDueDayChanged,
                  selectedDay: dueDate,
                  cardBackgroundColor: HexColor.fromHex("BA67A3"),
                  textAccentColor: HexColor.fromHex("BA67A3"),
                  value: formattedDueDate,
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
                  callback: () async {
                    if (formKey.currentState!.validate()) {
                      await _addUserTask();
                    }
                  },
                ),
              ])
            ]),
          ),
        ]),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM h:mma').format(dateTime);
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
      dueDate = selectedDay;
      formattedDueDate = formatDateTime(dueDate);
    });
  }

  void handleStartDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      print(selectedDay.toString() + "the selected day");
      startDate = selectedDay;
      formattedStartDate = formatDateTime(startDate);
    });
  }

  Future _addUserTask() async {
    if (formKey.currentState!.validate()) {
      print("late");
      if (widget.isUserTask == true &&
          widget.isEditMode == false &&
          checkboxController.isChecked.value == true) {
        await widget.addLateTask(
          color: color,
          desc: desc,
          dueDate: dueDate,
          priority: selectedDashboardOption!,
          startDate: startDate,
          taskName: name,
        );
        return;
      }
      await widget.addTask(
        color: color,
        desc: desc,
        dueDate: dueDate,
        priority: selectedDashboardOption!,
        startDate: startDate,
        taskName: name,
      );
    }
  }
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
// StreamBuilder<QuerySnapshot<TeamMemberModel>>(
//                             stream: TeamMemberController()
//                                 .getMembersInTeamIdStream(teamId: team.id),
//                             builder: (context, snapshotMembers) {
//                               List<String> listIds = [];
//                               if (snapshotMembers.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return CircularProgressIndicator();
//                               }
//                               for (var member in snapshotMembers.data!.docs) {
//                                 listIds.add(member.data().userId);
//                               }
//                               return StreamBuilder<QuerySnapshot<UserModel>>(
//                                   stream: UserController()
//                                       .getUsersWhereInIdsStream(
//                                           usersId: listIds),
//                                   builder: (context, snapshotUsers) {
//                                     if (snapshotUsers.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return CircularProgressIndicator();
//                                     }

//                                     List<UserModel> users = [];
//                                     for (var element
//                                         in snapshotUsers.data!.docs) {
//                                       users.add(element.data());
//                                     }
//                                     return TeamStory(
//                                         onTap: () {
//                                           print("objectsdsad");
                                          
//                                           Get.to(() =>
//                                               ShowTeamMembers(teamModel: team));
//                                         },
//                                         teamModel: team,
//                                         users: users,
//                                         teamTitle:
//                                             snapshotTeam.data!.data()!.name!,
//                                         numberOfMembers: snapshotUsers
//                                             .data!.docs.length
//                                             .toString(),
//                                         noImages: snapshotUsers
//                                             .data!.docs.length
//                                             .toString());
//                                   });
//                             }),