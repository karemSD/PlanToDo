import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/User/User_task_Model.dart';
import 'package:mytest/models/statusmodel.dart';
import 'package:mytest/models/task/UserTaskCategory_model.dart';
import 'package:mytest/models/team/waitingSubTasksModel.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Project_main_task_Model.dart';
import 'package:mytest/models/team/Project_model.dart';
import 'package:mytest/models/team/Project_sub_task_Model.dart';
import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/models/team/waitingMamber.dart';

//لا يمكن عمل الكوليكشن ريفرنس كونستانت
//لأن القيمة المرجعة من الفاير بيس متغيرة ليست ثابتة من عندي
//تم وضع الريفرينس بملف مستقل لأنه سيتم استخدامها كثيراً في المستقبل لذلك لتجنب التكرار وضعناها هنا
//الكولكشن الخاصة بالمستخدمين
//نستخدم
//(with converter )
//من أجل تسهيل عملية إرسال الموديلات واستقبالها فبدلاً من استقبالها على شكل
//json
//نقوم باستقبالها على شكل الموديل الذي نريد العمل عليه
//ومن هنا نكون قد وفرنا في وقت كتابة كود التحويل من السناب شوت  داتا إلى الدالة الخاصة بتحويل الجسون في الموديل
//وعند عمليات الحذف والإضافة والتحديث ماعلينا سوا تمرير نسخة من الموديل
FirebaseFirestore fireStore = FirebaseFirestore.instance;
final CollectionReference<UserModel> usersRef =
    fireStore.collection("users").withConverter<UserModel>(
          fromFirestore: (snapshot, options) =>
              UserModel.fromFireStore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بتصنيفات المهام الخاصة بالمستخدمين
final CollectionReference userTaskCategoryRef = fireStore
    .collection("users_tasks_categories")
    .withConverter<UserTaskCategoryModel>(
      fromFirestore: (snapshot, options) =>
          UserTaskCategoryModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );
//الكولكشن الخاصة بمهام المستخدمين
final CollectionReference usersTasksRef =
    fireStore.collection("users_tasks").withConverter<UserTaskModel>(
          fromFirestore: (snapshot, options) =>
              UserTaskModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالحالة (المشروع أو المهام الفردية او الخاصة بالفرق)
final CollectionReference statusesRef =
    fireStore.collection("statuses").withConverter<StatusModel>(
          fromFirestore: (snapshot, options) =>
              StatusModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );

//الكولكشن الخاصة بالمدراء الذين هم المستخدمون الذين يمتلكون فرق في التطبيق
final CollectionReference managersRef =
    fireStore.collection("managers").withConverter<ManagerModel>(
          fromFirestore: (snapshot, options) =>
              ManagerModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بأعضاء الفرق
final CollectionReference teamMembersRef =
    fireStore.collection("team_members").withConverter<TeamMemberModel>(
          fromFirestore: (snapshot, options) =>
              TeamMemberModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//
final CollectionReference watingMamberRef =
    fireStore.collection("waiting_members").withConverter<WaitingMemberModel>(
          fromFirestore: (snapshot, options) =>
              WaitingMemberModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالفرق الموجودة في التطبيق تحتوي على المدير واي دي يمكننا من الوصول إلى أعضاء الفريق من خلال
//الكولكشن الخاصة بال تيم ميمبرز
final CollectionReference teamsRef =
    fireStore.collection("teams").withConverter<TeamModel>(
          fromFirestore: (snapshot, options) =>
              TeamModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالمشاريع يمكن معرفة الفريق الذي يستلم المشروع من خلال الاي دي والوصول له في الكولكشن الخاص به
final CollectionReference projectsRef =
    fireStore.collection("projects").withConverter<ProjectModel>(
          fromFirestore: (snapshot, options) =>
              ProjectModel.fromFirestore(snapshot, options),
          toFirestore: (value, options) => value.toFirestore(),
        );
//الكولكشن الخاصة بالمهام الرئيسية في المشروع الخاص بالفريق بحيث يمكن يندرج تحت المهمة الأساسية مهام فرعية
//وبذلك يمكننا تقسيم مهمة مثل تطوير الفرونت إلى أكثر من عضو في الفريق
//هي الميزة مو عند حدا ترا غيرنا انضم لنا وكن جزءاُ من فريق كل يومين بيتخانقو
final CollectionReference projectMainTasksRef = FirebaseFirestore.instance
    .collection("project_main_tasks")
    .withConverter<ProjectMainTaskModel>(
      fromFirestore: (snapshot, options) =>
          ProjectMainTaskModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );
//الكولكشن الخاصة بالمهام الفرعية في المشروع التي يتم إسنادها إلى أعضاء الفريق
//يمكن الوصول إلى العضو المراد إسناد المهمة إليه من خلال الكولكشن الخاصة بالأعضاء
final CollectionReference projectSubTasksRef = fireStore
    .collection("project_sub_tasks")
    .withConverter<ProjectSubTaskModel>(
      fromFirestore: (snapshot, options) =>
          ProjectSubTaskModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );
final CollectionReference watingSubTasksRef = fireStore
    .collection("waiting_sub_tasks")
    .withConverter<WaitingSubTaskModel>(
      fromFirestore: (snapshot, options) =>
          WaitingSubTaskModel.fromFirestore(snapshot, options),
      toFirestore: (value, options) => value.toFirestore(),
    );
