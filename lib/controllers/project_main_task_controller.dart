import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/project_sub_task_controller.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/services/collectionsrefrences.dart';

import '../constants/app_constans.dart';
import '../constants/back_constants.dart';
import '../models/team/Project_main_task_Model.dart';
import '../models/team/Project_model.dart';
import '../models/team/Project_sub_task_Model.dart';
import '../widgets/Snackbar/custom_snackber.dart';
import 'taskController.dart';

class ProjectMainTaskController extends ProjectAndTaskController {
  Future<ProjectMainTaskModel> getProjectMainTaskById(
      {required String id}) async {
    DocumentSnapshot mainTaskDoc =
        await getDocById(reference: projectMainTasksRef, id: id);
    return mainTaskDoc.data() as ProjectMainTaskModel;
  }

  Stream<DocumentSnapshot<ProjectMainTaskModel>> getProjectMainTaskByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: projectMainTasksRef, id: id);
    return stream.cast<DocumentSnapshot<ProjectMainTaskModel>>();
  }

  Future<ProjectMainTaskModel> getProjectMainTaskByName(
      {required String name, required String projectId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        name: name);
    return documentSnapshot.data() as ProjectMainTaskModel;
  }

  Stream<DocumentSnapshot<ProjectMainTaskModel>> getProjectMainTaskByNameStream(
      {required String name, required String projectId}) {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        name: name);
    return stream.cast<DocumentSnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasks(
      {required String projectId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectMainTasksRef,
        field: projectIdK,
        value: projectId);
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>> getProjectMainTasksStream(
      {required String projectId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
        reference: projectMainTasksRef, field: projectIdK, value: projectId));
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksForAStatus(
      {required String projectId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksForAStatusStream(
          {required String projectId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
    );
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<double> getPercentOfMainTasksInAProjectForAStatus(
      String status, String projectId) async {
    return await getPercentOfTasksForAStatus(
      reference: projectMainTasksRef,
      status: status,
      field: projectIdK,
      value: projectId,
    );
  }

  Stream<double> getPercentOfMainTasksInAProjectForAStatusStream(
      String status, String projectId) {
    return getPercentOfTasksForAStatusStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        status: status);
  }

  Future<double> getPercentOfMainTasksInAProjectForAStatusBetweenTowStartTime({
    required String status,
    required String projectId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: projectMainTasksRef,
        status: status,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Stream<double>
      getPercentOfMainTasksInAProjectForAStatusBetweenTowStartTimeStream({
    required String status,
    required String projectId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimesStream(
        reference: projectMainTasksRef,
        status: status,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksForAnImportance(
      {required String projectId, required int importance}) async {
    List<Object?>? list = await getTasksForAnImportance(
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
      importance: importance,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksForAnImportanceStream(
          {required String projectId, required int importance}) {
    Stream<QuerySnapshot> stream = getTasksForAnImportanceStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        importance: importance);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksStartInADayForAStatus(
      {required DateTime date,
      required String projectId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: projectMainTasksRef,
      date: date,
      field: projectIdK,
      value: projectId,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksStartInADayForAStatusStream(
          {required DateTime date,
          required String projectId,
          required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
        status: status,
        reference: projectMainTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<double>>
      getPercentagesForLastSevenDaysforaProjectMainTasksforAStatus(
          String projectId, DateTime startdate, String status) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksStartInASpecificTime(
      {required DateTime date, required String projectId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: projectMainTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksStartInASpecificTimeStream(
          {required DateTime date, required String projectId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: projectMainTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<List<ProjectMainTaskModel>> getProjectMainTasksStartBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String projectId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: projectMainTasksRef,
      field: projectIdK,
      value: projectId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<ProjectMainTaskModel>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getCommonMainTasksBetweenTwoMembersStream({
    required String projectId,
    required String firstMember,
    required String secondMember,
  }) async* {
    List<ProjectSubTaskModel> firstMemberMainTasks = [];
    List<ProjectSubTaskModel> secondMemberMainTasks = [];
    List<String> mainTasksIds = [];
    firstMemberMainTasks = await ProjectSubTaskController()
        .getMemberSubTasks(memberId: firstMember);

    secondMemberMainTasks = await ProjectSubTaskController()
        .getMemberSubTasks(memberId: secondMember);

    for (var firstMemberMainTask in firstMemberMainTasks) {
      for (var secondMemberMainTask in secondMemberMainTasks) {
        if (firstMemberMainTask.mainTaskId == secondMemberMainTask.mainTaskId) {
          if (!mainTasksIds.contains(firstMemberMainTask.mainTaskId)) {
            mainTasksIds.add(firstMemberMainTask.mainTaskId);
          }
        }
      }
    }
    if (mainTasksIds.isEmpty) {
      throw Exception("No common tasks found");
    }

    yield* getMainTasksByListIdStream(mainTasks: mainTasksIds);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>> getMemberMainTasksStream({
    required String projectId,
    required String firstMember,
  }) async* {
    List<ProjectMainTaskModel> firstMemberMainTasks = [];
    List<String> mainTasksIds = [];

    Completer<List<String>> completer = Completer<List<String>>();

    Stream<QuerySnapshot<ProjectSubTaskModel>> firstMemberSubTasksStream =
        ProjectSubTaskController().getMemberSubTasksForAProjectStream(
            memberId: firstMember, projectId: projectId);

    StreamSubscription<QuerySnapshot<ProjectSubTaskModel>>
        firstMemberSubscription;
    firstMemberSubscription = firstMemberSubTasksStream.listen((event) async {
      for (var element in event.docs) {
        ProjectMainTaskModel projectMainTaskModel =
            await getProjectMainTaskById(id: element.data().mainTaskId);
        firstMemberMainTasks.add(projectMainTaskModel);
      }

      if (!completer.isCompleted) {
        for (var firstMemberMainTask in firstMemberMainTasks) {
          mainTasksIds.add(firstMemberMainTask.id);
        }

        completer.complete(mainTasksIds);
      }
    });

    List<String> mainTasksFinal = await completer.future;

    firstMemberSubscription.cancel();

    if (mainTasksFinal.isEmpty) {
      throw Exception("No main tasks the member is part of");
    }

    yield* getMainTasksByListIdStream(mainTasks: mainTasksFinal);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getUserAsMemberMainTasksInADayStream({
    required DateTime date,
  }) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));

    String memberId = "";
    List<String> mainTaskIds = [];
    List<String> finalIds = [];
    List<TeamMemberModel> list = await TeamMemberController()
        .getMemberWhereUserIs(
            userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    for (var element in list) {
      TeamMemberModel teamMemberModel = element;
      memberId = teamMemberModel.id;
      List<ProjectSubTaskModel> subTasksList = await ProjectSubTaskController()
          .getMemberSubTasks(memberId: memberId);

      for (var subTaskModel in subTasksList) {
        if (!mainTaskIds.contains(subTaskModel.mainTaskId)) {
          mainTaskIds.add(subTaskModel.mainTaskId);
        }
      }
    }

    if (mainTaskIds.isEmpty) {
      throw Exception("no main tasks for projects I am a member of");
    }

    for (var element in mainTaskIds) {
      ProjectMainTaskModel mainTask = await getProjectMainTaskById(id: element);
      if (mainTask.startDate.isAfter(startOfDay) &&
          mainTask.startDate!.isBefore(endOfDay)) {
        if (!finalIds.contains(mainTask.id)) {
          finalIds.add(mainTask.id);
        }
      }
    }

    if (finalIds.isEmpty) {
      throw Exception("no main tasks for projects I am a member of");
    }

    yield* getMainTasksByListIdStream(mainTasks: finalIds);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>> getMainTasksByListIdStream(
      {required List<String> mainTasks}) {
    return projectMainTasksRef
        .where(idK, whereIn: mainTasks)
        .snapshots()
        .cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getUserAsManagerMainTasksInADayStream({required DateTime date}) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    List<ProjectMainTaskModel> MainTasksall = [];
    List<String> idList = [];
    List<ProjectModel?>? projects = await ProjectController().getProjectsOfUser(
        userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    for (var element in projects!) {
      List<ProjectMainTaskModel> mainTasks =
          await getProjectMainTasks(projectId: element!.id);
      for (var element in mainTasks) {
        MainTasksall.add(element);
      }
    }
    for (var MainTaskelement in MainTasksall) {
      ProjectMainTaskModel mainTask = MainTaskelement;
      if (mainTask.startDate.isAfter(startOfDay) &&
          mainTask.startDate!.isBefore(endOfDay)) {
        if (!idList.contains(mainTask.id)) {
          idList.add(mainTask.id);
        }
      }
    }
    if (idList.isEmpty) {
      throw Exception("no main tasks of project iam manager of");
    }
    yield* getMainTasksByListIdStream(mainTasks: idList);
  }

  Stream<QuerySnapshot<ProjectMainTaskModel>>
      getProjectMainTasksStartBetweenTowTimesStream(
          {required DateTime firstDate,
          required DateTime secondDate,
          required String projectId}) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<ProjectMainTaskModel>>();
  }

  Future<void> addProjectMainTask({
    required ProjectMainTaskModel projectMainTaskModel,
  }) async {
    bool overlapped = false;
    int over = 0;
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    List<ProjectMainTaskModel> list =
        await getProjectMainTasks(projectId: projectMainTaskModel.projectId);
    ProjectModel? project = await ProjectController()
        .getProjectById(id: projectMainTaskModel.projectId);
    if (!projectMainTaskModel.startDate.isAfter(project!.startDate) ||
        !projectMainTaskModel.endDate!.isBefore(project.endDate!)) {
      throw Exception(
          "main task start and end date should be between start and end date of the project");
    }
    for (ProjectMainTaskModel existingTask in list) {
      if (projectMainTaskModel.startDate.isBefore(existingTask.endDate!) &&
          projectMainTaskModel.endDate!.isAfter(existingTask.startDate)) {
        overlapped = true;
        over += 1;
        print(overlapped);
      }
    }
    if (overlapped) {
      Get.defaultDialog(
          title: AppConstants.task_time_error_key,
          middleText:
              "${AppConstants.there_is_key} ${over} ${AppConstants.task_start_prompt_key}",
          onConfirm: () async {
            await addTask(
              reference: projectMainTasksRef,
              field: projectIdK,
              value: projectMainTaskModel.projectId,
              taskModel: projectMainTaskModel,
              exception: Exception(
                  AppConstants.main_task_already_exist_in_project_key),
            );
            Get.key.currentState!.pop();
            CustomSnackBar.showSuccess(
                "${AppConstants.task_key} ${projectMainTaskModel.name} ${AppConstants.added_successfully_key}");
          },
          onCancel: () {
            // SystemNavigator.pop();
            _navigatorKey.currentState?.pop();
          },
          navigatorKey: _navigatorKey);
    } else {
      await addTask(
        reference: projectMainTasksRef,
        field: projectIdK,
        value: projectMainTaskModel.projectId,
        taskModel: projectMainTaskModel,
        exception:
            Exception(AppConstants.main_task_already_exist_in_project_key),
      );
      Get.key.currentState!.pop();
      CustomSnackBar.showSuccess(
          "${AppConstants.task_key} ${projectMainTaskModel.name} ${AppConstants.added_successfully_key}");
    }
    // await addTask(
    //   reference: projectMainTasksRef,
    //   field: projectIdK,
    //   value: projectMainTaskModel.projectId,
    //   taskModel: projectMainTaskModel,
    //   exception: Exception("task already exist in main task"),
    // );
  }

  // Future<void> updateProjectMainTask(
  //     {required Map<String, dynamic> value, required String id}) async {
  //   ProjectMainTaskModel projectMainTaskModel =
  //       await getProjectMainTaskById(id: id);
  //   await updateTask(
  //     data: value,
  //     id: id,
  //     field: projectIdK,
  //     value: projectMainTaskModel.projectId,
  //     reference: projectMainTasksRef,
  //     exception: Exception("main task already been added"),
  //   );
  //   // updateFields(reference: usersTasksRef, data: value, id: id);
  // }

  Future<void> deleteProjectMainTask({required String mainTaskId}) async {
    WriteBatch batch = fireStore.batch();
    QuerySnapshot query = await queryWhere(
        reference: projectSubTasksRef, field: mainTaskIdK, value: mainTaskId);
    DocumentSnapshot documentSnapshot =
        await getDocById(reference: projectMainTasksRef, id: mainTaskId);
    deleteDocUsingBatch(documentSnapshot: documentSnapshot, refbatch: batch);
    deleteDocsUsingBatch(list: query.docs, refBatch: batch);
    batch.commit();
  }

  Future<void> updateMainTask(
      {required Map<String, dynamic> data,
      required String id,
      required bool isfromback}) async {
    DocumentSnapshot snapshot =
        await getDocById(reference: usersTasksRef, id: id);
    ProjectMainTaskModel projectMainTaskModel =
        snapshot.data() as ProjectMainTaskModel;
    ProjectModel? project = await ProjectController()
        .getProjectById(id: projectMainTaskModel.projectId);
    if (isfromback) {
      await updateTask(
          reference: projectSubTasksRef,
          data: data,
          id: id,
          exception:
              Exception(AppConstants.main_task_already_exist_in_project_key),
          field: projectIdK,
          value: projectMainTaskModel.projectId);
      return;
    }
    if (data.containsKey(startDateK) || data[endDateK]) {
      if (!data[startDateK].isAfter(project!.startDate) ||
          !data[endDateK].isBefore(project.endDate!)) {
        throw Exception(
            "main task start and end date should be between start and end date of the project");
      }
      print(data[startDateK]);
      bool overlapped = false;
      int over = 0;
      List<ProjectMainTaskModel> list =
          await getProjectMainTasks(projectId: projectMainTaskModel.projectId);
      list.removeWhere((element) => element.id == id);
      for (ProjectMainTaskModel existingTask in list) {
        if (data[startDateK].isBefore(existingTask.endDate) &&
            data[endDateK].isAfter(existingTask.startDate)) {
          overlapped = true;
          over += 1;
        }
      }
      final GlobalKey<NavigatorState> _navigatorKey =
          GlobalKey<NavigatorState>();
      if (overlapped) {
        Get.defaultDialog(
            title: AppConstants.task_time_error_key,
            middleText:
                "${AppConstants.there_is_key} ${over} ${AppConstants.task_start_prompt_key}",
            onConfirm: () async {
              await updateTask(
                  reference: projectSubTasksRef,
                  data: data,
                  id: id,
                  exception: Exception(
                      AppConstants.main_task_already_exist_in_project_key),
                  field: projectIdK,
                  value: projectMainTaskModel.projectId);
              CustomSnackBar.showSuccess(
                  "${AppConstants.task_key} ${data[nameK]} ${AppConstants.updated_successfully_key}");
              Get.key.currentState!.pop();
            },
            onCancel: () {
              // SystemNavigator.pop();
              _navigatorKey.currentState?.pop();
            },
            navigatorKey: _navigatorKey);
      } else {
        print(data[nameK]);
        await updateTask(
            reference: projectSubTasksRef,
            data: data,
            id: id,
            exception:
                Exception(AppConstants.main_task_already_exist_in_project_key),
            field: projectIdK,
            value: projectMainTaskModel.projectId);
        CustomSnackBar.showSuccess(
            "${AppConstants.task_key} ${data[nameK]} ${AppConstants.updated_successfully_key}");
        Get.key.currentState!.pop();
      }
    } else {
      await updateTask(
          reference: projectSubTasksRef,
          data: data,
          id: id,
          exception:
              Exception(AppConstants.main_task_already_exist_in_project_key),
          field: projectIdK,
          value: projectMainTaskModel.projectId);
      CustomSnackBar.showSuccess(
          "${AppConstants.task_key} ${data[nameK]} ${AppConstants.updated_successfully_key}");
      Get.key.currentState!.pop();
    }
  }
}
