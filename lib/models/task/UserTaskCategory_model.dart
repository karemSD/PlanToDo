import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../tops/VarTopModel.dart';

class UserTaskCategoryModel extends VarTopModel {
// لانو ببساطة هيك مارح يمرق عالخصائص ومارح يشوف الشروط كلها عبعضها ورح تفوت الدنيا بالحيط لانو رح يعطي القيمة ضغري للحقل تبع الكائن  // ملاحظة هامة جدا : ليش انا استخدمت حقول جديدة بقلب الباني وما استخدمت this.

  UserTaskCategoryModel({
    //primary kay
    //الايدي الخاص بالفئة وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String idParameter,
    required String hexColorParameter,
    //forgin kay from UserModel
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    required String userIdParameter,
    //لاسم الخاص بصنف المهام
    required String nameParameter,
    //وقت إنشاء هذه النوع من المهام
    required DateTime createdAtParameter,
    //الوقت الذي يمثل تاريخ اي تعديل يحصل على فئة المهام
    required DateTime updatedAtParameter,
    required int iconCodePointParameter,
    required String? fontfamilyParameter,
  }) {
    setUserId = userIdParameter;
    setName = nameParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setHexColor = hexColorParameter;
    setIcon = iconCodePointParameter;
    setFontfamily = fontfamilyParameter;
  }
  late String? fontfamily;
  set setFontfamily(String? fontfamilyParameter) {
    fontfamily = fontfamilyParameter;
  }

  //الايدي الخاص بالمستخدم مالك المهمه لايمكن ان يكون فارغ وإلا لمين هل المهمة ؟
  //ملاحظة هامة/// يجب عند إسناد هل الايدي نروح نعمل كويري نشوف هل الايدي موجود او لأ
  late String userId;
  late int iconCodePoint;
  set setIcon(int iconCodePointParameter) {
    iconCodePoint = iconCodePointParameter;
  }

  late String hexColor;
  set setHexColor(String hexColorParameter) {
    Exception exception;
    if (hexColorParameter.isEmpty) {
      exception = Exception(AppConstants.category_color_empty_key);
      throw exception;
    }
    hexColor = hexColorParameter;
  }
//غلاف الغاتغوري اختياري اذا ماحط صورة بتاخد وحدة افتراضية
//  late String imageUrl;

  set setUserId(String userId) {
    //وهون مجرد ماكان موجود معناها الايدي محقق للشروط
    this.userId = userId;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    //لا يمكن أن يكون تاريخ إنشاء الدوكمنت الخاص بتصنيف المستخدم قبل الوقت الحالي
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isBefore(now)) {
      exception = Exception(AppConstants.created_time_before_now_invalid_key);
      throw exception;
    }
    //لا يمكن أن يكون تاريخ إنشاء الدوكمنت الخاص بتصنيف المستخدم بعد الوقت الحالي

    if (createdAtParameter.isAfter(now)) {
      exception =
          Exception(AppConstants.created_time_not_in_future_invalid_key);
      throw exception;
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //لا يمكن أن يكون تاريخ تحديث الدوكمنت الخاص بتصنيف مهمة المستخدم قبل تاريخ الإنشاء
    if (updatedAtParameter.isBefore(createdAt)) {
      exception =
          Exception(AppConstants.updating_time_before_creating_invalid_key);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  @override
  set setId(String idParameter) {
    Exception exception;
    //لا يمكن أن يكون اي دي دوكمنت الخاص بتصنيف المهمة فارغاً
    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.category_id_empty_key);
      throw exception;
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;

    //هذه الخاصية تستخدم لوضع قيمة لاسم الفئة وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق
    //لا يمكن أن يكون اسم التصنيف فارغاً
    if (nameParameter.isEmpty) {
      exception = Exception(AppConstants.name_empty_key);
      throw exception;
    } //لايمكن ان يكون اسم التصنيف مؤلفاً من اقل من ثلاث محارف
    if (nameParameter.length <= 3) {
      exception = Exception(AppConstants.name_length_invalid_key);
      throw exception;
    }

    //في حال مرروره على جميع الشروط وعدم رمي اكسيبشن فذلك يعني تحقيقه للشروط المطلوبة وعندها سيتم وضع القيمة
    name = nameParameter;
  }

//باني خاص باستلام البيانات من الفاير ستور
  UserTaskCategoryModel.firestoreConstructor({
    //primary kay
    //الايدي الخاص بالفئة وهوه الايدي الذي سوف يوضع تلقائيا من الفاير ستور
    required String idParameter,
    //الايدي الخاص بالمستخدم وهو نفسو الuid تبع المستخدم
    //forgin kay from UserModel
    required this.userId,
    required this.hexColor,
    required this.iconCodePoint,
    required this.fontfamily,
    //لاسم الخاص بصنف المهام
    required String nameParameter,
    //وقت إنشاء هذه النوع من المهام
    required DateTime createdAtParameter,
    //الوقت الذي يمثل تاريخ اي تعديل يحصل على فئة المهام
    required DateTime updatedAtParameter,
  }) {
    id = idParameter;
    name = nameParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
  }
//لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory UserTaskCategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return UserTaskCategoryModel.firestoreConstructor(
      fontfamily: data[fontFamilyK],
      idParameter: data[idK],
      userId: data[userIdK],
      nameParameter: data[nameK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      hexColor: data[colorK],
      iconCodePoint: data[iconK],
    );
  }
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[nameK] = name;
    data[idK] = id;
    data[userIdK] = userId;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    data[colorK] = hexColor;
    data[iconK] = iconCodePoint;
    data[fontFamilyK] = fontfamily;
    return data;
  }
}
