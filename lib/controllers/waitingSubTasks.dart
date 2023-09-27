// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/project_sub_task_controller.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/waitingSubTasksModel.dart';
import 'package:mytest/services/collectionsrefrences.dart';

import '../constants/back_constants.dart';
import '../models/User/User_model.dart';
import '../models/team/Project_model.dart';
import '../models/team/Project_sub_task_Model.dart';
import '../services/notification_service.dart';
import '../services/types.dart';
import '../widgets/Snackbar/custom_snackber.dart';
import 'manger_controller.dart';

class WatingSubTasksController extends TopController {
  Future<void> addWatingSubTask(
      {required WaitingSubTaskModel waitingSubTaskModel}) async {
    await addDoc(reference: watingSubTasksRef, model: waitingSubTaskModel);
  }

  Future<List<WaitingSubTaskModel>> getWatingSubTasksForMember(
      {required String memberId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingSubTasksRef,
        field: "subTask.$assignedToK",
        value: memberId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Stream<QuerySnapshot<WaitingSubTaskModel>> getWatingSubTasksForMemberStream(
      {required String memberId}) {
    return queryWhereStream(
            reference: watingSubTasksRef,
            value: memberId,
            field: "subTask.$assignedToK")
        .cast<QuerySnapshot<WaitingSubTaskModel>>();
  }

  Future<List<WaitingSubTaskModel>> getWatingSubTasksForMainTask(
      {required String mainTaskId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingSubTasksRef,
        field: "subTask.$mainTaskIdK",
        value: mainTaskId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Future<List<WaitingSubTaskModel>> getWatingSubTasksForProject(
      {required String projectId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingSubTasksRef,
        field: "subTask.$projectIdK",
        value: projectId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Stream<QuerySnapshot<WaitingSubTaskModel>> getWatingSubTasksForProjectStream(
      {required String projectId}) {
    return queryWhereStream(
            reference: watingSubTasksRef,
            field: "subTask.$projectIdK",
            value: projectId)
        .cast<QuerySnapshot<WaitingSubTaskModel>>();
  }

  Stream<QuerySnapshot<WaitingSubTaskModel>>
      getWatingSubTasksFormainTasksStream({required String mainTaskId}) {
    return queryWhereStream(
            reference: watingSubTasksRef,
            value: mainTaskId,
            field: "subTask.$mainTaskIdK")
        .cast<QuerySnapshot<WaitingSubTaskModel>>();
  }

  Future<List<WaitingSubTaskModel>> getAllwatingSubtaksforMamber(
      {required memberId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectSubTasksRef,
        field: assignedToK,
        value: memberId);
    return list!.cast<WaitingSubTaskModel>();
  }

  Future<WaitingSubTaskModel> getWatingSubTaskById({required String id}) async {
    return (await getDocById(reference: watingSubTasksRef, id: id)).data()
        as WaitingSubTaskModel;
  }

  Stream<DocumentSnapshot<WaitingSubTaskModel>> getWatingSubTaskByIdStream(
      {required String id}) {
    return getDocByIdStream(reference: watingSubTasksRef, id: id)
        .cast<DocumentSnapshot<WaitingSubTaskModel>>();
  }

  Future<void> accpetSubTask({required String waitingSubTaskId}) async {
    await waitingTaskHandler(
        waitingSubTaskId: waitingSubTaskId,
        isAccepted: true,
        memberMessage: '');
  }

  Future<void> rejectSubTask({
    required String waitingSubTaskId,
    required String rejectingMessage,
  }) async {
    String reasonforRejection =
        "${AppConstants.rejection_reason_key} $rejectingMessage";
    await waitingTaskHandler(
      waitingSubTaskId: waitingSubTaskId,
      isAccepted: false,
      memberMessage: reasonforRejection,
    );
  }

  Future<void> waitingTaskHandler({
    required String waitingSubTaskId,
    required bool isAccepted,
    required String memberMessage,
  }) async {
    try {
      String status = isAccepted
          ? "${AppConstants.accepted_key}"
          : "${AppConstants.rejected_key}";
      //user Controller to send the notification to the manager about whether the user acepted the invite or not
      UserController userController = Get.put(UserController());
      //to get the team model so we get the manager model and then get the manager user profile to sned the notification
      WatingSubTasksController watingSubTasksController =
          Get.put(WatingSubTasksController());
      ProjectController projectController = Get.put(ProjectController());
      ManagerController managerController = Get.put(ManagerController());
      WaitingSubTaskModel waitingSubTaskModel = await watingSubTasksController
          .getWatingSubTaskById(id: waitingSubTaskId);

      if (isAccepted) {
        //to add the project sub task member to the project
        watingSubTasksController.deleteWatingSubTask(id: waitingSubTaskId);
        ProjectSubTaskController projectSubTaskController =
            Get.put(ProjectSubTaskController());
        ProjectSubTaskModel projectSubTaskModel =
            waitingSubTaskModel.projectSubTaskModel;
        projectSubTaskController.addProjectSubTask(
          projectsubTaskModel: projectSubTaskModel,
        );
      } else {
        watingSubTasksController.deleteWatingSubTask(id: waitingSubTaskId);
      }
      print(
          "${waitingSubTaskModel.projectSubTaskModel.projectId}project id is ");
      ProjectModel? projectModel = await projectController.getProjectById(
          id: waitingSubTaskModel.projectSubTaskModel.projectId);
      ManagerModel? managerModel =
          await managerController.getMangerById(id: projectModel!.managerId);
      UserModel manager =
          await userController.getUserWhereMangerIs(mangerId: managerModel!.id);

      //to get the user name to tell the manager about his name in the notification
      UserModel member = await userController.getUserWhereMemberIs(
        memberId: waitingSubTaskModel.projectSubTaskModel.assignedTo,
      );
      print("${member.userName!}member name");
      print(manager.userName!);
      for (var element in manager.tokenFcm) {
        print(element);
      }
      FcmNotifications fcmNotifications = Get.put(FcmNotifications());
      await fcmNotifications.sendNotificationAsJson(
          fcmTokens: manager.tokenFcm,
          title: "${AppConstants.task_got_key} $status",
          body:
              "${member.name} $status ${AppConstants.the_task_key} ${waitingSubTaskModel.projectSubTaskModel.name} ${AppConstants.in_project_key} ${projectModel.name} $memberMessage",
          type: NotificationType.notification);
    } catch (e) {
      CustomSnackBar.showError(e.toString());
    }
  }



///تعديل 
  Stream<QuerySnapshot<WaitingSubTaskModel>> getWaitingSubTasksInMembersId({required List<String> membersId}) {
   return  watingSubTasksRef.where( "subTask.$assignedToK", whereIn: membersId).snapshots().cast<QuerySnapshot<WaitingSubTaskModel>>();
  }
  Future<void> deleteWatingSubTask({required String id}) async {
    WriteBatch batch = fireStore.batch();
    deleteDocUsingBatch(
        documentSnapshot: await watingSubTasksRef.doc(id).get(),
        refbatch: batch);
  }
}
