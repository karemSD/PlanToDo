import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytest/constants/app_constans.dart';

import '../../constants/back_constants.dart';
import '../../Utils/back_utils.dart';
import 'Task_model.dart';

//الكلاس الخاص بالمهمة الفرعية في البروجيكت
// why used Datetime instead of this.
// because we cant access to the fields in the sons from the abstract class that they inherit from
// so instead of making too much work we did this
class ProjectSubTaskModel extends TaskClass {
  ProjectSubTaskModel({
    //الاي دي الخاص بالمشروع الذي تندرج تحته المهمة الفرعية
    //foreign key
    required String projectIdParameter,
    //الاي دي الخاص بالمهمة الأساسية التي تندرج تحتها المهمة الفرعية
    //foreign key
    required String mainTaskIdParameter,
    //وصف المهمة الفرعية
    required String descriptionParameter,
    //الاي دي الخاص بالمهمة الفرعية يتم اعطاؤه تلقائياً من فاير ستور
    //primary key
    required String idParameter,
    //اسم المهمة الفرعية
    required String nameParameter,
    //الاي دي الخاص بحالة المهمة الفرعية
    //foreign key
    required String statusIdParameter,
    //أهمية المهمة من واحد إلى 5
    required int importanceParameter,
    //تاريخ إنشاء المهمة الفرعية
    required DateTime createdAtParameter,
    //تاريخ تعديل المهمة الفرعية
    required DateTime updatedAtParameter,
    //تاريخ بدأ المهمة الفرعية
    required DateTime startDateParameter,
    //تاريخ نهاية المهمة الفرعية
    required DateTime endDateParameter,
    //اي دي العضو المسندة له المهمة الفرعية
    //foreign key
    required String assignedToParameter,
    required String hexColorParameter,
  }) {
    setHexColor = hexColorParameter;
    setMainTaskId = mainTaskIdParameter;
    setId = idParameter;
    setName = nameParameter;
    setDescription = descriptionParameter;
    setStatusId = statusIdParameter;
    setimportance = importanceParameter;
    setCreatedAt = createdAtParameter;
    setUpdatedAt = updatedAtParameter;
    setStartDate = startDateParameter;
    setEndDate = endDateParameter;
    setAssignedTo = assignedToParameter;
    setprojectId = projectIdParameter;
  }
  ProjectSubTaskModel.firestoreConstructor({
    //الاي دي الخاص بالمشروع الذي تندرج تحته المهمة الفرعية
    //foreign key
    required String projectIdParameter,
    //الاي دي الخاص بالمهمة الأساسية التي تندرج تحتها المهمة الفرعية
    //foreign key
    required String mainTaskIdParameter,
    //وصف المهمة الفرعية
    String? descriptionParameter,
    //الاي دي الخاص بالمهمة الفرعية يتم اعطاؤه تلقائياً من فاير ستور
    //primary key
    required String idParameter,
    //اسم المهمة الفرعية
    required String nameParameter,
    //الاي دي الخاص بحالة المهمة الفرعية
    //foreign key
    required String statusIdParameter,
    //أهمية المهمة من واحد إلى 5
    required int importanceParameter,
    //تاريخ إنشاء المهمة الفرعية
    required DateTime createdAtParameter,
    //تاريخ تعديل المهمة الفرعية
    required DateTime updatedAtParameter,
    //تاريخ بدأ المهمة الفرعية
    required DateTime startDateParameter,
    //تاريخ نهاية المهمة الفرعية
    required DateTime endDateParameter,
    //اي دي العضو المسندة له المهمة الفرعية
    //foreign key
    required String assignedToParameter,
    required String hexColorParameter,
  }) {
    projectId = projectIdParameter;
    hexcolor = hexColorParameter;
    mainTaskId = mainTaskIdParameter;
    id = idParameter;
    name = nameParameter;
    description = descriptionParameter;
    statusId = statusIdParameter;
    importance = importanceParameter;
    createdAt = createdAtParameter;
    updatedAt = updatedAtParameter;
    startDate = startDateParameter;
    endDate = endDateParameter;
    assignedTo = assignedToParameter;
  }

  late String assignedTo;
  @override
  set setHexColor(String hexcolorParameter) {
    Exception exception;
    if (hexcolorParameter.isEmpty) {
      exception =
          Exception(AppConstants.project_sub_task_color_empty_error_key);
      throw exception;
    }
    hexcolor = hexcolorParameter;
  }

  //الدوكيومنت اي دي الخاص بالشخص الذي سيتم اسناد المهمة له
  set setAssignedTo(String assignedToParameter) {
    //الشروط الخاصة بالدوكيومنت آي دي الخاص  بالشخص الذي سيتم اسناد المهمة له
    Exception exception;
    //لا يمكن أن يكون الدوكيومنت آي دي الخاص  بالشخص الذي سيتم اسناد المهمة له فارغاً
    if (assignedToParameter.isEmpty) {
      exception =
          Exception(AppConstants.team_member_assigned_id_empty_error_key);
      throw exception;
    }

    assignedTo = assignedToParameter;
  }

  late String mainTaskId;
  //الدوكيومنت آي دي الخاص بالمهمة الأساسية في المشروع التي تندرج بداخلها المهمة الفرعية
  set setMainTaskId(String mainTaskIdParameter) {
    //الشروط الخاصة بالدوكيومنت آي دي الخاص بالمهمة الأساسية
    Exception exception;
    //لا يمكن أن يكون  آي دي الخاص بالمهمة الأساسية فارغاً
    if (mainTaskIdParameter.isEmpty) {
      exception = Exception(AppConstants.sub_task_main_task_id_empty_error_key);
      throw exception;
    }
    //التأكد من وجود المهمة الأساسية
    //TODO make this function
    // if (!checkExist("project_main_tasks", mainTaskIdParameter)) {
    //   exception = Exception("project Main Task id cannot be found");
    //   throw exception;
    // }
    mainTaskId = mainTaskIdParameter;
  }

  late String projectId;
  //اي دي الدوكيومنت الخاص بالمشروع الذي يتضمن المهمة الفرعية
  set setprojectId(String projectIdParameter) {
    //قواعد إضافة الاي دي الخاص بالدوكيومنت الخاص بالبروجيكت الذي يحتوي المهمة
    Exception exception;
    //لا يمكن لآي دي الدوكيومنت الخاص بالبروجيكت أن يكون فارغاُ
    if (projectIdParameter.isEmpty) {
      exception = Exception(AppConstants.sub_task_project_id_empty_error_key);
      throw exception;
    }

    //التحقق من وجود المشروع في الداتا بيس

    projectId = projectIdParameter;
  }

  @override
  set setDescription(String? descriptionParameter) {
    //يمكن لقائد المشروع أن يضيف الوصف الذي يراه مناسباً بدون قيود
    description = descriptionParameter;
  }

  @override
  set setId(String idParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالمهمة الفرعية
    Exception exception;
    //لا يمكن أن يكون آي دي المهمة الفرعية للمشروع فارغاً
    if (idParameter.isEmpty) {
      exception = Exception(AppConstants.project_sub_task_id_empty_error_key);
      throw exception;
    }
    id = idParameter;
  }

  // TODO:this method is just for demo make the method to make a query in firebase to know that if the task name already been stored in the firebase for this project for this model
  bool taskExist(String taskName) {
    return true;
  }

  @override
  set setName(String? nameParameter) {
    //الشروط الخاصة باسم المهمة الفرعية في المهمة الأساسية في البروجيكت
    Exception exception;
    //لا يمكن أن يكون اسم المهمة الفرعية في المشروع بدون قيمة
    if (nameParameter == null) {
      exception = Exception(AppConstants.project_sub_task_name_null_error_key);
      throw exception;
    }
    //لا يمكن أن يكون اسم المهمة الفرعية في المشروع فارغاُ
    if (nameParameter.isEmpty) {
      exception = Exception(AppConstants.project_sub_task_name_empty_error_key);
      throw exception;
    }
    //TODO::don't forget to edit here
    name = nameParameter;
  }

  @override
  set setStatusId(String statusIdParameter) {
    //الشروط الخاصة بالدوكيومينت آي دي الخاص بالحالة
    Exception exception;
    //يتم رفض الدوكيومينت آي دي الخاص بالحالة اذا فارغاً
    if (statusIdParameter.isEmpty) {
      exception =
          Exception(AppConstants.project_sub_task_status_id_empty_error_key);
      throw exception;
    }
    //ميثود تقوم بالتحقق من صحة الاي دي الخاصة بالحالة
    //TODO complete this function that check if the id is valid
    // if (!checkExist("status", statusIdParameter)) {
    //   exception = Exception("status id is not found");
    //   throw exception;
    // }
    statusId = statusIdParameter;
  }

  @override
  set setimportance(int importanceParameter) {
    //تتراوح قيمة الأهمية بين ال1 وال5
    //الشروط التي تنطبق على الأهمية
    Exception exception;
    //الأهمية لا يمكن أن تكون أقل من واحد
    if (importanceParameter < 1) {
      exception =
          Exception(AppConstants.project_sub_task_importance_min_error_key);
      throw exception;
    }
    //لا يمكن أن تكون للأهمية قيمة أكبر من 5
    if (importanceParameter > 5) {
      exception =
          Exception(AppConstants.project_sub_task_importance_max_error_key);
      throw exception;
    }
    importance = importanceParameter;
  }

  @override
  set setCreatedAt(DateTime createdAtParameter) {
    Exception exception;
    createdAtParameter = firebaseTime(createdAtParameter);
    //الشروط الخاصة بتاريخ ووقت إضافة الدوكيومنت الخاص بالمهمة الفرعية
    DateTime now = firebaseTime(DateTime.now());
    createdAtParameter = firebaseTime(createdAtParameter);
    if (createdAtParameter.isAfter(now)) {
      exception =
          Exception(AppConstants.project_sub_task_create_time_future_error_key);
      throw exception;
    }
    //تاريخ إضافة الدوكيومنت الخاص بالمهمة الفرعية لا يمكن أن يكون قبل الوقت الحالي
    if (firebaseTime(createdAtParameter).isBefore(now)) {
      exception =
          Exception(AppConstants.project_sub_task_create_time_past_error_key);
      throw exception;
    }
    createdAt = firebaseTime(createdAtParameter);
  }

  @override
  set setUpdatedAt(DateTime updatedAtParameter) {
    //الشروط الخاصة بال التاريخ والوقت لتحديث المهمة الفرعية في البروجيكت
    Exception exception;
    updatedAtParameter = firebaseTime(updatedAtParameter);
    //لا يمكن أن يكون تاريخ التحديث قبل تاريخ إنشاء المهمة
    if (updatedAtParameter.isBefore(createdAt)) {
      exception = Exception(
          AppConstants.project_sub_task_update_time_before_creating_error_key);
      throw exception;
    }
    updatedAt = firebaseTime(updatedAtParameter);
  }

  @override
  set setStartDate(DateTime? startDateParameter) {
    //الشروط الخاصة بتاريخ ووقت البداية
    Exception exception;
    //تاريخ بداية المهمة لا يمكن أن يكون عديم القيمة
    if (startDateParameter == null) {
      exception =
          Exception(AppConstants.project_sub_task_start_date_null_error_key);
      throw exception;
    }
    startDateParameter = firebaseTime(startDateParameter);
    DateTime now = firebaseTime(DateTime.now());
    //تاريخ ووقت البداية البداية لا يمكن أن يكون قبل التاريخ والوقت الحالي
    if (startDateParameter.isBefore(now)) {
      exception =
          Exception(AppConstants.project_sub_task_start_date_past_error_key);
      throw exception;
    }

    startDate = startDateParameter;
  }

  bool dateduplicated(DateTime starttime) {
    return true;
  }

  @override
  set setEndDate(DateTime? endDateParameter) {
    //الشروط الخاصة بتاريخ ووقت نهاية المهمة الفرعية في البروجكت
    Exception exception;
    //لا يمكن أن يكون تاريخ ووقت نهاية المهمة الفرعية معدوم القيمة
    if (endDateParameter == null) {
      exception =
          Exception(AppConstants.project_sub_task_end_date_null_error_key);
      throw exception;
    }
    endDateParameter = firebaseTime(endDateParameter);
    //لا يمكن أن يكون تاريخ نهاية المهمة المهمة الفرعية قبل تاريخ بدايتها
    if (endDateParameter.isBefore(startDate)) {
      exception =
          Exception(AppConstants.project_sub_task_start_after_end_error_key);
      throw exception;
    }
    //لا يمكن أن يكون تاريخ ووقت نهاية وبدايتها متساويين

    if ((endDateParameter).isAtSameMomentAs(getStartDate)) {
      exception = Exception(
        AppConstants.project_sub_task_start_same_as_end_error_key,
      );
      throw exception;
    }
    //لا يمكن أن يكون الفرق بين تاريخ بداية المهمة الفرعية ونهايتها أقل من 5 دقائق
    Duration diff = endDateParameter.difference(startDate);
    if (diff.inMinutes < 5) {
      exception =
          Exception(AppConstants.project_sub_task_time_difference_error_key);
      throw exception;
    }
    endDate = firebaseTime(endDateParameter);
  }

  factory ProjectSubTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    return ProjectSubTaskModel.firestoreConstructor(
      hexColorParameter: data[colorK],
      nameParameter: data[nameK],
      idParameter: data[idK],
      assignedToParameter: data[assignedToK],
      descriptionParameter: data[descriptionK],
      mainTaskIdParameter: data[mainTaskIdK],
      statusIdParameter: data[statusIdK],
      importanceParameter: data[importanceK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      startDateParameter: data[startDateK].toDate(),
      endDateParameter: data[endDateK].toDate(),
      projectIdParameter: data[projectIdK],
    );
  }
  factory ProjectSubTaskModel.fromJson(
    Map<String, dynamic> data,
  ) {
    return ProjectSubTaskModel.firestoreConstructor(
      hexColorParameter: data[colorK],
      nameParameter: data[nameK],
      idParameter: data[idK],
      assignedToParameter: data[assignedToK],
      descriptionParameter: data[descriptionK],
      mainTaskIdParameter: data[mainTaskIdK],
      statusIdParameter: data[statusIdK],
      importanceParameter: data[importanceK],
      createdAtParameter: data[createdAtK].toDate(),
      updatedAtParameter: data[updatedAtK].toDate(),
      startDateParameter: data[startDateK].toDate(),
      endDateParameter: data[endDateK].toDate(),
      projectIdParameter: data[projectIdK],
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      colorK: hexcolor,
      nameK: name,
      idK: id,
      descriptionK: description,
      mainTaskIdK: mainTaskId,
      assignedToK: assignedTo,
      statusIdK: statusId,
      importanceK: importance,
      createdAtK: createdAt,
      updatedAtK: updatedAt,
      startDateK: startDate,
      endDateK: endDate,
      projectIdK: projectId,
    };
  }
}
