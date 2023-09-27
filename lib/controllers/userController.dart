import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/topController.dart';

import '../Utils/back_utils.dart';
import '../constants/back_constants.dart';
import '../models/User/User_model.dart';
import '../models/User/User_task_Model.dart';
import '../models/task/UserTaskCategory_model.dart';
import '../models/team/Manger_model.dart';
import '../models/team/TeamMembers_model.dart';
import '../services/collectionsrefrences.dart';
import 'categoryController.dart';
import 'manger_controller.dart';

class UserController extends TopController {
  Future<UserModel> getUserById({required String id}) async {
    DocumentSnapshot doc = await getDocById(reference: usersRef, id: id);
    return doc.data() as UserModel;
  }

  Future<List<UserModel>> getAllUsers() async {
    List<Object?>? list = await getAllListDataForRef(refrence: usersRef);
    List<UserModel> users = list!.cast<UserModel>();
    print(users);
    return list.cast<UserModel>();
  }

  Stream<QuerySnapshot<UserModel>> getAllUsersStream() {
    Stream<QuerySnapshot> stream =
        getAllListDataForRefStream(refrence: usersRef);
    return stream.cast<QuerySnapshot<UserModel>>();
  }

  Future<UserModel> getUserOfTask({required String userTaskId}) async {
    DocumentSnapshot userTaskDoc = await usersTasksRef.doc(userTaskId).get();
    UserTaskModel userTaskModel = userTaskDoc.data() as UserTaskModel;
    //القسم الفوقاني بهل الميثود بيستبدل بجلب الميثود عن طريق الايدي بس ليصير موجود كونترولر التاسك يوزر جاهز
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: userTaskModel.userId);
    return userDoc.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserOfTaskStream(
      {required String userTaskId}) async* {
    DocumentSnapshot userTaskDoc = await usersTasksRef.doc(userTaskId).get();
    UserTaskModel userTaskModel = userTaskDoc.data() as UserTaskModel;
    //القسم الفوقاني بهل الميثود بيستبدل بجلب الميثود عن طريق الايدي بس ليصير موجود كونترولر التاسك يوزر جاهز
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: userTaskModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserByUserName(
      {required String name, required String userName}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: usersRef, field: userNameK, value: userName, name: name);
    return documentSnapshot.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserByUserNameStream(
      {required String name, required String userName}) async* {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: usersRef, field: userNameK, value: userName, name: name);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserOfCategory({required String categoryId}) async {
    TaskCategoryController taskCategoryController =
        Get.put(TaskCategoryController());
    UserTaskCategoryModel userTaskCategoryModel =
        await taskCategoryController.getCategoryById(id: categoryId);
    UserModel userModel = await getUserById(id: userTaskCategoryModel.userId);
    return userModel;
  }

  getUserOfcategoryStream({required String categoryId}) async* {
    TaskCategoryController taskCategoryController =
        Get.put(TaskCategoryController());
    UserTaskCategoryModel userTaskCategoryModel =
        await taskCategoryController.getCategoryById(id: categoryId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: userTaskCategoryModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Stream<DocumentSnapshot<UserModel>> getUserByIdStream({required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: id);
    return stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserWhereMangerIs({required String mangerId}) async {
    ManagerController mangerController = Get.put(ManagerController());
    ManagerModel managerModel =
        await mangerController.getMangerById(id: mangerId);
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: managerModel.userId);
    return userDoc.data() as UserModel;
  }

  Stream<DocumentSnapshot<UserModel>> getUserWhereMangerIsStream(
      {required String mangerId}) async* {
    ManagerController mangerController = Get.put(ManagerController());
    ManagerModel managerModel =
        await mangerController.getMangerById(id: mangerId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: managerModel.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<UserModel> getUserWhereMemberIs({required String memberId}) async {
    TeamMemberController memberController = Get.put(TeamMemberController());
    TeamMemberModel member =
        await memberController.getMemberById(memberId: memberId);
    DocumentSnapshot userDoc =
        await getDocById(reference: usersRef, id: member.userId);
    return userDoc.data() as UserModel;
  }

  Stream<QuerySnapshot<UserModel>> getUsersWhereInIdsStream(
      {required List<String> usersId}) {
        
    Stream<QuerySnapshot<UserModel>> users =
        usersRef.where(idK, whereIn: usersId).snapshots();
    return users;
  }

  Future<List<UserModel>> getUsersWhereInIds(
      {required List<String> usersId}) async {
    QuerySnapshot<UserModel> users =
        await usersRef.where(idK, whereIn: usersId).get();
    List<UserModel> usersList = [];
    for (var element in users.docs) {
      usersList.add(element.data());
    }
    return usersList;
  }

  Stream<DocumentSnapshot<UserModel>> getUserWhereMemberIsStream(
      {required String memberId}) async* {
    TeamMemberController memberController = Get.put(TeamMemberController());
    TeamMemberModel member =
        await memberController.getMemberById(memberId: memberId);
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: usersRef, id: member.userId);
    yield* stream.cast<DocumentSnapshot<UserModel>>();
  }

  Future<void> createUser({required UserModel userModel}) async {
    await userModel.addTokenFcm();
    await addDoc(reference: usersRef, model: userModel);
  }

  Future<void> updateUser(
      {required Map<String, dynamic> data, required String id}) async {
    // await updateNonRelationalFields(
    //     reference: usersRef,
    //     data: data,
    //     id: id,
    //     nameException: Exception("user name already been taken"));
    // // await updateFields(reference: usersRef, data: data, id: id);
    if (data.containsKey(idK)) {
      Exception exception = Exception(AppConstants.userId_update_error_key.tr);
      throw exception;
    }
    data[updatedAtK] = firebaseTime(DateTime.now());
    usersRef.doc(id).update(data);
  }

  Future<void> deleteUser({required String id}) async {
    ManagerController mangerController = Get.put(ManagerController());
    WriteBatch batch = fireStore.batch();
    List<DocumentSnapshot> membrs = await getDocsSnapShotWhere(
        collectionReference: teamMembersRef, field: userIdK, value: id);
    List<DocumentSnapshot> listAllSubTasks = [];
    deleteDocsUsingBatch(list: membrs, refBatch: batch);
    for (var member in membrs) {
      List<DocumentSnapshot> listOfSubTasks = await getDocsSnapShotWhere(
          collectionReference: projectSubTasksRef,
          field: assignedToK,
          value: member.id);
      listAllSubTasks.addAll(listOfSubTasks);
    }
    deleteDocsUsingBatch(list: listAllSubTasks, refBatch: batch);
    //  UserModel userModel = await getUserById(id: id);
    // firebaseStorage.refFromURL(userModel.imageUrl).delete();
    ManagerModel? managerModel =
        await mangerController.getMangerWhereUserIs(userId: id);
    deleteDocUsingBatch(
        documentSnapshot: await usersRef.doc(id).get(), refbatch: batch);

    await mangerController.deleteManger(
        id: managerModel!.id, writeBatch: batch);
  }
}
