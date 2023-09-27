import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytest/models/tops/VarTopModel.dart';

import '../constants/back_constants.dart';
import '../utils/back_utils.dart';

//كلاس الحالة الذي سيأخذ من الكلاسات الباقية مثل المشروع والمهام بأنواعها حقل الحالة
//هل هية منجزة غير منجزة جاري الإنجاز
class StatusModel extends VarTopModel {
  StatusModel({
    //اسم حقل الحالة
    required String name,
    //تاريخ إنشاء حقل الحالة
    required DateTime createdAt,
    //تاريخ تحديث حقل الحالة
    required DateTime updatedAt,
    //الاي دي الخاص بالدوكيومنت الخاص بالحالة في فاير ستور
    required String idParameter,
  }) {
    //لإسناد الحالة إلى المتغيرات في الكلاس بعد مرورها على الشروط في ال
    //set
    setCreatedAt = createdAt;
    setName = name;
    setUpdatedAt = updatedAt;
    setId = idParameter;
  }
  StatusModel.firestoreConstructor({
    //اسم حقل الحالة
    required String nameParameter,
    //تاريخ إنشاء حقل الحالة
    required DateTime createdAtParameter,
    //تاريخ تحديث حقل الحالة
    required DateTime updatedAtParameter,
    //الاي دي الخاص بالدوكيومنت الخاص بالحالة في فاير ستور
    required String id,
  }) {
    createdAt = createdAtParameter;
    name = nameParameter;
    updatedAt = updatedAtParameter;
    this.id = id;
  }

  @override
  set setCreatedAt(DateTime? createdAtParameter) {
    Exception exception;
    //لا يمكن أن يكون وقت الإنشاء عديم القيمة
    if (createdAtParameter == null) {
      exception = Exception("created Time Can not be null ");
      throw exception;
    }
    createdAtParameter = firebaseTime(createdAtParameter);
    DateTime now = firebaseTime(DateTime.now());
    //تاريخ إضافة الدوكيومنت لا يمكن أن يكون بعد الوقت الحالي
    if (createdAtParameter.isAfter(now)) {
      exception = Exception("status creating time cannot be in the future");
      throw exception;
    }
    //تاريخ إضافة الدوكيومنت لا يمكن أن يكون قبل الوقت الحالي
    if (firebaseTime(createdAtParameter).isBefore(now)) {
      exception = Exception("status creating time cannot be in the past");
      throw exception;
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setId(String idParameter) {
    print("${idParameter}id parameter");
    Exception exception;
    //لا يمكن أن يكون الاي دي الخاص بالدوكيومنت عديم القيمة
    if (idParameter.isEmpty) {
      exception = Exception("status id cannot be empty");
      throw exception;
    }
    id = idParameter;
  }

  @override
  set setName(String nameParameter) {
    Exception exception;
    //الشروط الخاصة بحالة المهام والمشاريع في التطبيق
    if (nameParameter.isEmpty) {
      //الشرط الأول لايمكن ان يكون فارغ
      exception = Exception("status Name cannot be Empty");
      throw exception;
    }
    if (nameParameter.length <= 3) {
      //لايمكن ان يكون الاسم مؤلف من اقل من ثلاث محارف
      exception = Exception("status Name cannot be less than 3 characters");
      throw exception;
    }
    //في حال مرروره على جميع الشروط وعدم رمي اكسيبشن فذلك يعني تحقيقه للشروط المطلوبة وعندها سيتم وضع القيمة
    name = nameParameter;
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //لا يمكن ان يكون وقت التحديث قبل وقت الإنشاء
    if (updatedAtParameter.isBefore(createdAt)) {
      exception =
          Exception("status creating Time Can not be last time before now ");
      throw exception;
    }
    updatedAt = updatedAtParameter;
  }

  //لتحويل الموديل إلى جسون يقبلها فاير ستور
  factory StatusModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return StatusModel.firestoreConstructor(
      nameParameter: data[nameK],
      id: data[idK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
    );
  }

  //لتحويل البيانات من الفاير ستور إلى موديل
  @override
  Map<String, dynamic> toFirestore() {
    return {
      nameK: name,
      idK: id,
      createdAtK: createdAt,
      updatedAtK: updatedAt,
    };
  }

  @override
  String toString() {
    return "status name is $name id:$id  createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
