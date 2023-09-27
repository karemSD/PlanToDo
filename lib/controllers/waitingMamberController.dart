import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/manger_controller.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/team/waitingMamber.dart';
import 'package:mytest/services/collectionsrefrences.dart';

import '../constants/back_constants.dart';
import '../models/User/User_model.dart';
import '../models/team/TeamMembers_model.dart';
import '../models/team/Team_model.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/types.dart';

class WaitingMamberController extends TopController {
  //جبلي هل الشخص يلي لسع مو قبلان دعوة الانضمام
  Future<WaitingMemberModel> getWaitingMemberById(
      {required String watingmemberId}) async {
    DocumentSnapshot doc =
        await getDocById(reference: watingMamberRef, id: watingmemberId);
    return doc.data() as WaitingMemberModel;
  }

//عرض جميع الأشخاص يلي بعتلن دعوة للانضمام لهل الفريق وماقبلوها لسع
  Future<List<WaitingMemberModel>> getWaitingMembersInTeamId(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: watingMamberRef, field: teamIdK, value: teamId);
    List<WaitingMemberModel> listOfMembers = list!.cast<WaitingMemberModel>();
    return listOfMembers;
  }

//عرض  الشخص يلي بعتلو دعوة للانضمام لهل الفريق وماقبلهاا لسع
  Future<WaitingMemberModel> getWaitingMemberByTeamIdAndUserId(
      {required String teamId, required String userId}) async {
    DocumentSnapshot doc = await getDocSnapShotWhereAndWhere(
        collectionReference: watingMamberRef,
        firstField: teamIdK,
        firstValue: teamId,
        secondField: userIdK,
        secondValue: userId);
    return doc.data() as WaitingMemberModel;
  }

//عرض  الشخص يلي بعتلو دعوة للانضمام لهل الفريق وماقبلهاا لسع
  Stream<DocumentSnapshot<WaitingMemberModel>>
      getWaitingMemberByTeamIdAndUserIdStream(
          {required String teamId, required String userId}) {
    Stream<DocumentSnapshot> stream = getDocWhereAndWhereStream(
        collectionReference: watingMamberRef,
        firstField: teamIdK,
        firstValue: teamId,
        secondField: userIdK,
        secondValue: userId);
    return stream.cast<DocumentSnapshot<WaitingMemberModel>>();
  }

  Stream<QuerySnapshot<WaitingMemberModel>> getWaitingMembersInUserIdStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: watingMamberRef, field: userIdK, value: userId);
    return stream.cast<QuerySnapshot<WaitingMemberModel>>();
  }

//عرض جميع الأشخاص يلي بعتلن دعوة للانضمام لهل الفريق وماقبلوها لسع
  Stream<QuerySnapshot<WaitingMemberModel>> getWaitingMembersInTeamIdStream(
      {required String teamId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: watingMamberRef, field: teamIdK, value: teamId);
    return stream.cast<QuerySnapshot<WaitingMemberModel>>();
  }

  Future<DocumentSnapshot> getWaitingMemberDoc(
      {required String waitingmemberId}) async {
    return await getDocById(reference: watingMamberRef, id: waitingmemberId);
  }

  Future<void> addWaitingMamber(
      {required WaitingMemberModel waitingMemberModel}) async {
    Exception exception;
    if (await existInTowPlaces(
        firstCollectionReference: usersRef,
        firstFiled: idK,
        firstvalue: waitingMemberModel.userId,
        secondCollectionReference: teamsRef,
        secondFiled: idK,
        secondValue: waitingMemberModel.teamId)) {
      if (waitingMemberModel.userId ==
          AuthService.instance.firebaseAuth.currentUser!.uid) {
        exception =
            Exception(AppConstants.manager_cannot_be_member_error_key.tr);
        throw exception;
      }
      if (await existByTow(
          reference: watingMamberRef,
          value: waitingMemberModel.userId,
          field: userIdK,
          value2: waitingMemberModel.teamId,
          field2: teamIdK)) {
        exception = Exception(AppConstants.member_already_invited_key.tr);
        throw exception;
      }
      addDoc(reference: watingMamberRef, model: waitingMemberModel);
    } else {
      exception = Exception(AppConstants.team_user_not_found_error_key.tr);
      throw exception;
    }
  }

  Future<void> acceptTeamInvite({required String waitingMemberId}) async {
    print("step1");
    await teamInviteHandler(
        waitingMemberId: waitingMemberId, isAccepted: true, memberMessage: '');
    print("step done");
  }

  Future<void> declineTeamInvite({
    required String waitingMemberId,
    required String rejectingMessage,
  }) async {
    String reasonforRejection = "${AppConstants.rejection_reason_key.tr} $rejectingMessage";
    await teamInviteHandler(
      waitingMemberId: waitingMemberId,
      isAccepted: false,
      memberMessage: reasonforRejection,
    );
  }

  Future<void> teamInviteHandler({
    required String waitingMemberId,
    required bool isAccepted,
    required String memberMessage,
  }) async {
   String status = isAccepted
        ? AppConstants.accepted_key.tr
        : AppConstants.rejected_key.tr;
    //user Controller to send the notification to the manager about whether the user acepted the invite or not
    UserController userController = Get.put(UserController());
    //to get the team model so we get the manager model and then get the manager user profile to sned the notification
    TeamController teamController = Get.put(TeamController());
    print("step2");
    WaitingMemberModel waitingMember =
        await getWaitingMemberById(watingmemberId: waitingMemberId);

    print("step3");
    deleteWaitingMamberDoc(waitingMemberId: waitingMemberId);

    print("step4");

    if (isAccepted) {
      //to add the invited member to the team
      TeamMemberController teamMemberController =
          Get.put(TeamMemberController());

      TeamMemberModel teamMemberModel = TeamMemberModel(
        idParameter: teamMembersRef.doc().id,
        userIdParameter: waitingMember.userId,
        teamIdParameter: waitingMember.teamId,
        createdAtParameter: DateTime.now(),
        updatedAtParameter: DateTime.now(),
      );
      await teamMemberController.addMember(teamMemberModel: teamMemberModel);
    }
    print("step5");

    TeamModel teamModel =
        await teamController.getTeamById(id: waitingMember.teamId);
    print("step6");

    UserModel manager = await userController.getUserWhereMangerIs(
        mangerId: teamModel.managerId);
    print("step7");

    //to get the user name to tell the manager about his name in the notification
    UserModel member = await userController.getUserById(
        id: AuthService.instance.firebaseAuth.currentUser!.uid);

    print("step8");

    FcmNotifications fcmNotifications = Get.put(FcmNotifications());
    await fcmNotifications.sendNotification(
        fcmTokens: manager.tokenFcm,
        title: "${AppConstants.invite_got_key.tr} $status",
        body:
            "${member.name} $status ${AppConstants.invite_to_team_key.tr} ${teamModel.name} $memberMessage",
        type: NotificationType.notification);
    print("step9");
  }

//حذفو بعد الرفض او القبول والانضمام
  Future<void> deleteWaitingMamberDoc({required String waitingMemberId}) async {
    WriteBatch batch = fireStore.batch();
    deleteDocUsingBatch(
        documentSnapshot: await watingMamberRef.doc(waitingMemberId).get(),
        refbatch: batch);
    batch.commit();
  }
}
