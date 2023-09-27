import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/TopModel_model.dart';

class TeamMemberModel with TopModel {
  TeamMemberModel({
    //primary kay
    //الايدي الخاص بالعضو في الفريق وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String idParameter,
    //foriegn kay from UserModel
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    required String userIdParameter,
    //الاي دي الخاص بالتيم الذي يضم العضو
    required String teamIdParameter,
    //وقت إنشاء الدوكيومنت الخاص بالعضو في الفريق
    required DateTime createdAtParameter,
    //وقت تعديل الدوكيومنت الخاص بالعضو في الفريق
    required DateTime updatedAtParameter,
  }) {
    setUserId = userIdParameter;
    setTeamId = teamIdParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }
  TeamMemberModel.firestoreConstructor({
    //primary kay
    //الايدي الخاص بالعضو في الفريق وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String idParameter,
    //foriegn kay from UserModel
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    required String userIdParameter,
    //الاي دي الخاص بالتيم الذي يضم العضو
    required String teamIdParameter,
    //وقت إنشاء الدوكيومنت الخاص بالعضو في الفريق
    required DateTime createdAtParameter,
    //وقت تعديل الدوكيومنت الخاص بالعضو في الفريق
    required DateTime updatedAtParameter,
  }) {
    userId = userIdParameter;
    teamId = teamIdParameter;
    id = idParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
  }
  //forgin kay from UserModel
  //الايدي الخاص بالمستخدم مالك المهمه لايمكن ان يكون فارغ وإلا لمين هل المهمة ؟
  //ملاحظة هامة/// يجب عند إسناد هل الايدي نروح نعمل كويري نشوف هل الايدي موجود او لأ
  late String userId;
  //forgin kay from TeamModel
  //ايدي الفريق الذي ينتمي إليه لذلك لايمكن ان يكون فارغ
  late String teamId;

  set setTeamId(String teamId) {
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.teamId = teamId;
  }

  set setUserId(String userId) {
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.userId = userId;
  }

  @override
  set setId(String idParameter) {
    Exception exception;
    //اذا كان إذا كان الاي دي الخاص بدوكيومنت العضو فارغ يتم رفضه
    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.team_member_id_empty_error_key.tr);
      throw exception;
    }
    id = idParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());
    //تاريخ إضافة الدوكيومنت الخاص بالعضو  لا يمكن أن يكون بعد الوقت الحالي
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      exception =
          Exception(AppConstants.team_member_creating_time_future_error_key.tr);
      throw exception;
    }
    //تاريخ إضافةالدوكيومنت الخاص بالعضو لا يمكن أن يكون قبل الوقت الحالي
    if (firebaseTime(createdAtParameter).isBefore(now)) {
      exception = Exception(AppConstants.team_member_creating_time_past_error_key.tr);
      throw exception;
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //تاريخ تحديث الدوكيومنت الخاص بالعضو ا يمكن أن يكون قبل تاريخ الإنشاء
    if (updatedAtParameter.isBefore(createdAt)) {
      exception =
          Exception(AppConstants.team_member_updating_time_before_create_error_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  //لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory TeamMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return TeamMemberModel.firestoreConstructor(
      idParameter: data[idK],
      userIdParameter: data[userIdK],
      teamIdParameter: data[teamIdK],
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
    data[teamIdK] = teamId;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }
}
