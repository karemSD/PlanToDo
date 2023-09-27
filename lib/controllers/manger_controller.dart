import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';

import 'package:mytest/controllers/topController.dart';

import '../constants/back_constants.dart';
import '../models/team/Manger_model.dart';
import '../models/team/Team_model.dart';
import '../services/collectionsrefrences.dart';
import 'teamController.dart';

class ManagerController extends TopController {
  Future<void> addManger(ManagerModel model) async {
    if (await existByOne(
        collectionReference: usersRef, field: idK, value: model.userId)) {
      addDoc(reference: managersRef, model: model);
    } else {
      Exception exception = Exception(AppConstants.Sorry_the_user_id_cannot_be_found_key.tr);
      throw exception;
    }
  }

  Future<ManagerModel> getMangerById({required String id}) async {
    DocumentSnapshot mangerDoc =
        await getDocById(reference: managersRef, id: id);
    return mangerDoc.data() as ManagerModel;
  }

  Future<List<ManagerModel>> getUserManager({required String userId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: managersRef, field: userIdK, value: userId);
    return list!.cast<ManagerModel>();
  }

  //! i dont know why he did not user "getMangerWhereUserIs"
  Stream<QuerySnapshot<ManagerModel>> getUserManagerStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = (queryWhereStream(
        reference: managersRef, field: userIdK, value: userId));
    return stream.cast<QuerySnapshot<ManagerModel>>();
  }

  Future<ManagerModel> getManagerOrMakeOne({required String userId}) async {
    ManagerModel? managerModel;
    managerModel = await getMangerWhereUserIs(userId: userId);
    if (managerModel != null) {
      return managerModel;
    }
    managerModel = ManagerModel(
        idParameter: managersRef.doc().id,
        userIdParameter: userId,
        createdAtParameter: DateTime.now(),
        updatedAtParameter: DateTime.now());
    await addManger(managerModel);
    return managerModel;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: managersRef, id: id);
    return stream.cast<DocumentSnapshot<ManagerModel>>();
  }

  // Future<ManagerModel> getMangerOfTeam(String mangerId) async {
  //   DocumentSnapshot? doc = await getDocSnapShotWhere(
  //       collectionReference: managersRef, field: idK, value: mangerId);
  //   return doc!.data() as ManagerModel;
  // }
  //karem
  Future<ManagerModel> getMangerOfTeam({required String teamId}) async {
    TeamController teamController = Get.put(TeamController());
    TeamModel teamModel = await teamController.getTeamById(id: teamId);
    ManagerModel managerModel = await getMangerById(id: teamModel.managerId);
    return managerModel;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerOfTeamStream(
      String teamId) async* {
    TeamController teamController = Get.put(TeamController());
    TeamModel teamModel = await teamController.getTeamById(id: teamId);
    Stream<DocumentSnapshot> docStream = getDocWhereStream(
      collectionReference: managersRef,
      field: idK,
      value: teamModel.managerId,
    );
    yield* docStream.cast<DocumentSnapshot<ManagerModel>>();
  }

  Future<ManagerModel?> getMangerWhereUserIs({required String userId}) async {
    DocumentSnapshot? doc = await getDocSnapShotWhere(
        collectionReference: managersRef, field: userIdK, value: userId);
    return doc?.data() as ManagerModel?;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerWhereUserIsStream(
      String userId) {
    Stream<DocumentSnapshot> doc = getDocWhereStream(
        collectionReference: managersRef, field: userIdK, value: userId);
    return doc.cast<DocumentSnapshot<ManagerModel>>();
  }

  // Future<ManagerModel?> getMangerOfProject(String mangerId) async {
  //   DocumentSnapshot? doc = await getDocSnapShotWhere(
  //       collectionReference: managersRef, field: idK, value: mangerId);
  //   return doc!.data() as ManagerModel;

  // }
  Future<ManagerModel?> getMangerOfProject({required String projectId}) async {
    DocumentSnapshot? doc = await getDocSnapShotWhere(
        collectionReference: managersRef, field: idK, value: projectId);
    return doc!.data() as ManagerModel;
  }

  Stream<DocumentSnapshot<ManagerModel>> getMangerOfProjectStream(
      String mangerId) {
    Stream<DocumentSnapshot> doc = getDocWhereStream(
        collectionReference: managersRef, field: idK, value: mangerId);
    return doc.cast<DocumentSnapshot<ManagerModel>>();
  }

  Future<void> updateManger(String id, Map<String, dynamic> data) async {
    if (data.containsKey(userIdK)) {
      Exception exception = Exception(AppConstants.userId_update_error_key.tr);
      throw exception;
    }
    await updateNonRelationalFields(
        reference: managersRef, data: data, id: id, nameException: Exception());
  }

  Future<void> deleteManger(
      {required String id, WriteBatch? writeBatch}) async {
    WriteBatch batch = fireStore.batch();
    if (writeBatch != null) {
      batch = writeBatch;
    }

    //جلب المانجر
    DocumentSnapshot? doc = await getDocSnapShotWhere(
        collectionReference: managersRef, field: idK, value: id);
    //جلب جميع التيمات يلي الهن المناجر هاد
    List<DocumentSnapshot?>? teams = await getDocsSnapShotWhere(
        collectionReference: teamsRef, field: managerIdK, value: id);
    //حذف المانجر
    deleteDocUsingBatch(documentSnapshot: doc, refbatch: batch);
    //حذف التيمات يلي جبناهن
    deleteDocsUsingBatch(list: teams, refBatch: batch);

    List<DocumentSnapshot> members = [];
    //اضافة جميع اضاء هذه التيمات الى ليست الاعضاء
    for (var team in teams) {
      DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
          collectionReference: teamMembersRef, field: teamIdK, value: team!.id);
      members.add(documentSnapshot!);
    }
    //حذف جميع الاعضاء الذي تم جلبهم
    deleteDocsUsingBatch(list: members, refBatch: batch);
    //جلب جميع البروجكتات يلي مشترك فيها واحد من التيمات يلي الها المانجر هاد
    List<DocumentSnapshot?> listProjects = [];
    for (var team in teams) {
      print("it passed");
      List<DocumentSnapshot?>? projectDos = await getDocsSnapShotWhere(
          collectionReference: projectsRef, field: teamIdK, value: team!.id);
      listProjects.addAll(projectDos);
    }
    //حذف جميع البروجكتات التي تم جليها
    deleteDocsUsingBatch(list: listProjects, refBatch: batch);
    //جلب جميع المهمات الرئيسية التي تنتمي لاحد المشاريع التي لها التيم الذي له هل المانجر الذي يحذف
    List<DocumentSnapshot> listMainTasks = [];
    for (var project in listProjects) {
      List<DocumentSnapshot> mainTasks = await getDocsSnapShotWhere(
          collectionReference: projectMainTasksRef,
          field: projectIdK,
          value: project!.id);
      listMainTasks.addAll(mainTasks);
    }
    //حذف جميع المهام الرئيسية التي تم جلبها قبل قليل
    deleteDocsUsingBatch(list: listMainTasks, refBatch: batch);
    //جلب جميع المهام التي تتبع لأحد المهام الرئيسية التي سوف يتم حذفها
    List<DocumentSnapshot> listSubTasks = [];
    for (var mainTask in listMainTasks) {
      List<DocumentSnapshot> subTasks = await getDocsSnapShotWhere(
          collectionReference: projectSubTasksRef,
          field: mainTaskIdK,
          value: mainTask.id);
      listSubTasks.addAll(subTasks);
    }
    //حذف جميع المهام الفرعية التي تتبع لأي مهمة رئيسة من المهام السابقة
    deleteDocsUsingBatch(list: listSubTasks, refBatch: batch);
    batch.commit();
  }
}
