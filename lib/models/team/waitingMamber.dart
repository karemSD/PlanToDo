import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/TopModel_model.dart';

class WaitingMemberModel with TopModel {
  WaitingMemberModel({
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
  set setCreatedAt(DateTime createdAtParameter) {
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //تاريخ تحديث الدوكيومنت الخاص بالعضو ا يمكن أن يكون قبل تاريخ الإنشاء
    if (updatedAtParameter.isBefore(firebaseTime(createdAt))) {
      exception =
          Exception(AppConstants.waiting_team_member_updating_time_before_create_error_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  //لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory WaitingMemberModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return WaitingMemberModel(
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

  @override
  set setId(String id) {
    this.id = id;
  }
}
