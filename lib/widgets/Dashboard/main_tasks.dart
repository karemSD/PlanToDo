import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Dashboard/search_bar_animation.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/controllers/user_task_controller.dart';
import 'package:mytest/models/team/Project_main_task_Model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import '../../BottomSheets/bottom_sheets.dart';
import '../../Values/values.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/manger_controller.dart';
import '../../controllers/projectController.dart';
import '../../controllers/project_main_task_controller.dart';
import '../../controllers/statusController.dart';
import '../../controllers/userController.dart';
import '../../models/User/User_model.dart';
import '../../models/User/User_task_Model.dart';
import '../../models/statusmodel.dart';
import '../../models/team/Manger_model.dart';
import '../../models/team/Project_model.dart';
import '../../pages/home.dart';

import '../../widgets/Navigation/app_header.dart';
import '../Snackbar/custom_snackber.dart';
import 'create_main_task.dart';
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

class MainTaskScreen extends StatefulWidget {
  MainTaskScreen({Key? key, required this.projectId}) : super(key: key);
  // ProjectModel projectModel;
  String projectId;
  @override
  State<MainTaskScreen> createState() => _MainTaskScreenState();
}

class _MainTaskScreenState extends State<MainTaskScreen> {
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
          updatedIsManager = false;
          print(user.id + "/////" + AuthService.instance. firebaseAuth.currentUser!.uid);
        } else {
          updatedIsManager = true;
        }
        print(updatedIsManager);
        isManager.value = updatedIsManager;
        // Update the state and trigger a rebuild
        // setState(() {
        //   isManager = updatedIsManager;
        // });
      });
    });
  }

  // bool isManager = false;
  RxBool isManager = false.obs;

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
              title: "Main tasks",
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
          SizedBox(
            height: 20,
          ),
          StreamBuilder<DocumentSnapshot<ProjectModel>>(
            stream:
                ProjectController().getProjectByIdStream(id: widget.projectId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ProjectModel projectModel = snapshot.data!.data()!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(projectModel.name!,
                            style: AppTextStyles.header2_2),
                        Text(projectModel!.description!,
                            style: AppTextStyles.header2_2),
                      ],
                    ),
                  ),
                );
              }
              if (!snapshot.hasData) {}
              return CircularProgressIndicator();
            },
          ),
          SizedBox(
            height: 20,
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
                stream: ProjectMainTaskController()
                    .getProjectMainTasksStream(projectId: widget.projectId),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<ProjectMainTaskModel>>
                        snapshot) {
                  if (snapshot.hasData) {
                    int taskCount = snapshot.data!.docs.length;
                    List<ProjectMainTaskModel> list = [];
                    if (taskCount > 0) {
                      if (search.isNotEmpty) {
                        snapshot.data!.docs.forEach((element) {
                          ProjectMainTaskModel taskCategoryModel =
                              element.data();
                          if (taskCategoryModel.name!
                              .toLowerCase()
                              .contains(search)) {
                            list.add(taskCategoryModel);
                          }
                        });
                      } else {
                        snapshot.data!.docs.forEach((element) {
                          ProjectMainTaskModel taskCategoryModel =
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
                          return MainTaskProgressCard(
                            taskModel: list[index],
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
                      "No Main tasks found",
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
    showAppBottomSheet(CreateUserTask(
      addLateTask: (
          {required int priority,
          required String taskName,
          required DateTime startDate,
          required DateTime dueDate,
          required String? desc,
          required String color}) async {},
      isUserTask: false,
      addTask: (
          {required color,
          required desc,
          required dueDate,
          required priority,
          required startDate,
          required taskName}) async {
        if (startDate.isAfter(dueDate) || startDate.isAtSameMomentAs(dueDate)) {
          CustomSnackBar.showError("start date cannot be after end date");
          return;
        }

        try {
          StatusController statusController = Get.put(StatusController());
          StatusModel statusModel =
              await statusController.getStatusByName(status: statusNotStarted);

          ProjectMainTaskModel userTaskModel = ProjectMainTaskModel(
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
          await ProjectMainTaskController()
              .addProjectMainTask(projectMainTaskModel: userTaskModel);
        } catch (e) {
          CustomSnackBar.showError(e.toString());
        }
      },
      checkExist: ({required String name}) async {
        return TopController().existByTow(
            reference: projectMainTasksRef,
            value: projectIdK,
            field: widget.projectId,
            value2: name,
            field2: nameK);
      },
      isEditMode: false,
    ));
  }
}
