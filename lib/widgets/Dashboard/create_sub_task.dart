import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/team/Project_model.dart';
import 'package:mytest/widgets/Dashboard/select_color_dialog.dart';
import 'package:mytest/widgets/Dashboard/select_member_for_sub_task.dart';

import '../../Values/values.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/projectController.dart';
import '../../controllers/teamController.dart';
import '../../controllers/user_task_controller.dart';
import '../../models/User/User_model.dart';
import '../../models/team/Project_sub_task_Model.dart';
import '../../models/team/Team_model.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../Forms/form_input_with _label.dart';
import '../Snackbar/custom_snackber.dart';
import '../User/inactive_employee_card_sub_task.dart';
import '../User/new_sheet_goto_calender.dart';
import '../add_sub_icon.dart';
import '../inactive_employee_card.dart';


// ignore: must_be_immutable
class CreateSubTask extends StatefulWidget {
  CreateSubTask({
    required this.addTask,
    Key? key,
    this.userTaskModel,
    required this.isEditMode,
    required this.checkExist,
    required this.projectId,
  }) : super(key: key);
  final bool isEditMode;
  ProjectSubTaskModel? userTaskModel;
  String projectId;
  final Future<void> Function(
      {required int priority,
      required String taskName,
      required DateTime startDate,
      required DateTime dueDate,
      required String? desc,
      required String color,
      required String userIdAssignedTo}) addTask;
  final Future<bool> Function({required String name}) checkExist;

  @override
  State<CreateSubTask> createState() => _CreateSubTaskState();
}

class _CreateSubTaskState extends State<CreateSubTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? assignedToUserId;
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
      inisiateUserId(memberId: widget.userTaskModel!.assignedTo);
      _taskNameController.text = widget.userTaskModel!.name!;
      _taskDescController.text = widget.userTaskModel!.description!;
      name = widget.userTaskModel!.name!;
      desc = widget.userTaskModel!.description!;
      startDate = widget.userTaskModel!.startDate;
      dueDate = widget.userTaskModel!.endDate!;
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

  Future<void> inisiateUserId({required memberId}) async {
    UserModel userModel =
        await UserController().getUserWhereMemberIs(memberId: memberId);
    setState(() {
      assignedToUserId = userModel.id;
    });
  }

  onSelectedUserChanged({required UserModel? userModel}) {
    setState(() {
      print(userModel!.userName);
      assignedToUserId = userModel.id;
    });
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
              if (assignedToUserId != null)
                StreamBuilder<DocumentSnapshot<UserModel>>(
                  stream:
                      UserController().getUserByIdStream(id: assignedToUserId!),
                  builder: (context, snapshot) {
                    UserModel? userModel = snapshot.data?.data()!;
                    if (snapshot.hasData) {
                      return InactiveEmployeeCardSubTask(
                        onTap: () async {
                          ProjectModel? projectModel = await ProjectController()
                              .getProjectById(id: widget.projectId);
                          TeamModel? teamModel = await TeamController()
                              .getTeamById(id: projectModel!.teamId!);
                          Get.to(SearchForMembersSubTask(
                            userModel: userModel,
                            teamModel: teamModel,
                            onSelectedUserChanged: onSelectedUserChanged,
                          ));
                        },
                        color: Colors.white,
                        userImage: userModel!.imageUrl!,
                        userName: userModel.userName ?? "no user name",
                        bio: userModel.bio ?? "no bio",
                      );
                    }
                    return InkWell(
                      onTap: () {
                        print("object");
                        // ProjectModel? projectModel = await ProjectController()
                        //     .getProjectById(id: widget.projectId);
                        // TeamModel teamModel = await TeamController()
                        //     .getTeamOfProject(project: projectModel!);
                        // Get.to(SearchForMembersSubTask(
                        //   teamModel: teamModel,
                        // ));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 80,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'Please Select A member ',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.4,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

              if (assignedToUserId == null)
                InkWell(
                  onTap: () async {
                    print(widget.projectId);
                    ProjectModel? projectModel = await ProjectController()
                        .getProjectById(id: widget.projectId);
                    print(projectModel!.teamId!);
                    TeamModel teamModel = await TeamController()
                        .getTeamById(id: projectModel!.teamId!);
                    Get.to(SearchForMembersSubTask(
                      onSelectedUserChanged: onSelectedUserChanged,
                      userModel: null,
                      teamModel: teamModel,
                    ));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        'Please Select A member ',
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.4,
                        ),
                      ),
                    ),
                  ),
                ),
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
                  callback: () {
                    if (formKey.currentState!.validate()) {
                      if (assignedToUserId == null) {
                        CustomSnackBar.showError(
                            "please choose a member to assign the task to");
                        return;
                      }
                      widget.addTask(
                          color: color,
                          priority: selectedDashboardOption!,
                          taskName: name,
                          desc: desc,
                          dueDate: dueDate,
                          startDate: startDate,
                          userIdAssignedTo: assignedToUserId!);
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

  // void _addUserTask() async {
  //   if (formKey.currentState!.validate()) {
  //     await widget.addTask(
  //       color: color,
  //       desc: desc,
  //       dueDate: dueDate,
  //       priority: selectedDashboardOption!,
  //       startDate: startDate,
  //       taskName: name,
  //     );
  //   }
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