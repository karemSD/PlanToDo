import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/topController.dart';
import '../constants/back_constants.dart';
import '../models/team/TeamMembers_model.dart';
import '../services/collectionsrefrences.dart';

class TeamMemberController extends TopController {
  Future<List<TeamMemberModel>> getMemberWhereUserIs(
      {required String userId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: teamMembersRef, field: userIdK, value: userId);
    return list!.cast<TeamMemberModel>();
  }

  Stream<QuerySnapshot<TeamMemberModel>> getMemberWhereUserIsStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: teamMembersRef, field: userIdK, value: userId);
    return stream.cast<QuerySnapshot<TeamMemberModel>>();
  }

  // Future<List<TeamMemberModel>> getAllTeams() async {
  //   List<Object?>? list = await getAllListDataForRef(refrence: teamMembersRef);

  //   return list!.cast<TeamMemberModel>();
  // }

  // Stream<QuerySnapshot<TeamMemberModel>> getAllTeamsStream() {
  //   Stream<QuerySnapshot> stream =
  //       getAllListDataForRefStream(refrence: teamMembersRef);
  //   return stream.cast<QuerySnapshot<TeamMemberModel>>();
  // }

  Future<TeamMemberModel> getMemberById({required String memberId}) async {
    DocumentSnapshot doc =
        await getDocById(reference: teamMembersRef, id: memberId);
    return doc.data() as TeamMemberModel;
  }

  Stream<DocumentSnapshot<TeamMemberModel>> getMamberByIdStream(
      {required String memberId}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: teamMembersRef, id: memberId);
    return stream.cast<DocumentSnapshot<TeamMemberModel>>();
  }

  Future<List<TeamMemberModel>> getMembersInTeamId(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: teamMembersRef, field: teamIdK, value: teamId);
    List<TeamMemberModel> listOfMembers = list!.cast<TeamMemberModel>();
    return listOfMembers;
  }

  Stream<QuerySnapshot<TeamMemberModel>> getMembersInTeamIdStream(
      {required String teamId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: teamMembersRef, field: teamIdK, value: teamId);
    return stream.cast<QuerySnapshot<TeamMemberModel>>();
  }

  Future<TeamMemberModel> getMemberByTeamIdAndUserId(
      {required String teamId, required String userId}) async {
    DocumentSnapshot doc = await getDocSnapShotWhereAndWhere(
        collectionReference: teamMembersRef,
        firstField: teamIdK,
        firstValue: teamId,
        secondField: userIdK,
        secondValue: userId);
    return doc.data() as TeamMemberModel;
  }

  Stream<DocumentSnapshot<TeamMemberModel>> getMemberByTeamIdAndUserIdStream(
      {required String teamId, required String userId}) {
    Stream<DocumentSnapshot> stream = getDocWhereAndWhereStream(
        collectionReference: teamMembersRef,
        firstField: teamIdK,
        firstValue: teamId,
        secondField: userIdK,
        secondValue: userId);
    return stream.cast<DocumentSnapshot<TeamMemberModel>>();
  }

//بركي العضو موجود وعم ضيفو مرة تانية
  Future<void> addMember({required TeamMemberModel teamMemberModel}) async {
    Exception exception;
    if (await existInTowPlaces(
      firstCollectionReference: usersRef,
      firstFiled: idK,
      firstvalue: teamMemberModel.userId,
      secondCollectionReference: teamsRef,
      secondFiled: idK,
      secondValue: teamMemberModel.teamId,
    )) {
      if (await existByTow(
          reference: teamMembersRef,
          value: userIdK,
          field: teamMemberModel.userId,
          value2: teamIdK,
          field2: teamMemberModel.teamId)) {
        exception = Exception(AppConstants.user_already_added_error_key.tr);
        throw exception;
      }
      addDoc(reference: teamMembersRef, model: teamMemberModel);
    } else {
      exception = Exception(AppConstants.team_user_not_found_error_key.tr);
      throw exception;
    }
  }

  Future<void> updateMemeber(
      {required id, required Map<String, dynamic> data}) async {
    Exception exception;
    if (data.containsKey(teamIdK) || data.containsKey(userIdK)) {
      exception = Exception(AppConstants.team_user_id_update_error_key.tr);
      throw exception;
    }

    await updateNonRelationalFields(
      reference: teamMembersRef,
      data: data,
      id: id,
      nameException: Exception(),
    );
  }

  Future<void> deleteMember({required String id}) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot member =
        await getDocById(reference: teamMembersRef, id: id);
    List<DocumentSnapshot> listOfSubTasks = await getDocsSnapShotWhere(
        collectionReference: projectSubTasksRef, field: assignedToK, value: id);
    deleteDocUsingBatch(documentSnapshot: member, refbatch: batch);
    deleteDocsUsingBatch(list: listOfSubTasks, refBatch: batch);
    batch.commit();
  }
}
