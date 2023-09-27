import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/project_main_task_controller.dart';
import 'package:mytest/controllers/statusController.dart';
import 'package:mytest/controllers/taskController.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/team/Project_main_task_Model.dart';
import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/models/team/Project_sub_task_Model.dart';

import '../constants/app_constans.dart';
import '../constants/back_constants.dart';
import '../models/User/User_model.dart';
import '../models/statusmodel.dart';
import '../models/team/Project_model.dart';
import '../models/team/Team_model.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/types.dart';
import '../widgets/Snackbar/custom_snackber.dart';

class ProjectSubTaskController extends ProjectAndTaskController {
  Future<List<ProjectSubTaskModel>> getMemberSubTasks(
      {required String memberId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectSubTasksRef,
        field: assignedToK,
        value: memberId);
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>> getMemberSubTasksStream(
      {required String memberId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
        reference: projectSubTasksRef, field: assignedToK, value: memberId));
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getProjectSubTasksForAUserStartInADayStream({
    required DateTime date,
  }) async* {
    print("sub task");
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));

    List<String> subTasksIds = [];
    StreamSubscription<QuerySnapshot<TeamMemberModel>> memberSubscription;
    Stream<QuerySnapshot<TeamMemberModel>> teamMemberList =
        TeamMemberController()
            .getMemberWhereUserIsStream(userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    List<TeamMemberModel> listMemberUser = await TeamMemberController()
        .getMemberWhereUserIs(userId: AuthService.instance.firebaseAuth.currentUser!.uid);

    for (var element in listMemberUser) {
      List<ProjectSubTaskModel> list =
          await getMemberSubTasks(memberId: element.id);
      for (var subTask in list) {
        if (subTask.startDate.isAfter(startOfDay) &&
            subTask.startDate.isBefore(endOfDay)) {
          print("hello sub task");
          subTasksIds.add(subTask.id);
        }
      }
    }

    if (subTasksIds.isEmpty) {
      throw Exception("no sub tasks for project I am a member of");
    }

    yield* projectSubTasksRef
        .where(idK, whereIn: subTasksIds)
        .snapshots()
        .cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>> getMemberSubTasksForAProjectStream(
      {required String memberId, required String projectId}) {
    Stream<QuerySnapshot> stream = queryWhereAndWhereStream(
        reference: projectSubTasksRef,
        firstField: assignedToK,
        firstValue: memberId,
        secondField: projectIdK,
        secondValue: projectId);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  // Future<List<DocumentSnapshot>> getMemberSubTasksDocs(
  //     {required String memberId}) async {
  //   List<DocumentSnapshot> list = await getDocsSnapShotWhere(
  //       collectionReference: projectSubTasksRef,
  //       field: assignedToK,
  //       value: memberId);
  //   return list;
  // }

  Future<ProjectSubTaskModel> getProjectSubTaskById(
      {required String id}) async {
    DocumentSnapshot subtaskDoc =
        await getDocById(reference: projectSubTasksRef, id: id);
    return subtaskDoc.data() as ProjectSubTaskModel;
  }

  Stream<DocumentSnapshot<ProjectSubTaskModel>> getProjectSubTaskByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: projectSubTasksRef, id: id);
    return stream.cast<DocumentSnapshot<ProjectSubTaskModel>>();
  }

  Future<ProjectSubTaskModel> getSubTaskByNameForProject(
      {required String name, required String projectId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: projectSubTasksRef,
        field: projectIdK,
        value: projectId,
        name: name);
    return documentSnapshot.data() as ProjectSubTaskModel;
  }

  Stream<DocumentSnapshot<ProjectSubTaskModel>>
      getSubTaskByNameForProjectStream(
          {required String name, required String projectId}) {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: projectSubTasksRef,
        field: projectIdK,
        value: projectId,
        name: name);
    return stream.cast<DocumentSnapshot<ProjectSubTaskModel>>();
  }

  Future<ProjectSubTaskModel> getSubTaskByNameForMainTask(
      {required String name, required String mainTaskId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: projectSubTasksRef,
        field: mainTaskIdK,
        value: mainTaskId,
        name: name);
    return documentSnapshot.data() as ProjectSubTaskModel;
  }

  Stream<DocumentSnapshot<ProjectSubTaskModel>>
      getSubTaskByNameForMainTaskStream(
          {required String name, required String mainTaskId}) {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: projectSubTasksRef,
        field: mainTaskIdK,
        value: mainTaskId,
        name: name);
    return stream.cast<DocumentSnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getProjectSubTasks(
      {required String projectId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectSubTasksRef,
        field: projectIdK,
        value: projectId);
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>> getProjectSubTasksStream(
      {required String projectId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
        reference: projectSubTasksRef, field: projectIdK, value: projectId));
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getSubTasksForAMainTask(
      {required String mainTaskId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectSubTasksRef,
        field: mainTaskIdK,
        value: mainTaskId);
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>> getSubTasksForAMainTaskStream(
      {required String mainTaskId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
      reference: projectSubTasksRef,
      field: mainTaskIdK,
      value: mainTaskId,
    ));
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getProjectSubTasksForAStatus(
      {required String projectId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: projectSubTasksRef,
      field: projectIdK,
      value: projectId,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>> getProjectSubTasksForAStatusStream(
      {required String projectId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: projectSubTasksRef,
      field: projectIdK,
      value: projectId,
    );
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getMainTaskSubTasksForAStatus(
      {required String mainTaskId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: projectSubTasksRef,
      field: mainTaskIdK,
      value: mainTaskId,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getMainTaskSubTasksForAStatusStream(
          {required String mainTaskId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: projectSubTasksRef,
      field: mainTaskIdK,
      value: mainTaskId,
    );
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<double> getPercentOfSubTasksInAProjectForAStatus(
      {required String status, required String projectId}) async {
    return await getPercentOfTasksForAStatus(
      reference: projectSubTasksRef,
      status: status,
      field: projectIdK,
      value: projectId,
    );
  }

  Stream<double> getPercentOfSubTasksInAProjectForAStatusStream(
      {required String status, required String projectId}) {
    return getPercentOfTasksForAStatusStream(
        reference: projectSubTasksRef,
        field: projectIdK,
        value: projectId,
        status: status);
  }

  Future<double> getPercentOfSubTasksInAMainTaskForAStatus(
      {required String status, required String mainTaskId}) async {
    return await getPercentOfTasksForAStatus(
      reference: projectSubTasksRef,
      status: status,
      field: mainTaskIdK,
      value: mainTaskId,
    );
  }

  Stream<double> getPercentOfSubTasksInAMainTaskForAStatusStream(
      {required String status, required String mainTaskId}) {
    return getPercentOfTasksForAStatusStream(
        reference: projectSubTasksRef,
        field: mainTaskIdK,
        value: mainTaskId,
        status: status);
  }

  Future<double> getPercentOfSubTasksInAProjectForAStatusBetweenTowTime({
    required String status,
    required String projectId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: projectSubTasksRef,
        status: status,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Stream<double>
      getPercentOfSubTasksInAProjectForAStatusBetweenTowStartTimeStream({
    required String status,
    required String projectId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimesStream(
        reference: projectSubTasksRef,
        status: status,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Future<double> getPercentOfSubTasksInAMainTaskForAStatusBetweenTowTimes({
    required String status,
    required String mainTaskId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: projectSubTasksRef,
        status: status,
        field: mainTaskIdK,
        value: mainTaskId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Stream<double>
      getPercentOfSubTasksInAMainTaskForAStatusBetweenTowTimesStream({
    required String status,
    required String mainTaskId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimesStream(
        reference: projectSubTasksRef,
        status: status,
        field: mainTaskIdK,
        value: mainTaskId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

  Future<List<ProjectSubTaskModel>> getProjectSubTasksForAnImportance(
      {required String projectId, required int importance}) async {
    List<Object?>? list = await getTasksForAnImportance(
      reference: projectSubTasksRef,
      field: projectIdK,
      value: projectId,
      importance: importance,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getProjectSubTasksForAnImportanceStream(
          {required String projectId, required int importance}) {
    Stream<QuerySnapshot> stream = getTasksForAnImportanceStream(
        reference: projectSubTasksRef,
        field: projectIdK,
        value: projectId,
        importance: importance);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getMainTaskSubTasksForAnImportance(
      {required String mainTaskId, required int importance}) async {
    List<Object?>? list = await getTasksForAnImportance(
      reference: projectSubTasksRef,
      field: mainTaskIdK,
      value: mainTaskId,
      importance: importance,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getMainTaskSubTasksForAnImportanceStream(
          {required String mainTaskId, required int importance}) {
    Stream<QuerySnapshot> stream = getTasksForAnImportanceStream(
        reference: projectSubTasksRef,
        field: mainTaskIdK,
        value: mainTaskId,
        importance: importance);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getProjectSubTasksStartInADayForAStatus(
      {required DateTime date,
      required String projectId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: projectSubTasksRef,
      date: date,
      field: projectIdK,
      value: projectId,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Future<List<double>>
      getPercentagesForLastSevenDaysforaProjectSubTasksforAStatus(
          String projectId, DateTime startdate, String status) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: projectSubTasksRef,
        field: projectIdK,
        value: projectId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Future<List<double>>
      getPercentagesForLastSevenDaysforaMainTaskSubTasksforAStatus(
          String mainTaskId, DateTime startdate, String status) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: projectSubTasksRef,
        field: mainTaskIdK,
        value: mainTaskId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getProjectSubTasksStartInADayForAStatusStream(
          {required DateTime date,
          required String projectId,
          required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
        status: status,
        reference: projectSubTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getMainTaskSubTasksStartInADayForAStatus(
      {required DateTime date,
      required String mainTaskId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: projectSubTasksRef,
      date: date,
      field: mainTaskIdK,
      value: mainTaskId,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getMainTaskSubTasksStartInADayForAStatusStream(
          {required DateTime date,
          required String mainTaskId,
          required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
        status: status,
        reference: projectSubTasksRef,
        date: date,
        field: mainTaskIdK,
        value: mainTaskId);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getProjectSubTasksStartBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String projectId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: projectSubTasksRef,
      field: projectIdK,
      value: projectId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getProjectSubTasksStartBetweenTowTimesStream(
          {required DateTime firstDate,
          required DateTime secondDate,
          required String projectId}) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: projectSubTasksRef,
        field: projectIdK,
        value: projectId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getMainTaskSubTasksStartBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String mainTaskId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: projectSubTasksRef,
      field: mainTaskIdK,
      value: mainTaskId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getMainTaskSubTasksStartBetweenTowTimesStream({
    required DateTime firstDate,
    required DateTime secondDate,
    required String mainTaskId,
  }) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: projectSubTasksRef,
        field: mainTaskIdK,
        value: mainTaskId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getProjectSubTasksStartInASpecificTime(
      {required DateTime date, required String projectId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: projectSubTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getProjectSubTasksStartInASpecificTimeStream(
          {required DateTime date, required String projectId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: projectSubTasksRef,
        date: date,
        field: projectIdK,
        value: projectId);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<List<ProjectSubTaskModel>> getMainTaskSubTasksStartInASpecificTime(
      {required DateTime date, required String mainTaskId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: projectSubTasksRef,
        date: date,
        field: mainTaskIdK,
        value: mainTaskId);
    return list!.cast<ProjectSubTaskModel>();
  }

  Stream<QuerySnapshot<ProjectSubTaskModel>>
      getMainTaskSubTasksStartInASpecificTimeStream(
          {required DateTime date, required String mainTaskId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: projectSubTasksRef,
        date: date,
        field: mainTaskId,
        value: mainTaskId);
    return stream.cast<QuerySnapshot<ProjectSubTaskModel>>();
  }

  Future<void> changeAssignedTo(
      {required String id, required String newAssignedTo}) async {
    await updateNonRelationalFields(
        reference: projectSubTasksRef,
        data: {assignedToK: newAssignedTo},
        id: id,
        nameException: Exception());
    // await updateFields(
    //     reference: projectSubTasksRef,
    //     id: id,
    //     data: {assignedToK: newAssignedTo});
  }

  Future<void> addProjectSubTask(
      {required ProjectSubTaskModel projectsubTaskModel}) async {
    await addTask(
      reference: projectSubTasksRef,
      field: mainTaskIdK,
      value: projectsubTaskModel.mainTaskId,
      taskModel: projectsubTaskModel,
      exception:
          Exception(AppConstants.sub_task_already_exist_in_main_task_key.tr),
    );
//"task already exist in main task"
    // await addTask(
    //   reference: projectSubTasksRef,
    //   field: mainTaskIdK,
    //   value: projectsubTaskModel.mainTaskId,
    //   taskModel: projectsubTaskModel,
    //   exception: Exception("task already exist in main task"),
    // );
  }

  Future<void> deleteProjectSubTask({required String id}) async {
    print(id);
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
        collectionReference: projectSubTasksRef, field: idK, value: id);
    deleteDocUsingBatch(documentSnapshot: documentSnapshot!, refbatch: batch);
    batch.commit();
  }

  Future<void> updateSubTask(
      {required Map<String, dynamic> data,
      required String id,
      required bool isfromback}) async {
    if (isfromback) {
      DocumentSnapshot snapshot =
          await getDocById(reference: projectSubTasksRef, id: id);
      ProjectSubTaskModel subTaskModel = snapshot.data() as ProjectSubTaskModel;
      updateTask(
          reference: projectSubTasksRef,
          data: data,
          id: id,
          exception:
              Exception(AppConstants.sub_task_already_exist_in_main_task_key),
          field: mainTaskIdK,
          value: subTaskModel.mainTaskId);
      return;
    }
    DocumentSnapshot snapshot =
        await getDocById(reference: usersTasksRef, id: id);
    ProjectSubTaskModel projectsubTaskModel =
        snapshot.data() as ProjectSubTaskModel;
    ProjectMainTaskModel? MainTask = await ProjectMainTaskController()
        .getProjectMainTaskById(id: projectsubTaskModel.mainTaskId);
    if (data.containsKey(startDateK) || data[endDateK]) {
      if (!data[startDateK].isAfter(MainTask!.startDate) ||
          !data[endDateK].isBefore(MainTask.endDate!)) {
        throw Exception(
            "sub task start and end date should be between start and end date of the main task");
      }
      print(data[startDateK]);
      bool overlapped = false;
      int over = 0;
      List<ProjectSubTaskModel> list =
          await getMemberSubTasks(memberId: projectsubTaskModel.assignedTo);
      list.removeWhere((element) => element.id == id);
      for (ProjectSubTaskModel existingTask in list) {
        if (data[startDateK].isBefore(existingTask.endDate) &&
            data[endDateK].isAfter(existingTask.startDate)) {
          overlapped = true;
          over += 1;
        }
      }
      //"Task Time Error"
      if (overlapped) {
        Get.defaultDialog(
          title: AppConstants.task_time_error_key.tr,
          middleText:
              "${AppConstants.there_is_key.tr} ${over} ${AppConstants.task_start_prompt_key.tr}",
          onConfirm: () async {
            DocumentSnapshot snapshot =
                await getDocById(reference: projectSubTasksRef, id: id);
            ProjectSubTaskModel subTaskModel =
                snapshot.data() as ProjectSubTaskModel;
            updateTask(
                reference: projectSubTasksRef,
                data: data,
                id: id,
                exception: Exception(
                    AppConstants.sub_task_already_exist_in_main_task_key.tr),
                field: mainTaskIdK,
                value: subTaskModel.mainTaskId);
            CustomSnackBar.showSuccess(
                "${AppConstants.task_key.tr} ${data[nameK]} ${AppConstants.updated_successfully_key.tr}");
            Get.key.currentState!.pop();
          },
          onCancel: () {
            Get.back();
          },
        );
      } else {
        print(data[nameK]);
        DocumentSnapshot snapshot =
            await getDocById(reference: projectSubTasksRef, id: id);
        ProjectSubTaskModel subTaskModel =
            snapshot.data() as ProjectSubTaskModel;
        updateTask(
            reference: projectSubTasksRef,
            data: data,
            id: id,
            exception:
                Exception(AppConstants.sub_task_already_exist_in_main_task_key.tr),
            field: mainTaskIdK,
            value: subTaskModel.mainTaskId);
        CustomSnackBar.showSuccess(
            "${AppConstants.task_key.tr} ${data[nameK]} ${AppConstants.updated_successfully_key.tr}");
        Get.key.currentState!.pop();
      }
    } else {
      print(data[nameK]);
      DocumentSnapshot snapshot =
          await getDocById(reference: projectSubTasksRef, id: id);
      ProjectSubTaskModel subTaskModel = snapshot.data() as ProjectSubTaskModel;
      updateTask(
          reference: projectSubTasksRef,
          data: data,
          id: id,
          exception:
              Exception(AppConstants.sub_task_already_exist_in_main_task_key.tr),
          field: mainTaskIdK,
          value: subTaskModel.mainTaskId);
      CustomSnackBar.showSuccess(
          "${AppConstants.task_key.tr} ${data[nameK]} ${AppConstants.updated_successfully_key.tr}");
      Get.key.currentState!.pop();
    }
  }

  Future<void> markSubTaskeAndSendNotification(
      String subtaskId, String status) async {
    StatusController statusController = Get.put(StatusController());
    UserController userController = Get.put(UserController());
    TeamController teamController = Get.put(TeamController());
    ProjectController projectController = Get.put(ProjectController());
    FcmNotifications fcmNotifications = Get.put(FcmNotifications());
    StatusModel s = await statusController.getStatusByName(status: status);
    updateSubTask(data: {statusIdK: s.id}, id: subtaskId, isfromback: true);
    ProjectSubTaskController projectTaskController =
        Get.put(ProjectSubTaskController());
    ProjectSubTaskModel projectSubTaskModel =
        await projectTaskController.getProjectSubTaskById(id: subtaskId);
    ProjectModel? projectModel = await projectController.getProjectById(
        id: projectSubTaskModel.projectId);
    TeamModel teamModel =
        await teamController.getTeamOfProject(project: projectModel!);
    UserModel manager = await userController.getUserWhereMangerIs(
        mangerId: teamModel.managerId);
    //to get the user name to tell the manager about his name in the notification
    UserModel member = await userController.getUserById(
        id: AuthService.instance.firebaseAuth.currentUser!.uid);
    await fcmNotifications.sendNotification(
      fcmTokens: manager.tokenFcm,
      //"task $status"
      title: "${AppConstants.task_key.tr} $status",
      body:
          "${member.name} $status ${AppConstants.the_task_key.tr} ${projectSubTaskModel.name} ${projectSubTaskModel.projectId} ${AppConstants.in_project_key.tr} ${projectModel.name}",
      type: NotificationType.notification,
    );
  }
}
