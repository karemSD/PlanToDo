import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import 'Task_model.dart';
//TODO use the firebase time

//الكلاس الخاص بالمهمة الأساسية في البروجيكت
class ProjectMainTaskModel extends TaskClass {
  //الباني الخاص بالكلاس
  ProjectMainTaskModel({
    //الاي دي الخاص بالمشروع الذي تندرج تحته المهمة الأساسية
    //foreign key
    required String projectIdParameter,
    //وصف المهمة الأساسية في المشروع
    required String descriptionParameter,
    //الاي دي الخاص بالمهمة الأساسية في المشروع
    //primary key
    required String idParameter,
    //اسم المهمة الأساسية في المشروع
    required String nameParameter,
    //اي دي الحالة الخاصة بالمهمة الأساسية
    //foreign key
    required String statusIdParameter,
    //أهمية المشروع تتراوح بين واحد وخمسة
    required int importanceParameter,
    //تاريخ إنشاء المهمة الأساسية
    required DateTime createdAtParameter,
    //تاريخ تعديل المهمة الأساسية
    required DateTime updatedAtParameter,
    //تاريخ بدء المهمة الأساسية
    required DateTime startDateParameter,
    //تاريخ انتهاء المهمة الأساسية
    required DateTime endDateParameter,
    required String hexColorParameter,
  }) {
    setHexColor = hexColorParameter;

    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setStartDate = startDateParameter;
    setEndDate = endDateParameter;
    setprojectId = projectIdParameter;
  }
  ProjectMainTaskModel.firestoreConstructor({
    //الاي دي الخاص بالمشروع الذي تندرج تحته المهمة الأساسية
    //foreign key
    required String projectIdParameter,
    //وصف المهمة الأساسية في المشروع
    String? descriptionParameter,
    //الاي دي الخاص بالمهمة الأساسية في المشروع
    //primary key
    required String idParameter,
    //اسم المهمة الأساسية في المشروع
    required String nameParameter,
    //اي دي الحالة الخاصة بالمهمة الأساسية
    //foreign key
    required String statusIdParameter,
    //أهمية المشروع تتراوح بين واحد وخمسة
    required int importanceParameter,
    //تاريخ إنشاء المهمة الأساسية
    required DateTime createdAtParameter,
    //تاريخ تعديل المهمة الأساسية
    required DateTime updatedAtParameter,
    //تاريخ بدء المهمة الأساسية
    required DateTime startDateParameter,
    //تاريخ انتهاء المهمة الأساسية
    required DateTime endDateParameter,
    required String hexColorParameter,
  }) {
    hexcolor = hexColorParameter;
    projectId = projectIdParameter;
    id = idParameter;
    description = descriptionParameter;
    name = nameParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
  }
  late String projectId;
  //اي دي الدوكيومنت الخاص بالمشروع الذي يتضمن المهمة الأساسية
  @override
  set setHexColor(String hexcolorParameter) {
    Exception exception;
    if (hexcolorParameter.isEmpty) {
      exception = Exception(AppConstants.main_task_color_empty_key);
      throw exception;
    }
    hexcolor = hexcolorParameter;
  }

  @override
  set setId(String idParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالمهمة الأساسية
    Exception exception;
    //لا يمكن أن يكون اي دي الدوكيومنت الخاص بالمهمة الأساسية فارغاً
    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.project_main_task_id_empty_key);
      throw exception;
    }
    id = idParameter;
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if the task name already been stored in the firebase for this project for this model
  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String nameParameter) {
    //الشروط الخاصة باسم المهمة الأساسية في البروجيكت
    Exception exception;
    //لا يمكن ان يكون اسم المهمة الأساسية الخاصة بالمشروع فارغاً
    if (nameParameter.isEmpty) {
      exception = Exception(AppConstants.project_main_task_name_empty_key);
      throw exception;
    }
    //لا يمكن أن تتواجد مهمتان أساسيتان بنفس الاسم في نفس البروجيكت
    name = nameParameter;
  }

  set setprojectId(String projectIdParameter) {
    //قواعد إضافة الاي دي الخاص بالدوكيومنت الخاص بالبروجيكت الذي يحتوي المهمة
    Exception exception;
    //لا يمكن لآي دي الدوكيومنت الخاص بالبروجيكت أن يكون فارغاُ
    if (projectIdParameter.isEmpty) {
      exception = Exception(AppConstants.project_id_empty_key);
      throw exception;
    }
    projectId = projectIdParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    //يمكن لقائد المشروع أن يضيف الوصف الذي يراه مناسباً بدون قيود
    description = descriptionParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالحالة
    Exception exception;
    //يتم رفض الدوكيومينت آي دي الخاص بالحالة اذا فارغاً
    if (statusIdParameter.isEmpty) {
      exception = Exception(AppConstants.main_task_status_id_empty_key);
      throw exception;
    }

    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    //تتراوح قيمة الأهمية بين ال1 وال5
    //الشروط التي تنطبق على الأهمية
    Exception exception;
    //الأهمية لا يمكن أن تكون أقل من صفر أو تساويه
    if (importanceParameter < 1) {
      exception = Exception(AppConstants.main_task_importance_min_invalid_key);
      throw exception;
    }
    //لا يمكن أن تكون للأهمية قيمة أكبر من 5
    if (importanceParameter > 5) {
      exception = Exception(AppConstants.main_task_importance_max_invalid_key);
      throw exception;
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    //الشروط الخاصة بتاريخ ووقت إضافة الدوكيومنت الخاص بالمهمة
    Exception exception;
    // تاريخ إضافة المهمة يجب ان يكون بنفس تاريخ اليوم الأحسن بنفس الساعة مثل أدناه  تذكر المستخدم غبي المطور أغبى
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      exception = Exception(
          AppConstants.main_task_create_time_not_in_future_invalid_key);
      throw exception;
    }
    //تاريخ إضافة الدوكيومنت لا يمكن أن يكون قبل الوقت الحالي تذكر المستخدم غبي المطور أغبى
    if (createdAtParameter.isBefore(now)) {
      exception =
          Exception(AppConstants.main_task_create_time_in_past_error_key);
      throw exception;
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //الشروط الخاصة بال التاريخ والوقت لتحديث المهمة الأساسية في البروجيكت
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //اذا كان تاريخ ووقت التحديث قبل تاريخ ووقت الإضافة يتم رفضه
    if (updatedAtParameter.isBefore(createdAt)) {
      exception = Exception(
          AppConstants.main_task_updating_time_not_in_future_invalid_key);
      throw exception;
    }
    updatedAt = (updatedAtParameter);
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if there is another task in the same time for this model
  bool dateduplicated(DateTime starttime) {
    return true;
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    //الشروط الخاصة بتاريخ ووقت البداية
    Exception exception;
    if (startDateParameter == null) {
      //كأيا شخص ذكي بتقول لحالك انو مالازم تاريخ ووقت البداية تقبل تكون عديمة القيمة
      exception = Exception(AppConstants.main_task_start_date_null_key);
      throw exception;
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());
    //تاريخ ووقت البداية البداية لا يمكن أن يكون قبل التاريخ والوقت الحالي
    //نذكر بأنه لا يمكن لأي شخص بالتفنيات الحالةي السفر عبر الزمن

    if (startDateParameter.isBefore(now)) {
      exception = Exception(AppConstants.main_task_start_date_past_error_key);
      throw exception;
    }

    //TODO check this line
    //TODO هل يجب ان نحذر قائد الفريق  من وجود مهام في نفس الوقت

    startDate = (startDateParameter);
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    //الشروط الخاصة بتاريخ ووقت نهاية المهمة الأساسية في البروجكت
    Exception exception;
    //لا يمكن أن يكون تاريخ ووقت نهاية المهمة معدوم القيمة
    if (endDateParameter == null) {
      exception = Exception(AppConstants.main_task_end_date_null_key);
      throw exception;
    }
    endDateParameter = firebaseTime(endDateParameter);
    //تاريخ ووقت نهاية المهمة الأساسية لا يمكن أن يكون قبل تاريخ ووقت بداية المهمة بديهياً
    if (endDateParameter.isBefore(startDate)) {
      exception = Exception(AppConstants.main_task_start_after_end_error_key);
      throw exception;
    }
    //لا يمكن أن يكون هناك فارق أقل من 5 دقائق بين بداية المهمة الأساسية ونهايتها
    Duration diff = endDateParameter.difference(getStartDate);
    if (diff.inMinutes < 5) {
      exception = Exception(AppConstants.main_task_date_difference_error_key);
      throw exception;
    }
    //لا يمكن أن يكون تاريخ ووقت نهاية وبداية المهمة متساويين
    //TODO check this line
    if (endDateParameter.isAtSameMomentAs(getStartDate)) {
      exception = Exception(
        AppConstants.main_task_start_same_as_end_error_key,
      );
      throw exception;
    }

    endDate = endDateParameter;
  }

  factory ProjectMainTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectMainTaskModel.firestoreConstructor(
      hexColorParameter: data[colorK],
      nameParameter: data[nameK],
      idParameter: data[idK],
      descriptionParameter: data[descriptionK],
      projectIdParameter: data[projectIdK],
      statusIdParameter: data[statusIdK],
      importanceParameter: data[importanceK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      startDateParameter: data[startDateK].toDate(),
      endDateParameter: data[endDateK].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      colorK: hexcolor,
      nameK: name,
      idK: id,
      descriptionK: description,
      projectIdK: projectId,
      statusIdK: statusId,
      importanceK: importance,
      createdAtK: createdAt,
      updatedAtK: updatedAt,
      startDateK: startDate,
      endDateK: endDate,
    };
  }

  @override
  String toString() {
    return "main task name is:$name id:$id  description:$description projectId:$projectId  statusId:$statusId importance:$importance startDate:$startDate endDate:$endDate createdAt:$createdAt updatedAt:$updatedAt ";
  }
}
