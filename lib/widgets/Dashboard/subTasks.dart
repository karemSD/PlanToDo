import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Dashboard/search_bar_animation.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/project_sub_task_controller.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/controllers/user_task_controller.dart';
import 'package:mytest/models/team/Project_main_task_Model.dart';
import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/models/team/waitingSubTasksModel.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/services/types.dart';
import 'package:mytest/widgets/Dashboard/subTask.dart';
import '../../BottomSheets/bottom_sheets.dart';
import '../../Values/values.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/manger_controller.dart';
import '../../controllers/projectController.dart';
import '../../controllers/project_main_task_controller.dart';
import '../../controllers/statusController.dart';
import '../../controllers/teamController.dart';
import '../../controllers/waitingSubTasks.dart';
import '../../models/User/User_model.dart';
import '../../models/User/User_task_Model.dart';
import '../../models/statusmodel.dart';
import '../../models/team/Manger_model.dart';
import '../../models/team/Project_model.dart';
import '../../models/team/Project_sub_task_Model.dart';
import '../../models/team/Team_model.dart';
import '../../pages/home.dart';

import '../../services/auth_service.dart';
import '../../services/notification_service.dart';
import '../../widgets/Navigation/app_header.dart';
import '../Snackbar/custom_snackber.dart';
import 'create_main_task.dart';
import 'create_sub_task.dart';
import 'create_user_task.dart';
import 'dashboard_add_icon.dart';
import 'main_task.dart';

enum TaskSortOption {
  name,
  createDate,
  updatedDate,
  startDate,
  endDate,
  importance
  // Add more sorting options if needed
}

class SubTaskScreen extends StatefulWidget {
  SubTaskScreen({Key? key, required this.mainTaskId, required this.projectId})
      : super(key: key);
  // ProjectModel projectModel;
  String mainTaskId;
  String projectId;
  @override
  State<SubTaskScreen> createState() => _SubTaskScreenState();
}

class _SubTaskScreenState extends State<SubTaskScreen> {
  TextEditingController editingController = TextEditingController();
  String search = "";
  TaskSortOption selectedSortOption = TaskSortOption.name;
  int crossAxisCount = 2; // Variable for crossAxisCount

  String _getSortOptionText(TaskSortOption option) {
    switch (option) {
      case TaskSortOption.name:
        return 'Name';
      case TaskSortOption.updatedDate:
        return 'Updated Date';
      case TaskSortOption.createDate:
        return 'Created Date';
      case TaskSortOption.startDate:
        return 'Start Date';
      case TaskSortOption.endDate:
        return 'End Date';
      case TaskSortOption.importance:
        return 'Importance';
      // Add cases for more sorting options if needed
      default:
        return '';
    }
  }

  @override
  void initState() {
    ismanagerStream();
    super.initState();
  }

  ismanagerStream() async {
    print("1234");
    ProjectModel? projectModel =
        await ProjectController().getProjectById(id: widget.projectId);
    Stream<DocumentSnapshot<ManagerModel>> managerModelStream =
        ManagerController().getMangerByIdStream(id: projectModel!.managerId);
    Stream<DocumentSnapshot<UserModel>> userModelStream;

    StreamSubscription<DocumentSnapshot<ManagerModel>> managerSubscription;
    StreamSubscription<DocumentSnapshot<UserModel>> userSubscription;

    managerSubscription = managerModelStream.listen((managerSnapshot) {
      ManagerModel manager = managerSnapshot.data()!;
      userModelStream =
          UserController().getUserWhereMangerIsStream(mangerId: manager.id);
      userSubscription = userModelStream.listen((userSnapshot) {
        UserModel user = userSnapshot.data()!;
        bool updatedIsManager;
        if (user.id != AuthService.instance. firebaseAuth.currentUser!.uid) {
          print(user.id + "/////" + AuthService.instance. firebaseAuth.currentUser!.uid);
          updatedIsManager = false;
        } else {
          print(user.id + "/////" + AuthService.instance. firebaseAuth.currentUser!.uid);
          updatedIsManager = true;
        }
        print(updatedIsManager);
        // Update the state and trigger a rebuild
        isManager.value = updatedIsManager;
      });
    });
  }

  RxBool isManager = false.obs;
  bool sortAscending = true; // Variable for sort order
  void toggleSortOrder() {
    setState(() {
      sortAscending = !sortAscending; // Toggle the sort order
    });
  }

  void toggleCrossAxisCount() {
    setState(() {
      crossAxisCount =
          crossAxisCount == 2 ? 1 : 2; // Toggle the crossAxisCount value
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => Visibility(
          visible: isManager.value,
          child: DashboardAddButton(
            iconTapped: (() {
              _createTask2();
            }),
          ),
        ),
      ),
      backgroundColor: HexColor.fromHex("#181a1f"),
      body: Column(
        children: [
          TextButton(
              onPressed: () {
                Get.to(NotificationScreen());
              },
              child: Text("gome")),
          SafeArea(
            child: TaskezAppHeader(
              title: "Sub tasks",
              widget: MySearchBarWidget(
                editingController: editingController,
                onChanged: (String value) {
                  setState(() {
                    search = value;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<TaskSortOption>(
                  value: selectedSortOption,
                  onChanged: (TaskSortOption? newValue) {
                    setState(() {
                      selectedSortOption = newValue!;
                      // Implement the sorting logic here
                    });
                  },
                  items: TaskSortOption.values.map((TaskSortOption option) {
                    return DropdownMenuItem<TaskSortOption>(
                      value: option,
                      child: Text(
                        _getSortOptionText(option),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }).toList(),

                  // Add extra styling
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    size: 35,
                  ),
                  underline: const SizedBox(),
                ),
              ),
              IconButton(
                icon: Icon(
                  sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  color: Colors.white,
                ),
                onPressed: toggleSortOrder, // Toggle the sort order
              ),
              IconButton(
                icon: const Icon(
                  Icons.grid_view,
                  color: Colors.white,
                ),
                onPressed:
                    toggleCrossAxisCount, // Toggle the crossAxisCount value
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder(
                stream: ProjectSubTaskController()
                    .getSubTasksForAMainTaskStream(
                        mainTaskId: widget.mainTaskId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<ProjectSubTaskModel>>
                        snapshot) {
                  if (snapshot.hasData) {
                    int taskCount = snapshot.data!.docs.length;
                    List<ProjectSubTaskModel> list = [];
                    if (taskCount > 0) {
                      if (search.isNotEmpty) {
                        snapshot.data!.docs.forEach((element) {
                          ProjectSubTaskModel taskCategoryModel =
                              element.data();
                          if (taskCategoryModel.name!
                              .toLowerCase()
                              .contains(search)) {
                            list.add(taskCategoryModel);
                          }
                        });
                      } else {
                        snapshot.data!.docs.forEach((element) {
                          ProjectSubTaskModel taskCategoryModel =
                              element.data();
                          list.add(taskCategoryModel);
                        });
                      }
                      switch (selectedSortOption) {
                        case TaskSortOption.name:
                          list.sort((a, b) => a.name!.compareTo(b.name!));
                          break;
                        case TaskSortOption.createDate:
                          list.sort(
                              (a, b) => a.createdAt.compareTo(b.createdAt));
                          break;
                        case TaskSortOption.updatedDate:
                          list.sort(
                              (a, b) => b.updatedAt.compareTo(a.updatedAt));
                        case TaskSortOption.endDate:
                          list.sort((a, b) => b.endDate!.compareTo(a.endDate!));
                        case TaskSortOption.startDate:
                          list.sort(
                              (a, b) => b.startDate.compareTo(a.startDate));
                        case TaskSortOption.importance:
                          list.sort(
                              (a, b) => b.importance.compareTo(a.importance));
                          break;
                        // Add cases for more sorting options if needed
                      }
                      if (!sortAscending) {
                        list = list.reversed
                            .toList(); // Reverse the list for descending order
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              crossAxisCount, // Use the variable for crossAxisCount
                          mainAxisSpacing: 10,
                          mainAxisExtent: 290,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (_, index) {
                          return SubTaskCard(
                            task: list[index],
                            onPrimary: Colors.white,
                            primary: HexColor.fromHex(list[index].hexcolor),
                          );
                        },
                        itemCount: list.length,
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.lightMauveBackgroundColor,
                        backgroundColor: AppColors.primaryBackgroundColor,
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      "No Sub tasks found",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _createTask2() {
    print(widget.projectId);
    showAppBottomSheet(
        popAndShow: false,
        CreateSubTask(
          userTaskModel: null,
          projectId: widget.projectId,
          addTask: (
              {required color,
              required desc,
              required dueDate,
              required priority,
              required startDate,
              required taskName,
              required String userIdAssignedTo}) async {
            if (startDate.isAfter(dueDate) ||
                startDate.isAtSameMomentAs(dueDate)) {
              CustomSnackBar.showError("start date cannot be after end date");
              return;
            }
            ProjectMainTaskModel mainTask = await ProjectMainTaskController()
                .getProjectMainTaskById(id: widget.mainTaskId);
            if (!startDate.isAfter(mainTask.startDate) ||
                !dueDate.isBefore(mainTask.endDate!)) {
              throw Exception(
                  "sub task start and end date should be between start and end date of the main task");
            }
            UserModel userModel =
                await UserController().getUserById(id: userIdAssignedTo);
            StatusController statusController = Get.put(StatusController());
            StatusModel statusModel = await statusController.getStatusByName(
                status: statusNotStarted);
            ProjectModel? projectModel =
                await ProjectController().getProjectById(id: widget.projectId);
            print(projectModel!.teamId!);
            String s = projectModel.teamId!;
            TeamModel teamModel = await TeamController().getTeamById(id: s);
            TeamMemberModel teamMemberModel = await TeamMemberController()
                .getMemberByTeamIdAndUserId(
                    teamId: teamModel.id, userId: userIdAssignedTo);
            ProjectSubTaskModel projectSubTaskModel = ProjectSubTaskModel(
                assignedToParameter: teamMemberModel.id,
                mainTaskIdParameter: widget.mainTaskId,
                hexColorParameter: color,
                projectIdParameter: widget.projectId,
                descriptionParameter: desc!,
                idParameter: projectMainTasksRef.doc().id,
                nameParameter: taskName,
                statusIdParameter: statusModel.id,
                importanceParameter: priority,
                createdAtParameter: DateTime.now(),
                updatedAtParameter: DateTime.now(),
                startDateParameter: startDate,
                endDateParameter: dueDate);
            // await ProjectSubTaskController()
            //     .addProjectSubTask(projectsubTaskModel: userTaskModel);
            String waitingid = watingSubTasksRef.doc().id;
            WaitingSubTaskModel waitingSubTaskModel = WaitingSubTaskModel(
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                id: waitingid,
                projectSubTaskModel: projectSubTaskModel);
            WatingSubTasksController waitingSubTaskController =
                Get.put(WatingSubTasksController());
            print(teamMemberModel.id + "team member");
            bool overlapped = false;
            int over = 0;
            List<ProjectSubTaskModel> list = await ProjectSubTaskController()
                .getMemberSubTasks(memberId: teamMemberModel.id);
            for (ProjectSubTaskModel existingTask in list) {
              if (projectSubTaskModel.startDate
                      .isBefore(existingTask.endDate!) &&
                  projectSubTaskModel.endDate!
                      .isAfter(existingTask.startDate)) {
                overlapped = true;
                over += 1;
              }
            }
            if (overlapped) {
              final GlobalKey<NavigatorState> _navigatorKey =
                  GlobalKey<NavigatorState>();
              Get.defaultDialog(
                  title: "Task Time Error",
                  middleText:
                      "There is ${over} That start in this time \n for the assigned user \n Would you Like To assign the Task Any Way?",
                  onConfirm: () async {
                    await waitingSubTaskController.addWatingSubTask(
                        waitingSubTaskModel: waitingSubTaskModel);
                    FcmNotifications fcmNotifications =
                        Get.put(FcmNotifications());
                    await fcmNotifications.sendNotificationAsJson(
                        fcmTokens: userModel.tokenFcm,
                        title: "you have a task ",
                        data: {"id": waitingid},
                        body:
                            "the project ${projectModel.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
                        type: NotificationType.taskRecieved);
                    CustomSnackBar.showSuccess(
                        "task ${taskName} sended to member successfully");
                    Get.key.currentState!.pop();
                    Get.key.currentState!.pop();
                  },
                  onCancel: () {
                    // SystemNavigator.pop();
                    _navigatorKey.currentState?.pop();
                  },
                  navigatorKey: _navigatorKey);
            } else {
              await waitingSubTaskController.addWatingSubTask(
                  waitingSubTaskModel: waitingSubTaskModel);
              FcmNotifications fcmNotifications = Get.put(FcmNotifications());
              await fcmNotifications.sendNotificationAsJson(
                  fcmTokens: userModel.tokenFcm,
                  title: "you have a task ",
                  data: {"id": waitingid},
                  body:
                      "the project ${projectModel.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
                  type: NotificationType.taskRecieved);
              CustomSnackBar.showSuccess(
                  "task ${taskName} sended to member successfully");
              Get.key.currentState!.pop();
            }
            // await waitingSubTaskController.addWatingSubTask(
            //     waitingSubTaskModel: waitingSubTaskModel);
            // FcmNotifications fcmNotifications = Get.put(FcmNotifications());
            // await fcmNotifications.sendNotificationAsJson(
            //     fcmTokens: userModel.tokenFcm,
            //     title: "you have a task ",
            //     data: {"id": waitingid},
            //     body:
            //         "the project ${projectModel.name}. The task is titled ${projectSubTaskModel.name}. Please review the task details and take necessary action.",
            //     type: NotificationType.taskRecieved);
            // CustomSnackBar.showSuccess(
            //     "task ${taskName} sended to member successfully");
            // Get.key.currentState!.pop();
          },
          checkExist: ({required String name}) async {
            bool s;
            s = await TopController().existByTow(
                reference: projectSubTasksRef,
                value: widget.mainTaskId,
                field: mainTaskIdK,
                value2: name,
                field2: nameK);
            s = await TopController().existByTow(
                reference: watingSubTasksRef,
                value: widget.mainTaskId,
                field: "subTask.$mainTaskIdK",
                value2: name,
                field2: "subTask.$nameK");
            return s;
          },
          isEditMode: false,
        ));
  }
}
