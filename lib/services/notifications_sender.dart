import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mytest/controllers/project_sub_task_controller.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/models/task/UserTaskCategory_model.dart';
import 'package:mytest/models/team/Project_main_task_Model.dart';
import 'package:mytest/models/team/Project_sub_task_Model.dart';
import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/services/Notifications_Sender.dart';
import 'package:mytest/services/types.dart';

import '../constants/back_constants.dart';
import '../controllers/categoryController.dart';
import '../controllers/manger_controller.dart';
import '../controllers/projectController.dart';
import '../controllers/project_main_task_controller.dart';
import '../controllers/statusController.dart';
import '../controllers/topController.dart';
import '../controllers/user_task_controller.dart';
import '../firebase_options.dart';
import '../models/User/User_task_Model.dart';
import '../models/statusmodel.dart';
import '../models/team/Manger_model.dart';
import '../models/team/Project_model.dart';
import '../utils/back_utils.dart';
import 'auth_service.dart';
import 'collectionsrefrences.dart';
import 'notification_controller.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> sendMainTaskNotification(
    {required ProjectMainTaskModel task,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotifications fcmNotifications =
      Get.put(FcmNotifications(), permanent: true);
  if (!finished) {
    String title = started
        ? "main task ${task.name} has Started"
        : "${task.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Task ${task.name} has begun.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
        type: NotificationType.notification);
    return;
  }
  String title = started
      ? "main task ${task.name} has Ended"
      : "${task.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
    fcmTokens: token,
    title: title,
    body:
        "🚀 Task ${task.name} has Finished.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
    type: NotificationType.notification,
  );
}

Future<void> sendSubTaskNotification(
    {required ProjectSubTaskModel task,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotifications fcmNotifications =
      Get.put(FcmNotifications(), permanent: true);
  if (!finished) {
    String title = started
        ? "sub task ${task.name} has Started"
        : "${task.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Task ${task.name} has begun.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
        type: NotificationType.notification);
    return;
  }
  String title = started
      ? "sub task ${task.name} has Ended"
      : "${task.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
      fcmTokens: token,
      title: title,
      body:
          "🚀 Task ${task.name} has Finished.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
      type: NotificationType.memberTaskTimeFinished,
      data: {"id": task.id});
}

@pragma('vm:entry-point')
Future<void> sendTaskNotification(
    {required UserTaskModel task,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotifications fcmNotifications =
      Get.put(FcmNotifications(), permanent: true);
  if (!finished) {
    String title = started
        ? "${task.name} has Started"
        : "${task.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Task ${task.name} has begun.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
        type: NotificationType.notification);
    return;
  }
  String title =
      started ? "${task.name} has Ended" : "${task.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
      fcmTokens: token,
      title: title,
      body:
          "🚀 Task ${task.name} has Finished.📅 Deadline: ${task.endDate}. ⭐Priority: ${task.importance}.",
      data: {"id": task.id},
      type: NotificationType.userTaskTimeFinished);
}

@pragma('vm:entry-point')
Future<void> sendProjectNotification(
    {required ProjectModel project,
    required bool started,
    required List<String> token,
    required bool finished}) async {
  FcmNotifications fcmNotifications =
      Get.put(FcmNotifications(), permanent: true);
  if (!finished) {
    String title = started
        ? "${project.name} has Started"
        : "${project.name} is going to start in 5 Minutes";
    await fcmNotifications.sendNotificationAsJson(
        fcmTokens: token,
        title: title,
        body:
            "🚀 Project ${project.name} has begun.📅 Deadline: ${project.endDate}. ⭐",
        type: NotificationType.notification);
    return;
  }
  String title = started
      ? "${project.name} has Ended"
      : "${project.name} time has finished";
  await fcmNotifications.sendNotificationAsJson(
      fcmTokens: token,
      title: title,
      body:
          "🚀 Task ${project.name} has Finished.📅 Deadline: ${project.endDate}. ",
      type: NotificationType.notification);
}

@pragma('vm:entry-point')
Future<void> checkProjectsToSendNotificationToManager() async {
  ManagerController managerController = Get.put(ManagerController());
  UserTaskController userTaskController = Get.put(UserTaskController());
  String userId = FirebaseAuth.instance.currentUser!.uid;
  if (await userTaskController.existByOne(
    collectionReference: managersRef,
    field: userIdK,
    value: userId,
  )) {
    List<ManagerModel> managerList = [];
    managerList = await managerController.getUserManager(userId: userId);
    managerList.forEach((element) async {
      await checkProjectsForManager(managerId: element.id);
    });
  }
}

@pragma('vm:entry-point')
Future<void> checkProjectsForManager({required String managerId}) async {
  ProjectController projectController = Get.put(ProjectController());
  String token = await getFcmToken();
  if (await projectController.existByOne(
        collectionReference: projectsRef,
        field: managerIdK,
        value: managerId,
      ) ==
      false) {
    return;
  }
  List<ProjectModel?>? projectList =
      await ProjectController().getProjectsOfManager(mangerId: managerId);
  await checkProjectsToSendNotification(
      ismanager: true, projectList: projectList);
}

@pragma('vm:entry-point')
Future<void> checkTaskToSendNotification() async {
  UserTaskController userTaskController = Get.put(UserTaskController());
  StatusController statusController = Get.put(StatusController());
  String token = await getFcmToken();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  if (await userTaskController.existByOne(
        collectionReference: usersTasksRef,
        field: userIdK,
        value: FirebaseAuth.instance.currentUser!.uid,
      ) ==
      false) {
    print("hello");
    return;
  }
  StatusModel statusDoneModel =
      await statusController.getStatusByName(status: statusDone);
  StatusModel statusNotDoneModel =
      await statusController.getStatusByName(status: statusNotDone);
  StatusModel statusNotStartedModel =
      await statusController.getStatusByName(status: statusNotStarted);
  StatusModel statusDoingModel =
      await statusController.getStatusByName(status: statusDoing);
  List<UserTaskModel> userTaskList =
      await userTaskController.getUserTasks(userId: userId);
  for (UserTaskModel element in userTaskList) {
    DateTime taskStartdate = firebaseTime(element.startDate);
    DateTime? taskEnddate = firebaseTime(element.endDate!);

    DateTime now = DateTime.now();

    if (taskStartdate.day == now.day &&
        taskStartdate.month == now.month &&
        taskStartdate.year == now.year) {
      DateTime firebaseNow = firebaseTime(DateTime.now());
      print("start date" +
          taskStartdate.toString() +
          "end date" +
          taskEnddate.toString());
      if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
          element.statusId == statusNotStartedModel.id) {
        await userTaskController.updateUserTask(
            isfromback: true,
            data: {statusIdK: statusDoingModel.id},
            id: element.id);
        await sendTaskNotification(
            task: element, started: true, token: [token], finished: false);
      }
      if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
          element.statusId == statusNotStartedModel.id) {
        await sendTaskNotification(
            task: element, started: false, token: [token], finished: false);
      }
      DocumentSnapshot documentSnapshot = await TopController()
          .getDocById(reference: usersTasksRef, id: element.id);
      bool isFather = await TopController().existByOne(
          collectionReference: usersTasksRef,
          value: documentSnapshot.reference,
          field: taskFatherIdK);
      if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
          element.statusId == statusDoingModel.id &&
          isFather == false) {
        await userTaskController.updateUserTask(
            isfromback: true,
            data: {statusIdK: statusNotDoneModel.id},
            id: element.id);
        await sendTaskNotification(
            task: element, started: false, token: [token], finished: true);
      } else if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
          element.statusId == statusDoingModel.id &&
          isFather == true) {
        bool isDone = true;
        List<UserTaskModel> childTasks = await UserTaskController()
            .getChildTasks(taskFatherId: documentSnapshot.reference);
        for (var childElement in childTasks) {
          UserTaskModel child = childElement;
          if (child.statusId == statusNotDoneModel.id) {
            isDone = false;
            break;
          }
        }
        if (isDone) {
          UserTaskController().updateUserTask(
            isfromback: true,
            data: {
              statusIdK: statusDoneModel.id,
            },
            id: element.id,
          );
          String title = "${element.name} has Ended";
          await FcmNotifications().sendNotificationAsJson(
              fcmTokens: [token],
              title: title,
              body: "🚀Task ${element.name} has Finished.📅.and got Done",
              data: {"id": element.id},
              type: NotificationType.userTaskTimeFinished);
        } else {
          UserTaskController().updateUserTask(
            isfromback: true,
            data: {
              statusIdK: statusNotDoneModel.id,
            },
            id: element.id,
          );
          String title = "${element.name} has Ended";
          await FcmNotifications().sendNotificationAsJson(
              fcmTokens: [token],
              title: title,
              body: "🚀Task ${element.name} has Finished.📅.and got not Done",
              data: {"id": element.id},
              type: NotificationType.userTaskTimeFinished);
        }
      }
    }
  }
}

@pragma('vm:entry-point')
void checkAuth(int x, Map<String, dynamic> map) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(/*() =>  */ AuthService()));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationController.initializeNotification();
  AuthService authSXervice = Get.put(AuthService());
  FirebaseAuth.instance.authStateChanges().listen(
    (User? user) async {
      if (user != null) {
        await checkTaskToSendNotification();
        await checkProjectMainTasksToSendNotificationToManager();
        await checkProjectMainTasksToSendNotificationToMembers();
        await checkSubTasksToSendNotification();
        await checkProjectsToSendNotificationToManager();
        await checkProjectsToSendNotificationToMember();
        print("logged in");
      } else {
        print("not logged in");
      }
    },
  );
}

checkProjectsToSendNotification(
    {required List<ProjectModel?>? projectList,
    required bool ismanager}) async {
  String token = await getFcmToken();
  StatusController statusController = Get.put(StatusController());
  StatusModel statusDoneModel =
      await statusController.getStatusByName(status: statusDone);
  StatusModel statusNotStartedModel =
      await statusController.getStatusByName(status: statusNotStarted);
  StatusModel statusNotDoneModel =
      await statusController.getStatusByName(status: statusNotDone);
  StatusModel statusDoingModel =
      await statusController.getStatusByName(status: statusDoing);
  if (projectList != null) {
    for (ProjectModel? element in projectList) {
      if (element != null) {
        DateTime taskStartdate = firebaseTime(element.startDate);
        DateTime? taskEnddate = firebaseTime(element.endDate!);
        DateTime now = DateTime.now();
        if (taskStartdate.day == now.day &&
            taskStartdate.month == now.month &&
            taskStartdate.year == now.year) {
          DateTime firebaseNow = firebaseTime(DateTime.now());
          if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusNotStartedModel.id) {
            await ProjectController().updateProject2(
                data: {statusIdK: statusDoingModel.id}, id: element.id);

            await sendProjectNotification(
                project: element,
                started: true,
                token: [token],
                finished: false);
          }
          if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
              element.statusId == statusNotDoneModel.id) {
            await sendProjectNotification(
                project: element,
                started: false,
                token: [token],
                finished: true);
          }

          if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusDoingModel.id) {
            bool isDone = true;
            List<ProjectMainTaskModel> list = await ProjectMainTaskController()
                .getProjectMainTasks(projectId: element.id);
            for (var element in list) {
              if (element.statusId == statusNotDoneModel.id) {
                isDone = false;
              }
            }

            if (isDone) {
              await ProjectController().updateProject2(
                  data: {statusIdK: statusDoneModel.id}, id: element.id);
            } else {
              await ProjectController().updateProject2(
                  data: {statusIdK: statusNotDoneModel.id}, id: element.id);
            }

            await sendProjectNotification(
                project: element,
                started: false,
                token: [token],
                finished: true);
          }
        }
      }
    }
  }
}

checkProjectsToSendNotificationToMember() async {
  if (await TeamMemberController().existByOne(
          collectionReference: teamMembersRef,
          value: userIdK,
          field: AuthService.instance.firebaseAuth.currentUser!.uid) ==
      false) {
    return;
  }
  List<ProjectModel?>? projectList = [];

  projectList = await ProjectController().getProjectsOfMemberWhereUserIs2(
      userId: AuthService.instance.firebaseAuth.currentUser!.uid);
  await checkProjectsToSendNotification(
      ismanager: false, projectList: projectList);
}

checkProjectMainTasksToSendNotificationToMembers() async {
  if (await TeamMemberController().existByOne(
          collectionReference: teamMembersRef,
          value: userIdK,
          field: AuthService.instance.firebaseAuth.currentUser!.uid) ==
      true) {
    List<ProjectModel?>? projectList = [];
    projectList = await ProjectController().getProjectsOfMemberWhereUserIs2(
        userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    await checkProjectMainTasksToSendNotifications(
        manager: false, projectList: projectList);
  }
}

checkProjectMainTasksToSendNotificationToManager() async {
  if (await TeamMemberController().existByOne(
          collectionReference: managersRef,
          value: userIdK,
          field: AuthService.instance.firebaseAuth.currentUser!.uid) ==
      true) {
    List<ProjectModel?>? projectList = [];
    projectList = await ProjectController().getProjectsOfUser(
        userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    await checkProjectMainTasksToSendNotifications(
        manager: true, projectList: projectList);
  }
}

checkProjectMainTasksToSendNotifications(
    {List<ProjectModel?>? projectList, required bool manager}) async {
  String token = await getFcmToken();
  StatusModel statusDoneModel =
      await StatusController().getStatusByName(status: statusDone);
  StatusController statusController = Get.put(StatusController());
  StatusModel statusNotStartedModel =
      await statusController.getStatusByName(status: statusNotStarted);
  StatusModel statusNotDoneModel =
      await statusController.getStatusByName(status: statusNotDone);
  StatusModel statusDoingModel =
      await statusController.getStatusByName(status: statusDoing);
  List<ProjectMainTaskModel> mainTasksList = [];
  if (projectList!.isNotEmpty) {
    for (ProjectModel? element in projectList) {
      if (element != null) {
        List<ProjectMainTaskModel> mainTasksListmini = [];
        mainTasksListmini = await ProjectMainTaskController()
            .getProjectMainTasks(projectId: element.id);
        mainTasksList.addAll(mainTasksListmini);
      }
      mainTasksList.forEach((element) async {
        DateTime taskStartdate = firebaseTime(element.startDate);
        DateTime? taskEnddate = firebaseTime(element.endDate!);

        DateTime now = DateTime.now();

        if (taskStartdate.day == now.day &&
            taskStartdate.month == now.month &&
            taskStartdate.year == now.year) {
          DateTime firebaseNow = firebaseTime(DateTime.now());
          print("start date" +
              taskStartdate.toString() +
              "end date" +
              taskEnddate.toString());
          if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusNotStartedModel.id) {
            if (manager) {
              await ProjectMainTaskController().updateMainTask(
                  isfromback: true,
                  data: {statusIdK: statusDoingModel.id},
                  id: element.id);
            }
            await sendMainTaskNotification(
                task: element, started: true, token: [token], finished: false);
          }
          if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
              element.statusId == statusNotDoneModel.id) {
            await sendMainTaskNotification(
                task: element, started: false, token: [token], finished: false);
          }

          if (taskEnddate.isAtSameMomentAs(firebaseNow) &&
              element.statusId == statusDoingModel.id) {
            bool isDone = true;
            List<ProjectSubTaskModel> subtasks =
                await ProjectSubTaskController()
                    .getSubTasksForAMainTask(mainTaskId: element.id);
            for (var element in subtasks) {
              if (element.statusId == statusNotDoneModel.id) {
                isDone = false;
              }
            }

            if (isDone) {
              await ProjectSubTaskController().updateSubTask(
                  isfromback: true,
                  data: {statusIdK: statusDoneModel.id},
                  id: element.id);
            } else {
              await ProjectSubTaskController().updateSubTask(
                  isfromback: true,
                  data: {statusIdK: statusNotDoneModel.id},
                  id: element.id);
            }

            await sendMainTaskNotification(
                task: element, started: false, token: [token], finished: true);
          }
        }
      });
    }
  }
}

checkSubTasksToSendNotification() async {
  StatusController statusController = Get.put(StatusController());
  TeamMemberController teamMemberController = Get.put(TeamMemberController());
  ProjectSubTaskController projectSubTaskController =
      Get.put(ProjectSubTaskController());
  String token = await getFcmToken();
  if (await teamMemberController.existByOne(
          collectionReference: teamMembersRef,
          value: userIdK,
          field: AuthService.instance.firebaseAuth.currentUser!.uid) ==
      true) {
    StatusModel statusDoneModel =
        await statusController.getStatusByName(status: statusDone);
    StatusModel statusNotStartedModel =
        await statusController.getStatusByName(status: statusNotStarted);
    StatusModel statusNotDoneModel =
        await statusController.getStatusByName(status: statusNotDone);
    StatusModel statusDoingModel =
        await statusController.getStatusByName(status: statusDoing);
    List<ProjectSubTaskModel> allsubtasklist = [];
    List<TeamMemberModel> list =
        await teamMemberController.getMemberWhereUserIs(
            userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    list.forEach((element) async {
      List<ProjectSubTaskModel> minisubtasklist = await projectSubTaskController
          .getMemberSubTasks(memberId: element.id);
      for (var subtask in minisubtasklist) {
        if (subtask.statusId == statusNotStartedModel.id) {
          allsubtasklist.add(subtask);
        }
      }
    });
    allsubtasklist.forEach((ProjectSubTaskModel element) async {
      DateTime taskStartdate = element.startDate;
      DateTime? taskEnddate = element.endDate;
      DateTime now = DateTime.now();
      if (taskStartdate.day == now.day &&
          taskStartdate.month == now.month &&
          taskStartdate.year == now.year) {
        DateTime firebaseNow = firebaseTime(DateTime.now());
        print("start date ${taskStartdate} end date$taskEnddate");
        if (taskStartdate.isAtSameMomentAs(firebaseNow) &&
            element.statusId == statusNotStartedModel.id) {
          await projectSubTaskController.updateSubTask(
              isfromback: true,
              data: {statusIdK: statusDoingModel.id},
              id: element.id);
          await sendSubTaskNotification(
              task: element, started: true, token: [token], finished: false);
        }
        if (taskStartdate.difference(firebaseNow).inMinutes == 5 &&
            element.statusId == statusNotStartedModel.id) {
          await sendSubTaskNotification(
              task: element, started: false, token: [token], finished: false);
        }

        if (taskEnddate!.isAtSameMomentAs(firebaseNow) &&
            element.statusId == statusDoingModel.id) {
          await ProjectSubTaskController().updateSubTask(
              isfromback: true,
              data: {statusIdK: statusNotDoneModel.id},
              id: element.id);
          await sendSubTaskNotification(
              task: element, started: false, token: [token], finished: true);
        }
      }
    });
  }
}
