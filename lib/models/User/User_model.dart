// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:mytest/services/Oldauth_service.dart';

// import '../../constants/back_constants.dart';
// import '../../Utils/back_utils.dart';
// import '../../services/auth_service.dart';
// import '../tops/VarTopModel.dart';

// class UserModel extends VarTopModel {
//   //اسم المستخدم الذي يظهر للأخرين في التطبيق
//   late String imageUrl;
//   //اليوزر نيم الخاص بكل مستخدم والذي لايمكن ان يتكرر بين اي مستخدم وهو لغرض تمكين المستخدمين الاخرين من البحث عن مستخدم اخر بواسطته
//   late String? userName;
//   //والذي يمثل شرح قصير عن المستخدم ويمكن للمستخدمين الاخرين رؤيته بالبروفايل الخاص بهذا المستخدم
//   late String? bio;
//   //  الايميل الخاص بالمستخدم  ويطلب في حال اراد المستخدم تسجيل الدخول بشكل غير انونمسيلي ولذلك يمكن ان يكون فارغ
//   //ملاحظة هامة  :   //  ماذا يحدث للايميل في حال تم تسجيل الدخول بواسطة فيسبوك او جوجل ؟؟؟؟
//   late String? email;

//   /*التوكين مسجينغ وهو خاص بكل تطبيق بالجهاز حيث كل نسخة  مختلفة للتطبيق على كل جهاز لها توكين مسجينغ خاص به ونستخدمه
//    وتم وضعه كمصفوفة لانه من الممكن ان يكون المستخدم له عدة اجهزة لنفس الحساب وبالتالي عدة توكين مسيجينغ لنفس الشخص
// */
//   late List<String> tokenFcm = [];
//   //يستخدم لجعل المستخدم قادر على إدخال احرف فقط اي بدون ارقام او محارف خاصة

// //الباني
//   UserModel({
//     required String nameParameter,
//     // البحث عنه حاليا شلنا الريكويرد اليوزر نيم  لانو المستخدم ممكن عند إنشاء التطبيق  لايريد إنشاءه فهو للاستخدام الشخصي مثلا او  ولا يريد لاحد  إيجاده مثلا متل التلغرام
//     String? userNameParameter,
//     //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
//     required String imageUrlParameter,
//     String? emailParameter,
//     //شلنا الريكويرد البيو لانو المستخدم ممكن مابدو هلئ يحط مثلا ايا فقرة شرح عنو او ايا شي بيخليها فاضية يعني مالها ريكويرد
//     this.bio,

//     //primary kay
//     //id الخاص بالمستخدم سوف يكون (uid) المقدم من فايربيز اوزنتيكيشن
//     required String idParameter,
//     //وقت إنشاء حساب المستخدم
//     required DateTime createdAtParameter,
//     //الوقت الذي بمثل تاريخ إي تعديل حصل على الحساب
//     //ملاحظة هامة  :   //  هل تاريخ التعديل عند إنشاء الحساب ياخد قيمة ابتدائية لتاريخ إنشاء الحساب أو يبقى فارغ حتى يجري السمتخدم اي تعديل وعندها ياخذ قيمة ؟
//     required DateTime updatedAtParameter,
//   }) {
//     setEmail = emailParameter;
//     setUserName = userNameParameter;
//     setImageUrl = imageUrlParameter;
//     setName = nameParameter;
//     setId = idParameter;
//     setCreatedAt = createdAtParameter;
//     setUpdatedAt = updatedAtParameter;
//   }

//   UserModel.firestoreConstructor({
//     required String nameParameter,
//     // البحث عنه حاليا شلنا الريكويرد اليوزر نيم  لانو المستخدم ممكن عند إنشاء التطبيق  لايريد إنشاءه فهو للاستخدام الشخصي مثلا او  ولا يريد لاحد  إيجاده مثلا متل التلغرام
//     String? userNameParameter,
//     //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
//     required String imageUrlParameter,
//     String? emailParameter,
//     //شلنا الريكويرد البيو لانو المستخدم ممكن مابدو هلئ يحط مثلا ايا فقرة شرح عنو او ايا شي بيخليها فاضية يعني مالها ريكويرد
//     String? bioParameter,
//     required this.tokenFcm,
//     //primary kay
//     //id الخاص بالمستخدم سوف يكون (uid) المقدم من فايربيز اوزنتيكيشن
//     required String idParameter,
//     //وقت إنشاء حساب المستخدم
//     required DateTime createdAtParameter,
//     //الوقت الذي بمثل تاريخ إي تعديل حصل على الحساب
//     //ملاحظة هامة  :   //  هل تاريخ التعديل عند إنشاء الحساب ياخد قيمة ابتدائية لتاريخ إنشاء الحساب أو يبقى فارغ حتى يجري السمتخدم اي تعديل وعندها ياخذ قيمة ؟
//     required DateTime updatedAtParameter,
//   }) {
//     bio = bioParameter;
//     email = emailParameter;
//     userName = userNameParameter;
//     imageUrl = imageUrlParameter;
//     name = nameParameter;
//     id = idParameter;
//     updatedAt = updatedAtParameter;
//     createdAt = createdAtParameter;
//     tokenFcm = tokenFcm;
//   }
//   RegExp regEx = RegExp(r"(?=.*[0-9])\w+");
//   RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');
//   @override
//   set setName(String name) {
//     Exception exception;

//     //هذه الخاصية تستخدم لوضع قيمة لاسم المستخدم وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق

//     if (name.isEmpty) {
//       //الشرط الأول لايمكن ان يكون فارغ
//       exception = Exception("Name cannot be Empty");
//       throw exception;
//     }
//     if (name.length <= 3) {
//       //لايمكن ان يكون الاسم مألف من اقل من ثلاث محارف
//       exception = Exception("Name cannot be less than 3 characters");
//       throw exception;
//     }
//     if (regEx.hasMatch(name) || regEx2.hasMatch(name)) {
//       exception = Exception('name can include letters only ');
//       throw exception;
//     }

//     this.name = name;
//   }

//   set setUserName(String? userName) {
//     Exception exception;
//     //لا يمكن أن يكون اليوزرنيم عديم القيمة
//     if (userName == null) {
//       this.userName = userName;
//       return;
//     }
//     if (userName.isEmpty) {
//       //لا يمكن أن يكون اليوزرنيم فارغاً
//       exception = Exception("username cannot be Empty");
//       throw exception;
//     }
//     if (userName.length <= 3) {
//       //لايمكن ان يكون اليوزرنيم مألف من اقل من ثلاث محارف
//       exception = Exception("username cannot be less than 3 characters");
//       throw exception;
//     }
//     if (userName.length >= 20) {
//       //لايمكن ان يكون اليوزرنيم مألف من اقل من ثلاث محارف
//       exception = Exception("username cannot be more than 20 characters");
//       throw exception;
//     }
//     this.userName = userName;
//   }

//   set setImageUrl(String imageUrl) {
//     Exception exception;
//     if (imageUrl.isEmpty) {
//       //لا يمكن أن يكون رابط صورة المستخدم فارغاً
//       exception = Exception("imageUrl cannot be Empty");
//       throw exception;
//     }
//     this.imageUrl = imageUrl;
//   }

//   set setEmail(String? email) {
//     //هذه الخاصية تستخدم لوضع قيمة لايميل المستخدم  وضمان انها تحقق جميع الشروط الخاصة بأي ايميل صحيح متل احتوائه على (@gmail .com والعديد من الشروط الأخرى)
//     if (email != null) {
//       if (!EmailValidator.validate(email)) {
//         //وفي ذلك الهدف نستخدم الباكج  email_validator
//         throw Exception("Enter a valid email");
//       }
//       this.email = email;
//     } else {
//       this.email = email;
//     }
//     //في حال تحقيقه الشروط لن يرمي اكسيبشن وبذلك تدخل القيمة بشكل سليم
//   }

//   set setBio(String? bio) {
//     this.bio = bio;
//   }
// /*
// ملاحظة كان ممكن حط متل هيك واختصر عحالي ساوي كائن من نوع اكسيبشن بس مو انا بدي ارمي رسالة الاكسبيشن بالدبياج باستخدام بكج Logger
// فوقتها رح احتاج الكائن لاطبع الرسالة تبعو بشكل فوري
//  throw Exception("token fcm is not valid should contain :");
// */

//   Future<void> addTokenFcm() async {
//     String tokenFcm = await getFcmToken();
//     //اضافة القيمة إلى المصفوفة الخاصة بالتوكين الخاص بأجهزة المستخدم
//     this.tokenFcm.add(tokenFcm);
//   }

//   @override
//   set setId(String id) {
//     Exception exception;
//     //لا يمكن أن يكون الاي دي الخاص باليوزر فارغ
//     if (id.isEmpty) {
//       exception = Exception("user id cannot be empty");
//       throw exception;
//     }
//     this.id = id;
//   }

//   @override
//   set setCreatedAt(DateTime createdAtParameter) {
//     Exception exception;
//     //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
//     // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
//     createdAtParameter = firebaseTime(createdAtParameter);
//     DateTime now = firebaseTime(DateTime.now());
//     //تاريخ إضافة اليوزر لا يمكن أن يكون بعد الوقت الحالي
//     createdAtParameter = firebaseTime(createdAtParameter);
//     if (createdAtParameter.isAfter(now)) {
//       exception = Exception("user creating time cannot be in the future");
//       throw exception;
//     }
//     //تاريخ إضافة اليوزر لا يمكن أن يكون قبل الوقت الحالي
//     if (createdAtParameter.isBefore(now)) {
//       exception = Exception("user creating time cannot be in the past");
//       throw exception;
//     }
//     createdAt = createdAtParameter;
//   }

//   @override
//   set setUpdatedAt(DateTime updatedAtParameter) {
//     Exception exception;
//     updatedAtParameter = firebaseTime(updatedAtParameter);
//     //تاريخ تحديث بيانات اليوزر لا يمكن أن يكون قبل تاريخ إنشائه
//     if (updatedAtParameter.isBefore(createdAt)) {
//       exception = Exception(
//           "user account updating time cannot be before creating time");
//       throw exception;
//     }
//     updatedAt = updatedAtParameter;
//   }

// //لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
//   factory UserModel.fromFireStore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     Map<String, dynamic> data = snapshot.data()!;
//     return UserModel.firestoreConstructor(
//       nameParameter: data[nameK],
//       userNameParameter: data[userNameK],
//       bioParameter: data[bioK],
//       imageUrlParameter: data[imageUrlK],
//       emailParameter: data[emailK],
//       tokenFcm: data[tokenFcmK].cast<String>(),
//       idParameter: data[idK],
//       createdAtParameter: data[createdAtK].toDate(),
//       updatedAtParameter: data[updatedAtK].toDate(),
//     );
//   }
//   //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
//   @override
//   Map<String, dynamic> toFirestore() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data[nameK] = name;
//     data[idK] = id;
//     data[userNameK] = userName;
//     data[bioK] = bio;
//     data[imageUrlK] = imageUrl;
//     data[emailK] = email;
//     data[tokenFcmK] = tokenFcm;
//     data[createdAtK] = createdAt;
//     data[updatedAtK] = updatedAt;
//     return data;
//   }

//   @override
//   String toString() {
//     return "name $name id $id userName $userName boi $bio imageUrl $imageUrl email $email tokenfcm $tokenFcm createdAt $createdAt updatedAt $updatedAt";
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import '../../services/auth_service.dart';
import '../tops/VarTopModel.dart';

class UserModel extends VarTopModel {
  //اسم المستخدم الذي يظهر للأخرين في التطبيق
  late String imageUrl;
  //اليوزر نيم الخاص بكل مستخدم والذي لايمكن ان يتكرر بين اي مستخدم وهو لغرض تمكين المستخدمين الاخرين من البحث عن مستخدم اخر بواسطته
  late String? userName;
  //والذي يمثل شرح قصير عن المستخدم ويمكن للمستخدمين الاخرين رؤيته بالبروفايل الخاص بهذا المستخدم
  late String? bio;
  //  الايميل الخاص بالمستخدم  ويطلب في حال اراد المستخدم تسجيل الدخول بشكل غير انونمسيلي ولذلك يمكن ان يكون فارغ
  //ملاحظة هامة  :   //  ماذا يحدث للايميل في حال تم تسجيل الدخول بواسطة فيسبوك او جوجل ؟؟؟؟
  late String? email;

  /*التوكين مسجينغ وهو خاص بكل تطبيق بالجهاز حيث كل نسخة  مختلفة للتطبيق على كل جهاز لها توكين مسجينغ خاص به ونستخدمه
   وتم وضعه كمصفوفة لانه من الممكن ان يكون المستخدم له عدة اجهزة لنفس الحساب وبالتالي عدة توكين مسيجينغ لنفس الشخص
*/
  late List<String> tokenFcm = [];
  //يستخدم لجعل المستخدم قادر على إدخال احرف فقط اي بدون ارقام او محارف خاصة

//الباني
  UserModel({
    required String nameParameter,
    // البحث عنه حاليا شلنا الريكويرد اليوزر نيم  لانو المستخدم ممكن عند إنشاء التطبيق  لايريد إنشاءه فهو للاستخدام الشخصي مثلا او  ولا يريد لاحد  إيجاده مثلا متل التلغرام
    String? userNameParameter,
    //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
    required String imageUrlParameter,
    String? emailParameter,
    //شلنا الريكويرد البيو لانو المستخدم ممكن مابدو هلئ يحط مثلا ايا فقرة شرح عنو او ايا شي بيخليها فاضية يعني مالها ريكويرد
    this.bio,

    //primary kay
    //id الخاص بالمستخدم سوف يكون (uid) المقدم من فايربيز اوزنتيكيشن
    required String idParameter,
    //وقت إنشاء حساب المستخدم
    required DateTime createdAtParameter,
    //الوقت الذي بمثل تاريخ إي تعديل حصل على الحساب
    //ملاحظة هامة  :   //  هل تاريخ التعديل عند إنشاء الحساب ياخد قيمة ابتدائية لتاريخ إنشاء الحساب أو يبقى فارغ حتى يجري السمتخدم اي تعديل وعندها ياخذ قيمة ؟
    required DateTime updatedAtParameter,
  }) {
    setEmail = emailParameter;
    setUserName = userNameParameter;
    setImageUrl = imageUrlParameter;
    setName = nameParameter;
    setId = idParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
  }

  UserModel.firestoreConstructor({
    required String nameParameter,
    // البحث عنه حاليا شلنا الريكويرد اليوزر نيم  لانو المستخدم ممكن عند إنشاء التطبيق  لايريد إنشاءه فهو للاستخدام الشخصي مثلا او  ولا يريد لاحد  إيجاده مثلا متل التلغرام
    String? userNameParameter,
    //الصورة سوف تكون اختيارية حيث يمكن للمستخدم اختيار صورة للبروفايل الخاص به وفي حال لم يختار سوف  يوضع له صورة افتراضية
    required String imageUrlParameter,
    String? emailParameter,
    //شلنا الريكويرد البيو لانو المستخدم ممكن مابدو هلئ يحط مثلا ايا فقرة شرح عنو او ايا شي بيخليها فاضية يعني مالها ريكويرد
    String? bioParameter,
    required this.tokenFcm,
    //primary kay
    //id الخاص بالمستخدم سوف يكون (uid) المقدم من فايربيز اوزنتيكيشن
    required String idParameter,
    //وقت إنشاء حساب المستخدم
    required DateTime createdAtParameter,
    //الوقت الذي بمثل تاريخ إي تعديل حصل على الحساب
    //ملاحظة هامة  :   //  هل تاريخ التعديل عند إنشاء الحساب ياخد قيمة ابتدائية لتاريخ إنشاء الحساب أو يبقى فارغ حتى يجري السمتخدم اي تعديل وعندها ياخذ قيمة ؟
    required DateTime updatedAtParameter,
  }) {
    bio = bioParameter;
    email = emailParameter;
    userName = userNameParameter;
    imageUrl = imageUrlParameter;
    name = nameParameter;
    id = idParameter;
    updatedAt = updatedAtParameter;
    createdAt = createdAtParameter;
    tokenFcm = tokenFcm;
  }
  RegExp regEx = RegExp(r"(?=.*[0-9])\w+");
  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');
  @override
  set setName(String name) {
    Exception exception;

    //هذه الخاصية تستخدم لوضع قيمة لاسم المستخدم وضمان ان هذه القيمة يتم ادخالها حسب الشروط الموضوعة في التطبيق

    if (name.isEmpty) {
      //الشرط الأول لايمكن ان يكون فارغ
      exception = Exception(AppConstants.name_not_empty_key.tr);
      throw exception;
    }
    if (name.length <= 3) {
      //لايمكن ان يكون الاسم مألف من اقل من ثلاث محارف
      exception = Exception(AppConstants.name_min_length_key.tr);
      throw exception;
    }
    if (regEx.hasMatch(name) || regEx2.hasMatch(name)) {
      exception = Exception(AppConstants.name_letters_only_key.tr);
      throw exception;
    }

    this.name = name;
  }

  set setUserName(String? userName) {
    Exception exception;
    //لا يمكن أن يكون اليوزرنيم عديم القيمة
    if (userName == null) {
      this.userName = userName;
      return;
    }
    if (userName.isEmpty) {
      //لا يمكن أن يكون اليوزرنيم فارغاً
      exception = Exception(AppConstants.username_not_empty_key.tr);
      throw exception;
    }
    if (userName.length <= 3) {
      //لايمكن ان يكون اليوزرنيم مألف من اقل من ثلاث محارف
      exception = Exception(AppConstants.username_min_length_key.tr);
      throw exception;
    }
    if (userName.length >= 20) {
      //لايمكن ان يكون اليوزرنيم مألف من اكثر من ثلاث محارف
      exception = Exception(AppConstants.username_max_length_key.tr);
      throw exception;
    }
    this.userName = userName;
  }

  set setImageUrl(String imageUrl) {
    Exception exception;
    if (imageUrl.isEmpty) {
      //لا يمكن أن يكون رابط صورة المستخدم فارغاً
      exception = Exception(AppConstants.user_imageUrl_empty_key.tr);
      throw exception;
    }
    this.imageUrl = imageUrl;
  }

  set setEmail(String? email) {
    //هذه الخاصية تستخدم لوضع قيمة لايميل المستخدم  وضمان انها تحقق جميع الشروط الخاصة بأي ايميل صحيح متل احتوائه على (@gmail .com والعديد من الشروط الأخرى)
    if (email != null) {
      if (!EmailValidator.validate(email)) {
        //وفي ذلك الهدف نستخدم الباكج  email_validator
        throw Exception(AppConstants.valid_email_error_key.tr);
      }
      this.email = email;
    } else {
      this.email = email;
    }
    //في حال تحقيقه الشروط لن يرمي اكسيبشن وبذلك تدخل القيمة بشكل سليم
  }

  set setBio(String? bio) {
    this.bio = bio;
  }
/*
ملاحظة كان ممكن حط متل هيك واختصر عحالي ساوي كائن من نوع اكسيبشن بس مو انا بدي ارمي رسالة الاكسبيشن بالدبياج باستخدام بكج Logger
فوقتها رح احتاج الكائن لاطبع الرسالة تبعو بشكل فوري 
 throw Exception("token fcm is not valid should contain :");
*/

  Future<void> addTokenFcm() async {
    String tokenFcm = await getFcmToken();
    //اضافة القيمة إلى المصفوفة الخاصة بالتوكين الخاص بأجهزة المستخدم
    this.tokenFcm.add(tokenFcm);
  }

  @override
  set setId(String id) {
    Exception exception;
    //لا يمكن أن يكون الاي دي الخاص باليوزر فارغ
    if (id.isEmpty) {
      exception = Exception(AppConstants.user_id_empty_error_key.tr);
      throw exception;
    }
    this.id = id;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;
    //يأخذ الوقت ويجري عليه التعديلات الخاصة بوقت الفايربيز لتجري عمليات الوقت عليه بدون حدوث
    // اي خطأ في اعدادات الوقت المدخل ثم يرجعه
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());
    //تاريخ إضافة اليوزر لا يمكن أن يكون بعد الوقت الحالي
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      exception =
          Exception(AppConstants.user_creating_time_future_error_key.tr);
      throw exception;
    }
    //تاريخ إضافة اليوزر لا يمكن أن يكون قبل الوقت الحالي
    if (createdAtParameter.isBefore(now)) {
      exception = Exception(AppConstants.user_creating_time_past_error_key.tr);
      throw exception;
    }
    createdAt = createdAtParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //تاريخ تحديث بيانات اليوزر لا يمكن أن يكون قبل تاريخ إنشائه
    if (updatedAtParameter.isBefore(createdAt)) {
      exception = Exception(
          AppConstants.user_account_updating_time_before_creating_error_key.tr);
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

//لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory UserModel.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic> data = snapshot.data()!;
    return UserModel.firestoreConstructor(
      nameParameter: data[nameK],
      userNameParameter: data[userNameK],
      bioParameter: data[bioK],
      imageUrlParameter: data[imageUrlK],
      emailParameter: data[emailK],
      tokenFcm: data[tokenFcmK].cast<String>(),
      idParameter: data[idK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }
  //لترحيل البيانات القادمة  من مودل على شكل جيسون (ماب) إلى الداتا بيز
  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[nameK] = name;
    data[idK] = id;
    data[userNameK] = userName;
    data[bioK] = bio;
    data[imageUrlK] = imageUrl;
    data[emailK] = email;
    data[tokenFcmK] = tokenFcm;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }

  @override
  String toString() {
    return "name $name id $id userName $userName boi $bio imageUrl $imageUrl email $email tokenfcm $tokenFcm createdAt $createdAt updatedAt $updatedAt";
  }
}
