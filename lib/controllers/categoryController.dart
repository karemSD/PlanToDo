import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/topController.dart';
import 'dart:developer' as dev;
import '../constants/back_constants.dart';
import '../models/User/User_task_Model.dart';
import '../models/task/UserTaskCategory_model.dart';
import '../services/collectionsrefrences.dart';

class TaskCategoryController extends TopController {
  //حلب نوع بواسطة الايدي ستريم
  Stream<DocumentSnapshot<UserTaskCategoryModel>> getCategoryByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> stream =
        getDocByIdStream(reference: userTaskCategoryRef, id: id);
    return stream.cast<DocumentSnapshot<UserTaskCategoryModel>>();
  }

  Future<UserTaskCategoryModel> getCategoryById({required String id}) async {
    DocumentSnapshot doc =
        await getDocById(reference: userTaskCategoryRef, id: id);
    return doc.data() as UserTaskCategoryModel;
  }

  //جلب جميع انواع المهام  الخاصة بمستخدم معين
  Future<List<UserTaskCategoryModel>> getUserCategories(
      {required String userId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: userTaskCategoryRef,
        field: userIdK,
        value: userId);

    return list!.cast<UserTaskCategoryModel>();
  }

  //
  Stream<QuerySnapshot<UserTaskCategoryModel>> getUserCategoriesStream(
      {required String userId}) {
    Stream<QuerySnapshot> stream = queryWhereStream(
        reference: userTaskCategoryRef, field: userIdK, value: userId);
    return stream.cast<QuerySnapshot<UserTaskCategoryModel>>();
  }

//جلب نوع مهمة حسب الأسم
  Future<UserTaskCategoryModel> getCategoryByNameForUser(
      {required String name, required String userId}) async {
    DocumentSnapshot doc = await getDocSnapShotWhereAndWhere(
        collectionReference: userTaskCategoryRef,
        firstField: nameK,
        firstValue: name,
        secondField: userIdK,
        secondValue: userId);
    return doc.data() as UserTaskCategoryModel;
  }

//جلب نوع مهمة حسب الأسم ستريم
  Stream<DocumentSnapshot<UserTaskCategoryModel>>
      getCategoryByNameForUserStream(
          {required String name, required String userId}) async* {
    Stream<DocumentSnapshot> stream = getDocWhereAndWhereStream(
        collectionReference: userTaskCategoryRef,
        firstField: nameK,
        firstValue: name,
        secondField: nameK,
        secondValue: userId);
    yield* stream.cast<DocumentSnapshot<UserTaskCategoryModel>>();
  }

// خاص بجلب جميع التاسكات يلي الها هل الغاتغوري
  Future<List<UserTaskModel>> getTasksByCategory(String folderId) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: usersTasksRef, field: folderIdK, value: folderId);
    return list!.cast<UserTaskModel>();
  }

//
// يجب وجود نوع  محدد يرجع هذه القيمة في الكونترولر الأب
//جلب جميع المهام التي لها نفس النوع
  Future<List<QueryDocumentSnapshot<Object?>>> getTasksByCategoryQuery(
      String folderId) async {
    dev.log("1");
    List<QueryDocumentSnapshot<Object?>> list = await getDocsSnapShotWhere(
        collectionReference: usersTasksRef, field: folderIdK, value: folderId);
    return list;
  }

  // اضافة نوع جديد للمهام والتأكد قبل الاضافة من وجود هذا  المستخدم الذي نضيف له هذا النوع بقاعدة البيانات
  Future<void> addCategory(UserTaskCategoryModel taskCategoryModel) async {
    Exception exception;
    bool? exist = await existByOne(
        collectionReference: usersRef,
        field: idK,
        value: taskCategoryModel.userId);
    if (exist == true) {
      if (await existByTow(
          reference: userTaskCategoryRef,
          field: nameK,
          value: taskCategoryModel.name,
          field2: userIdK,
          value2: taskCategoryModel.userId)) {
        exception =
            Exception(AppConstants.Sorry_but_there_is_Anthor_Category_with_the_same_name_key.tr);
        throw exception;
      }
      addDoc(reference: userTaskCategoryRef, model: taskCategoryModel);
      dev.log("message");
      return;
    }
    exception = Exception(AppConstants.Sorry_the_user_id_cannot_be_found_key.tr);
    throw exception;
  }

//تحديث نوع المهام
  updateCategory(
      {required Map<String, dynamic> data, required String id}) async {
    UserTaskCategoryModel userTaskCategoryModel = await getCategoryById(id: id);
    await updateRelationalFields(
      reference: userTaskCategoryRef,
      data: data,
      id: id,
      fatherField: userIdK,
      fatherValue: userTaskCategoryModel.userId,
      nameException: Exception(AppConstants.category_already_been_added_key.tr),
    );
  }

// حذف صنف محدد من المهام حيث ايضا حذف كل المهام التي لها هذا النوع من المهام  حيث لايمكن إبقاء مهمة بدون نوع لها
  deleteCategory(String categoryId) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot cat =
        await getDocById(reference: userTaskCategoryRef, id: categoryId);
    deleteDocUsingBatch(documentSnapshot: cat, refbatch: batch);
    List<QueryDocumentSnapshot> listTasks = await getDocsSnapShotWhere(
        collectionReference: usersTasksRef, field: folderIdK, value: cat.id);
    deleteDocsUsingBatch(list: listTasks, refBatch: batch);
    batch.commit();
  }
}
