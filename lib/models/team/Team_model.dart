import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/VarTopModel.dart';

class TeamModel extends VarTopModel {
  //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
  late String imageUrl;
  //forgin kay from MangerModel
  // الايدي الخاص بقائد الفريق  لايمكن ان يكون فارغ لانه لايوجد قائد بدون فريق
  late String managerId;

  TeamModel({
    //الاي دي الخاص بالفريق
    //primary key
    required String idParameter,
    //الاي دي الخاص بمدير الفريق
    //foreign key
    required String managerIdParameter,
    //اسم الفريق
    required String nameParameter,
    //صورة الفريق
    required String imageUrlParameter,
    //تاريخ إنشاء الفريق
    required DateTime createdAtParameter,
    //تاريخ تحديث معلومات الفريق
    required DateTime updatedAtParameter,
  }) {
    setId = idParameter;
    setmangerId = managerIdParameter;
    setName = nameParameter;
    setImageUrl = imageUrlParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }
  TeamModel.firestoreConstructor({
    required String idParameter,
    //الاي دي الخاص بمدير الفريق
    //foreign key
    required String mangerIdParameter,
    //اسم الفريق
    required String nameParameter,
    //صورة الفريق
    required String imageUrlParameter,
    //تاريخ إنشاء الفريق
    required DateTime createdAtParameter,
    //تاريخ تحديث معلومات الفريق
    required DateTime updatedAtParameter,
  }) {
    id = idParameter;
    managerId = mangerIdParameter;
    name = nameParameter;
    imageUrl = imageUrlParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
  }

  set setmangerId(String mangerId) {
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    managerId = mangerId;
  }

  set setImageUrl(String imageUrl) {
    Exception exception;
    if (imageUrl.isEmpty) {
      //لا يمكن أن يكون رابط صورة الفريق فارغاً
      exception = Exception(AppConstants.team_image_empty_error_key.tr);
      throw exception;
    }
    this.imageUrl = imageUrl;
  }

  @override
  set setId(String id) {
    Exception exception;
    //اي دي  الدوكيومنت الخاص بالفريق لا يمكن أن يكون فارغاً
    if (id.isEmpty) {
      exception = Exception(AppConstants.team_id_empty_error_key.tr);
      throw exception;
    }
    this.id = id;
  }

  @override
  set setName(String name) {
    Exception exception;

    //هذه الخاصية تستخدم لوضع قيمة لاسم الفئة وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق

    if (name.isEmpty) {
      //اسم الفريق لا يمكن أن يكون فارغاً
      exception = Exception(AppConstants.team_name_empty_error_key.tr);
      throw exception;
    }
    if (name.length <= 3) {
      //لايمكن ان يكون اسم الفريق مؤلفاً من اقل من ثلاث محارف
      exception = Exception(AppConstants.team_name_min_length_error_key.tr);
      throw exception;
    }
    //في حال مرروره على جميع الشروط وعدم رمي اكسيبشن فذلك يعني تحقيقه للشروط المطلوبة وعندها سيتم وضع القيمة
    this.name = name;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());
    //تاريخ إضافة  الدوكيومنت الخاص بالفريق لا يمكن أن يكون بعد الوقت الحالي
    if (createdAtParameter.isAfter(now)) {
      exception = Exception(AppConstants.team_creating_time_future_error_key.tr);
      throw exception;
    }
    //تاريخ إضافة الدوكيومنت الخاص بالفريق لا يمكن أن يكون قبل الوقت الحالي
    if (firebaseTime(createdAtParameter).isBefore(now)) {
      exception = Exception(AppConstants.team_creating_time_past_error_key.tr);
      throw exception;
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //تاريخ تحديث الدوكيومنت الخاص بالفريق لا يمكن أن يكون قبل تاريخ الإنشاء
    if (updatedAtParameter.isBefore(createdAt)) {
      exception =
          Exception(AppConstants.team_updating_time_before_creation_error_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

// لاخذ الداتا القادمة من الجيسون وتحويلها  إلى داتا مودل
  factory TeamModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;

    return TeamModel.firestoreConstructor(
      idParameter: data[idK],
      mangerIdParameter: data[managerIdK],
      nameParameter: data[nameK],
      imageUrlParameter: data[imageUrlK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }
  // لترحيل بيانات المودل إلى الداتا بيز بالشكل المطلوب كجيسين
  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[idK] = id;
    data[managerIdK] = managerId;
    data[nameK] = name;
    data[imageUrlK] = imageUrl;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }
}
