import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/taskController.dart';
import 'package:mytest/models/tops/Var2TopModel.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/models/User/User_task_Model.dart';

import '../constants/back_constants.dart';
import '../services/auth_service.dart';
import '../widgets/Snackbar/custom_snackber.dart';

class UserTaskController extends ProjectAndTaskController {
  Future<List<UserTaskModel>> getAllUsersTasks() async {
    List<Object?>? list = await getAllListDataForRef(refrence: usersTasksRef);

    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getAllUsersTasksStream() {
    Stream<QuerySnapshot> stream =
        getAllListDataForRefStream(refrence: usersTasksRef);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<UserTaskModel> getUserTaskById({required String id}) async {
    DocumentSnapshot taskDoc =
        await getDocById(reference: usersTasksRef, id: id);
    return taskDoc.data() as UserTaskModel;
  }

  Stream<DocumentSnapshot<UserTaskModel>> getUserTaskByIdStream(String id) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersTasksRef, id: id);
    return stream.cast<DocumentSnapshot<UserTaskModel>>();
  }

  Future<UserTaskModel> getUserTaskByNameForUser(
      {required String name, required String userId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: usersTasksRef, field: userIdK, value: userId, name: name);
    return documentSnapshot.data() as UserTaskModel;
  }

  Stream<DocumentSnapshot<UserTaskModel>> getUserTaskByNameForUserStream(
      {required String name, required String userId}) async* {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: usersTasksRef, field: userIdK, value: userId, name: name);
    yield* stream.cast<DocumentSnapshot<UserTaskModel>>();
  }

  Future<UserTaskModel> getCategoryTaskByNameForUser(
      {required String name, required String folderId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: usersTasksRef,
        field: folderIdK,
        value: folderId,
        name: name);
    return documentSnapshot.data() as UserTaskModel;
  }

  Stream<DocumentSnapshot<UserTaskModel>> getCategoryTaskByNameForUserStream(
      {required String name, required String folderId}) async* {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: usersTasksRef,
        field: folderIdK,
        value: folderId,
        name: name);
    yield* stream.cast<DocumentSnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getUserTasks({required String userId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: usersTasksRef, field: userIdK, value: userId);
    List<UserTaskModel> listOfUserTasks = list!.cast<UserTaskModel>();
    print(listOfUserTasks);
    print("hello from task getter");
    return listOfUserTasks;
  }

  Stream<QuerySnapshot<UserTaskModel>> getUserTasksStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
        reference: usersTasksRef, field: userIdK, value: userId));
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getCategoryTasks(
      {required String folderId}) async {
    List<Object?>? list = await getListDataWhere(
      collectionReference: usersTasksRef,
      field: folderIdK,
      value: folderId,
    );
    List<UserTaskModel> listOfUserTasks = list!.cast<UserTaskModel>();
    return listOfUserTasks;
  }

  Stream<QuerySnapshot<UserTaskModel>> getCategoryTasksStream(
      {required String folderId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: usersTasksRef, field: folderIdK, value: folderId);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getChildTasks(
      {required DocumentReference taskFatherId}) async {
    List<Object?>? list = await getListDataWhere(
      collectionReference: usersTasksRef,
      field: taskFatherIdK,
      value: taskFatherId,
    );
    List<UserTaskModel> listOfUserTasks = list!.cast<UserTaskModel>();
    return listOfUserTasks;
  }

  Stream<QuerySnapshot<UserTaskModel>> getChildTasksStream(
      {required DocumentReference taskFatherId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
      reference: usersTasksRef,
      field: taskFatherIdK,
      value: taskFatherId,
    ));
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getUserTasksForAStatus(
      {required String userId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: usersTasksRef,
      field: userIdK,
      value: userId,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getUserTasksForAStatusStream(
      {required String userId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: usersTasksRef,
      field: userIdK,
      value: userId,
    );
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getCategoryTasksForAStatus(
      {required String folderId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: usersTasksRef,
      field: folderIdK,
      value: folderId,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getCategoryTasksForAStatusStream(
      {required String folderId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: usersTasksRef,
      field: folderIdK,
      value: folderId,
    );
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getChildTasksForAStatus(
      {required String status, required String taskFatherId}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: usersTasksRef,
      field: taskFatherIdK,
      value: taskFatherId,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getChildTasksForAStatusStream(
      {required String status, required String taskFatherId}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: usersTasksRef,
      field: taskFatherIdK,
      value: taskFatherId,
    );
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<double> getPercentOfUserTasksForAStatus({
    required String status,
    required String userId,
  }) async {
    return await getPercentOfTasksForAStatus(
      reference: usersTasksRef,
      status: status,
      field: userIdK,
      value: userId,
    );
  }

  Stream<double> getPercentOfUserTasksForAStatusStream(
      String status, String userId) {
    return getPercentOfTasksForAStatusStream(
        reference: usersTasksRef,
        field: userIdK,
        value: userId,
        status: status);
  }

  Future<double> getPercentOfCategoryTasksForAStatus({
    required String status,
    required String folderId,
  }) async {
    return await getPercentOfTasksForAStatus(
      reference: usersTasksRef,
      status: status,
      field: folderIdK,
      value: folderId,
    );
  }

  Stream<double> getPercentOfCategoryTasksForAStatusStream(
      {required String status, required String folderId}) {
    return getPercentOfTasksForAStatusStream(
        reference: usersTasksRef,
        field: folderIdK,
        value: folderId,
        status: status);
  }

  Future<double> getPercentOfUserTasksForAStatusBetweenTowTimes({
    required String status,
    required String userId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: usersTasksRef,
        status: status,
        field: userIdK,
        value: userId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Stream<List<double>> getPercentagesForLastSevenDaysforaUserforAStatusStream(
      {required String userId,
      required DateTime startdate,
      required String status}) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      List<double> data =
          await getPercentagesForLastSevenDaysforaUserforAStatus(
        startdate: startdate,
        status: status,
        userId: userId,
      );
      yield data;
    }
  }

  Future<List<double>> getPercentagesForLastSevenDaysforaUserforAStatus(
      {required String userId,
      required DateTime startdate,
      required String status}) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: usersTasksRef,
        field: userIdK,
        value: userId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Future<List<double>> getPercentagesForLastSevenDaysforaCategoryforAStatus(
      String categoryId, DateTime startdate, String status) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: usersTasksRef,
        field: folderIdK,
        value: categoryId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Stream<double> getPercentOfUserTasksForAStatusBetweenTowTimesStream({
    required String status,
    required String userId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimesStream(
        reference: usersTasksRef,
        status: status,
        field: userIdK,
        value: userId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Future<double> getPercentOfCategoryTasksForAStatusBetweenTowTimes({
    required String status,
    required String folderId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: usersTasksRef,
        status: status,
        field: folderIdK,
        value: folderId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Stream<double> getPercentOfCategoryTasksForAStatusBetweenTowTimesStream({
    required String status,
    required String folderId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimesStream(
        reference: usersTasksRef,
        status: status,
        field: folderIdK,
        value: folderId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Future<List<UserTaskModel>> getUserTasksForAnImportance(
      {required String userId, required int importance}) async {
    List<Object?>? list = await getTasksForAnImportance(
      reference: usersTasksRef,
      field: userIdK,
      value: userId,
      importance: importance,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getUserTasksForAnImportanceStream(
      {required String userId, required int importance}) {
    Stream<QuerySnapshot> stream = getTasksForAnImportanceStream(
        reference: usersTasksRef,
        field: userIdK,
        value: userId,
        importance: importance);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getCategoryTasksForAnImportance(
      {required String folderId, required int importance}) async {
    List<Object?>? list = await getTasksForAnImportance(
      reference: usersTasksRef,
      field: folderIdK,
      value: folderId,
      importance: importance,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getCategoryTasksForAnImportanceStream(
      {required String folderId, required int importance}) {
    Stream<QuerySnapshot> stream = getTasksForAnImportanceStream(
        reference: usersTasksRef,
        field: folderIdK,
        value: folderId,
        importance: importance);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getUserTasksStartInADay(
      {required DateTime date,
      required String userId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: usersTasksRef,
      date: date,
      field: userIdK,
      value: userId,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getUserTasksStartInADayStream({
    required DateTime date,
    required String userId,
  }) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));

    Completer<List<String>> completer = Completer<List<String>>();

    Stream<QuerySnapshot<UserTaskModel>> userTasksStream = getUserTasksStream(
        userId: AuthService.instance.firebaseAuth.currentUser!.uid);

    userTasksStream.listen((event) {
      List<QueryDocumentSnapshot<UserTaskModel>> list = event.docs;
      List<String> tasksFinal = [];

      for (var element in list) {
        UserTaskModel task = element.data();
        print(task.startDate.hour + task.endDate!.hour);
        if (task.startDate.isAfter(startOfDay) &&
            task.startDate.isBefore(endOfDay)) {
          tasksFinal.add(task.id);
        }
      }

      if (!completer.isCompleted) {
        completer.complete(tasksFinal);
      }
    });

    List<String> tasksFinal = await completer.future;

    if (tasksFinal.isEmpty) {
      throw Exception("no user tasks");
    }

    yield* usersTasksRef
        .where(idK, whereIn: tasksFinal)
        .snapshots()
        .cast<QuerySnapshot<UserTaskModel>>();
  }

  // Stream<QuerySnapshot<UserTaskModel>> getUserTasksStartInADayStream({
  //   required DateTime date,
  //   required String userId,
  // }) async* {

  //   final startOfDay = DateTime(date.year, date.month, date.day);

  //   final endOfDay =
  //       startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));
  //   print(date.toString() + startOfDay.toString() + endOfDay.toString());
  //   // yield* getUserTasksBetweenTowTimesStream(
  //   //     firstDate: startOfDay,
  //   //     secondDate: endOfDay,
  //   //     userId: firebaseAuth.currentUser!.uid);
  //   List<String> tasksFinal = [];
  //   getUserTasksStream(userId: firebaseAuth.currentUser!.uid).listen((event) {
  //     List<QueryDocumentSnapshot<UserTaskModel>> list = event.docs;
  //     for (var element in list) {
  //       UserTaskModel task = element.data();
  //       print(task.startDate.hour + task.endDate!.hour);
  //       if (task.startDate.isAfter(startOfDay) &&
  //           task.startDate.isBefore(endOfDay)) {

  //         tasksFinal.add(task.id);
  //       }
  //     }
  //   });

  //   if (tasksFinal.isEmpty) {
  //     throw Exception("no user tasks");
  //   }

  //   yield* usersTasksRef
  //       .where(idK, whereIn: tasksFinal)
  //       .snapshots()
  //       .cast<QuerySnapshot<UserTaskModel>>();
  // }

  Stream<QuerySnapshot<UserTaskModel>> getUserTasksStartInADayForAStatusStream(
      {required DateTime date,
      required String userId,
      required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
        reference: usersTasksRef,
        date: date,
        field: userIdK,
        value: userId,
        status: status);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getCategoryTasksStartInADay(
      {required DateTime date,
      required String folderId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: usersTasksRef,
      date: date,
      field: folderIdK,
      value: folderId,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getCategoryTasksStartInADayStream(
      {required DateTime date,
      required String folderId,
      required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
      status: status,
      reference: usersTasksRef,
      date: date,
      field: folderIdK,
      value: folderId,
    );
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getUserTasksBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String userId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: usersTasksRef,
      field: userIdK,
      value: userId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getUserTasksBetweenTowTimesStream(
      {required DateTime firstDate,
      required DateTime secondDate,
      required String userId}) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: usersTasksRef,
        field: userIdK,
        value: userId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getCategoryTasksBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String folderId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: usersTasksRef,
      field: folderIdK,
      value: folderId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getCategoryTasksBetweenTowTimesStream(
      {required DateTime firstDate,
      required DateTime secondDate,
      required String folderId}) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: usersTasksRef,
        field: folderIdK,
        value: folderId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getUserTasksStartInASpecificTime(
      {required DateTime date, required String userId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: usersTasksRef, date: date, field: userIdK, value: userId);
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>> getUserTasksStartInASpecificTimeStream(
      {required DateTime date, required String userId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: usersTasksRef, date: date, field: userIdK, value: userId);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  Future<List<UserTaskModel>> getCategoryTasksStartInASpecificTime(
      {required DateTime date, required String folderId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: usersTasksRef,
        date: date,
        field: folderIdK,
        value: folderId);
    return list!.cast<UserTaskModel>();
  }

  Stream<QuerySnapshot<UserTaskModel>>
      getCategoryTasksStartInASpecificTimeStream(
          {required DateTime date, required String folderId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: usersTasksRef,
        date: date,
        field: folderIdK,
        value: folderId);
    return stream.cast<QuerySnapshot<UserTaskModel>>();
  }

  // Future<void> addUserTask({required UserTaskModel userTaskModel}) async {
  //   int numOfTasksInSameTime =
  //       (await getTasksAndProjectBetweenTowTimesByTowFields(
  //     reference: usersTasksRef,
  //     firstField: userIdK,
  //     firstValue: userTaskModel.userId,
  //     secondField: folderIdK,
  //     secondValue: userTaskModel.folderId,
  //     firstDateField: startDateK,
  //     firstDate: userTaskModel.startDate,
  //     secondDateField: endDateK,
  //     secondDate: userTaskModel.endDate!,
  //   ))
  //           .length;
  //   if (numOfTasksInSameTime >= 1) {
  //     Get.defaultDialog(
  //       title: "Task Time Error",
  //       middleText:
  //           "There is $numOfTasksInSameTime That start in this time \n Would you Like To Add Task Any Way?",
  //       onConfirm: () async {
  //         await addTask(
  //           reference: usersTasksRef,
  //           field: folderIdK,
  //           value: userTaskModel.folderId,
  //           taskModel: userTaskModel,
  //           exception: Exception("task already exist in Category"),
  //         );
  //       },
  //       onCancel: () {
  //         Get.back();
  //       },
  //     );
  //   }
  //   await addTask(
  //     reference: usersTasksRef,
  //     field: folderIdK,
  //     value: userTaskModel.folderId,
  //     taskModel: userTaskModel,
  //     exception: Exception("task already exist in Category"),
  //   );
  // }

  Future<void> addUserLateTask({required UserTaskModel userTaskModel}) async {
    await addLateTask(
        taskModel: userTaskModel,
        field: folderIdK,
        value: userTaskModel.folderId,
        reference: usersTasksRef,
        exception: Exception(AppConstants.user_task_already_added_key));
  }

  Future<void> deleteUserTask({required String id}) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot cat = await getDocById(reference: usersTasksRef, id: id);
    QuerySnapshot querySnapshot = await queryWhere(
        reference: usersTasksRef, field: taskFatherIdK, value: id);
    deleteDocsUsingBatch(list: querySnapshot.docs, refBatch: batch);
    deleteDocUsingBatch(documentSnapshot: cat, refbatch: batch);

    batch.commit();
  }

  Future<void> adddUserTask({required UserTaskModel userTaskModel}) async {
    bool overlapped = false;
    int over = 0;
    List<UserTaskModel> list = await getUserTasks(
        userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    for (UserTaskModel existingTask in list) {
      if (userTaskModel.startDate.isBefore(existingTask.endDate!) &&
          userTaskModel.endDate!.isAfter(existingTask.startDate)) {
        overlapped = true;
        over += 1;
        print(overlapped);
      }
    }
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    if (overlapped) {
      Get.defaultDialog(
          title: AppConstants.task_time_error_key,
          middleText:
              "${AppConstants.there_is_key.tr} $over ${AppConstants.task_start_prompt_key.tr}",
          onConfirm: () async {
            await addTask(
              reference: usersTasksRef,
              field: folderIdK,
              value: userTaskModel.folderId,
              taskModel: userTaskModel,
              exception:
                  Exception(AppConstants.task_already_exists_category_key.tr),
            );
            CustomSnackBar.showSuccess(
                "${AppConstants.the_task_key.tr} ${userTaskModel.name} ${AppConstants.added_successfully_key.tr}");
            Get.key.currentState!.pop();
          },
          onCancel: () {
            // SystemNavigator.pop();
            _navigatorKey.currentState?.pop();
          },
          navigatorKey: _navigatorKey);
    } else {
      await addTask(
        reference: usersTasksRef,
        field: folderIdK,
        value: userTaskModel.folderId,
        taskModel: userTaskModel,
        exception: Exception(AppConstants.task_already_exists_category_key.tr),
      );
      Get.key.currentState!.pop();

      CustomSnackBar.showSuccess(
          "${AppConstants.the_task_key.tr} ${userTaskModel.name} ${AppConstants.added_successfully_key.tr}");
    }
  }

  Future<void> updateUserTask(
      {required Map<String, dynamic> data,
      required String id,
      required bool isfromback}) async {
    DocumentSnapshot snapshot =
        await getDocById(reference: usersTasksRef, id: id);
    UserTaskModel userTaskModel = snapshot.data() as UserTaskModel;
    if (isfromback) {
      await updateTask(
        reference: usersTasksRef,
        data: data,
        id: id,
        field: folderIdK,
        value: userTaskModel.folderId,
        exception: Exception(AppConstants.task_already_exists_category_key.tr),
      );
      return;
    }
    if (data.containsKey(startDateK)) {
      print(data[startDateK]);
      bool overlapped = false;
      int over = 0;

      List<UserTaskModel> list = await getUserTasks(
          userId: AuthService.instance.firebaseAuth.currentUser!.uid);
      list.removeWhere((element) => element.id == id);
      for (UserTaskModel existingTask in list) {
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
            title: AppConstants.task_time_error_key.tr,
            middleText:
                "${AppConstants.there_is_key.tr} $over ${AppConstants.task_start_prompt_key.tr}",
            onConfirm: () async {
              await updateTask(
                reference: usersTasksRef,
                data: data,
                id: id,
                field: folderIdK,
                value: userTaskModel.folderId,
                exception:
                    Exception(AppConstants.task_already_exists_category_key.tr),
              );
              CustomSnackBar.showSuccess(
                  "${AppConstants.task_key.reactive} ${data[nameK]} ${AppConstants.task_updated_successfully_key.tr}");
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
          reference: usersTasksRef,
          data: data,
          id: id,
          field: folderIdK,
          value: userTaskModel.folderId,
          exception: Exception(AppConstants.task_already_exists_category_key),
        );
        CustomSnackBar.showSuccess(
            "${AppConstants.task_key.tr} ${data[nameK]} ${AppConstants.task_updated_successfully_key.tr}");
        Get.key.currentState!.pop();
      }
    } else {
      print(data[nameK]);

      await updateTask(
        reference: usersTasksRef,
        data: data,
        id: id,
        field: folderIdK,
        value: userTaskModel.folderId,
        exception: Exception(AppConstants.task_already_exists_category_key.tr),
      );
      CustomSnackBar.showSuccess(
          "${AppConstants.task_key.tr} ${data[nameK]} ${AppConstants.task_updated_successfully_key.tr}");
      Get.key.currentState!.pop();
    }
  }
}
