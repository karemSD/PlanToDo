import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/TopModel_model.dart';

class ManagerModel with TopModel {
  //الايدي الخاص بالمستخدم الذي هو القائد لايمكن ان يكون فارغ وإلا مين هو ؟
  //ملاحظة هامة/// يجب عند إسناد هل الايدي نروح نعمل كويري نشوف هل الايدي موجود او لأ
  late String userId;

  ManagerModel({
    //primary kay
    //الايدي الخاص بقائد الفريق  وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String idParameter,
    //forgin kay from UserModel
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    required String userIdParameter,
    //الوقت الذي أنشأ المستخدم أول فريق له وكان مديراً عليه
    required DateTime createdAtParameter,
    //الوقت الذي يمثل أي تعديل يحصل على قائد الفريق
    required DateTime updatedAtParameter,
  }) {
    setUserId = userIdParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }
  ManagerModel.firestoreConstructor({
    //primary kay
    //الايدي الخاص بقائد الفريق  وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String idParameter,
    //forgin kay from UserModel
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    required String userIdParameter,
    //الوقت الذي أنشأ المستخدم أول فريق له وكان مديراً عليه
    required DateTime createdAtParameter,
    //الوقت الذي يمثل أي تعديل يحصل على قائد الفريق
    required DateTime updatedAtParameter,
  }) {
    id = idParameter;
    userId = userIdParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
  }
  set setUserId(String userIdParameter) {
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    userId = userIdParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    //لا يمكن أن يكون وقت إنشاء دوكيومنت الخاص بالمدير قبل الوقت الحالي
    if (createdAtParameter.isBefore(now)) {
      exception = Exception(AppConstants.manager_creating_time_before_now_invalid_key.tr);
      throw exception;
    }
    //لا يمكن أن يكون وقت إنشاء دوكيومنت الخاص بالمدير بعد الوقت الحالي

    if (createdAtParameter.isAfter(now)) {
      exception = Exception(AppConstants.manager_creating_time_not_in_future_invalid_key.tr);
      throw exception;
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setId(String idParameter) {
    Exception exception;
    //لا يمكن أن يكون اي دي الدوكمنت الخاص بالمدير  فارغاً
    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.manager_id_empty_key.tr);
      throw exception;
    }

    id = idParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //لا يمكن أن يكون تاريخ تحديث الدوكمنت الخاص بالمدير قبل تاريخ الإنشاء
    if (updatedAtParameter.isBefore(createdAt)) {
      exception = Exception(AppConstants.updating_time_before_creating_invalid_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  //لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory ManagerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return ManagerModel.firestoreConstructor(
      idParameter: data[idK],
      userIdParameter: data[userIdK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[idK] = id;
    data[userIdK] = userId;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return "manager id is $id user Id is $userId  createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
