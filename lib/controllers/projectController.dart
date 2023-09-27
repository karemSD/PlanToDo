import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/statusController.dart';
import 'package:mytest/controllers/taskController.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/models/statusmodel.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';
import '../constants/back_constants.dart';
import '../models/team/Manger_model.dart';
import '../models/team/Project_model.dart';
import '../services/collectionsrefrences.dart';
import '../Utils/back_utils.dart';
import 'manger_controller.dart';

class ProjectController extends ProjectAndTaskController {
  Future<List<ProjectModel>> getAllManagersProjects() async {
    List<Object?>? list = await getAllListDataForRef(refrence: projectsRef);

    return list!.cast<ProjectModel>();
  }

  Future<void> updateProject2(
      {required String id, required Map<String, dynamic> data}) async {
    ProjectModel? projectModel = await getProjectById(id: id);

    if (data.containsKey(startDateK)) {
      DateTime? newStartDate = data[startDateK] as DateTime;
      if (newStartDate.isAfter(projectModel!.endDate!)) {
        //"Cannot update the start date after the end of project date has passed"
        Exception exception =
            Exception(AppConstants.start_date_update_error_key);
        throw exception;
      }
      if (projectModel.endDate!.isBefore(firebaseTime(DateTime.now()))) {
        Exception exception =
            //"Cannot update the start date after the end of project date has passed"
            Exception(AppConstants.project_start_date_update_error_key);
        throw exception;
      }
      if (await existByOne(
          collectionReference: projectMainTasksRef,
          field: projectIdK,
          value: projectModel.id)) {
        Exception exception =
            Exception(AppConstants.project_already_started_error_key);
        throw exception;
      }
    }
    if (data.containsKey(teamIdK)) {
      Exception exception = Exception(AppConstants.team_id_update_error_key);
      throw exception;
    }
    ManagerController managerController = Get.put(ManagerController());
    ManagerModel? managerModel =
        await managerController.getMangerOfProject(projectId: id);
    await updateRelationalFields(
      reference: projectsRef,
      data: data,
      id: id,
      fatherField: managerIdK,
      fatherValue: managerModel!.id,
      nameException: Exception(AppConstants.already_existing_project_key),
    );
    //   await updateFields(reference: projectsRef, data: data, id: id);
  }

  Stream<QuerySnapshot<ProjectModel>> getAllManagersProjectsStream() {
    Stream<QuerySnapshot> stream =
        getAllListDataForRefStream(refrence: projectsRef);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<ProjectModel> getManagerProjectByName(
      {required String name, required String managerId}) async {
    DocumentSnapshot documentSnapshot = await getDocSnapShotByNameInTow(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        name: name);
    return documentSnapshot.data() as ProjectModel;
  }

  Stream<DocumentSnapshot<ProjectModel>> getManagerProjectByNameStream(
      {required String name, required String managerId}) {
    Stream<DocumentSnapshot> stream = getDocByNameInTowStream(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        name: name);
    return stream.cast<DocumentSnapshot<ProjectModel>>();
  }

  Future<void> addProject({required ProjectModel projectModel}) async {
    // الشرط الأول للتأكد من انو مدير هل المشروع موجود بالداتا بيز او لأ بجدول المانجرز
    if (await existByOne(
        collectionReference: managersRef,
        field: idK,
        value: projectModel.managerId)) {
      if (projectModel.teamId != null) {
        //الشرط التاني انو اذا كان ضايف تتيم ضغري اول ماانشئ المشروع شوف انو هل التيم يلي ضفتو موجود بالداتا بيز اولا ويكون مدير المشروع هاد هو نفسو مدير هل التيم
        if (await existByTow(
            reference: teamsRef,
            field: idK,
            value: projectModel.teamId,
            field2: managerIdK,
            value2: projectModel.managerId)) {
          //في حال تحقق الشرطين انو المانجر بالداتا بيز والفريق وموجود والمناجر نفسو للتنين بيضيف المشروع
          StatusModel statusModel =
              await StatusController().getStatusByName(status: statusDone);

          QuerySnapshot anotherProjects = await projectsRef
              .where(teamIdK, isEqualTo: projectModel.teamId)
              .where(statusIdK, isNotEqualTo: statusModel.id)
              .limit(1)
              .get();

          if (anotherProjects.docs.isNotEmpty) {
            Exception exception =
                Exception(AppConstants.team_project_overlap_error_key.tr);
            throw exception;
          } else {
            await addDoc(reference: projectsRef, model: projectModel);
            return;
          }
        } else {
          //في حال كان المانجر موجود بالداتا بيز والمشروع الو فريق بس هل الفريق مالو بالداتا بيز او المدير تبع هل التيم غير مدير المشروع مابيسمحلو يضيف
          Exception exception =
              Exception(AppConstants.team_manager_error_key.tr);
          throw exception;
        }
      }
      {
        //في حال موجود المانجر وتمام بس مافي فريق بيضيف ضغري لانو مسموح هل الشي
        await addDoc(reference: projectsRef, model: projectModel);
        return;
      }
    } else {
      //في حال إعطاء ايدي لمانجر غير موجود بالداتا بيز اصلا
      Exception exception =
          Exception(AppConstants.manager_not_found_error_key.tr);
      throw exception;
    }
  }

// لجلب المشروع الخاص بهل الفريق  إن وجد
  Future<ProjectModel?> getProjectOfTeam({required String teamId}) async {
    StatusModel statusModel =
        await StatusController().getStatusByName(status: statusNotDone);
    DocumentSnapshot? porjectDoc = await getDocSnapShotWhereAndWhere(
        secondField: statusIdK,
        secondValue: statusModel.id,
        collectionReference: projectsRef,
        firstField: teamIdK,
        firstValue: teamId);

    return porjectDoc.data() as ProjectModel;
  }

  Stream<DocumentSnapshot<ProjectModel>> getProjectOfTeamStream(
      {required String teamId}) {
    Stream<DocumentSnapshot> projectDoc = getDocWhereStream(
        collectionReference: projectsRef, field: teamIdK, value: teamId);
    return projectDoc.cast<DocumentSnapshot<ProjectModel>>();
  }

  //جلب جميع المشاريع الخاصة بهل المانجر
  Future<List<ProjectModel?>?> getProjectsOfManager(
      {required String mangerId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectsRef, field: managerIdK, value: mangerId);
    if (list != null && list.isNotEmpty) {
      return list.cast<ProjectModel>();
    }
    return null;
  }

  Stream<QuerySnapshot<ProjectModel>> getManagerProjectsStartInADayStream(
      {required DateTime date,
      required String managerId,
      required String status}) {
    Stream<QuerySnapshot> stream = getTasksStartInADayForAStatusStream(
        status: status,
        reference: projectsRef,
        date: date,
        field: managerIdK,
        value: managerId);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsStartInADayForAStatus(
      {required DateTime date,
      required String mangerId,
      required String status}) async {
    List<Object?>? list = await getTasksStartInADayForAStatus(
      status: status,
      reference: projectsRef,
      date: date,
      field: managerIdK,
      value: mangerId,
    );
    return list!.cast<ProjectModel>();
  }

  Future<List<double>>
      getPercentagesForLastSevenDaysforaProjectMainTasksforAStatus(
          String managerId, DateTime startdate, String status) async {
    List<double> list = await getPercentagesForLastSevenDays(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        currentDate: startdate,
        status: status);
    return list;
  }

  Future<List<ProjectModel?>?> getProjectsOfUser(
      {required String userId}) async {
    ManagerController managerController = Get.put(ManagerController());
    ManagerModel? managerModel = await managerController.getMangerWhereUserIs(
        userId: AuthService.instance.firebaseAuth.currentUser!.uid);
    if (managerModel != null) {
      List<ProjectModel?>? list =
          await getProjectsOfManager(mangerId: managerModel.id);
      return list;
    }

    return null;
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsOfUserStream(
      {required String userId}) async* {
    ManagerController managerController = Get.put(ManagerController());
    ManagerModel? managerModel =
        await managerController.getMangerWhereUserIs(userId: userId);
    if (managerModel == null) {
      throw Exception(AppConstants.make_project_first_error_key.tr);
    }

    Stream<QuerySnapshot> projectsStream = queryWhereStream(
        reference: projectsRef, field: managerIdK, value: managerModel!.id);
    yield* projectsStream.cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsOfManagerStream(
      {required String mangerId}) {
    Stream<QuerySnapshot> projectsStream = queryWhereStream(
        reference: projectsRef, field: managerIdK, value: mangerId);
    return projectsStream.cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsOfTeamStream(
      {required String teamId}) {
    Stream<QuerySnapshot> projectsStream =
        queryWhereStream(reference: projectsRef, field: teamIdK, value: teamId);
    return projectsStream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getProjectsOfTeamKarem(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectsRef, field: teamIdK, value: teamId);
    return list!.cast<ProjectModel>();
  }

  Future<List<ProjectModel?>?> getProjectsOfTeam(
      {required String teamId}) async {
    List<Object?>? list = await getListDataWhere(
        collectionReference: projectsRef, field: teamIdK, value: teamId);
    if (list != null && list.isNotEmpty) {
      return list.cast<ProjectModel>();
    }
    return null;
  }

//جلب المشروع بواسطة الايدي
  Future<ProjectModel?> getProjectById({required String id}) async {
    DocumentSnapshot projectDoc =
        await getDocById(reference: projectsRef, id: id);
    return projectDoc.data() as ProjectModel?;
  }

  Stream<DocumentSnapshot<ProjectModel>> getProjectByIdStream(
      {required String id}) {
    Stream<DocumentSnapshot> projectDoc =
        getDocByIdStream(reference: projectsRef, id: id);
    return projectDoc.cast<DocumentSnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsWhereteamInStream(
      {required List<String> listteamsId}) {
    return projectsRef
        .where(teamIdK, whereIn: listteamsId)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

  Stream<QuerySnapshot<ProjectModel>> getProjectsWhereIdsIN(
      {required List<String> listProjectsId}) {
    return projectsRef
        .where(idK, whereIn: listProjectsId)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

//  Future<List<ProjectModel>> getProjectsWhereteamIn({required List<String> listteamsId}) async {
//   QuerySnapshot<Object?> querySnapshot = await projectsRef
//       .where(teamIdK, whereIn: listteamsId)
//       .get()
//       .catchError((error) {
//     print("Error getting projects: $error");
//     return null;
//   });

//     List<ProjectModel> projects = querySnapshot.docs.map((doc) {
//       return ProjectModel.fromFirestore(doc as DocumentSnapshot ,);
//     }).toList();

//     return projects;

// }

  Stream<QuerySnapshot<ProjectModel>>
      getProjectsOfManagerWhereUserIsInADayStream({
    required String userId,
    required DateTime date,
  }) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));
    List<String> projectsInTheDay = [];

    Completer<List<String>> completer = Completer<List<String>>();

    getProjectsOfUserStream(userId: userId).listen(
      (event) {
        List<QueryDocumentSnapshot<ProjectModel?>> list = event.docs;
        for (var element in list) {
          ProjectModel projectModel = element.data()!;
          if (projectModel.startDate.isAfter(startOfDay) &&
              projectModel.startDate.isBefore(endOfDay)) {
            projectsInTheDay.add(projectModel.id);
          }
        }

        if (!completer.isCompleted) {
          completer.complete(projectsInTheDay);
        }
      },
    );

    List<String> projectsFinal = await completer.future;

    if (projectsFinal.isEmpty) {
      throw Exception(
          "No projects I am a manager of that start in the given day");
    }

    yield* getProjectsWhereIdsIN(listProjectsId: projectsFinal);
  }

  Stream<QuerySnapshot<ProjectModel>>
      getProjectsOfMemberWhereUserIsInADayStream({
    required String userId,
    required DateTime date,
  }) async* {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay =
        startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));

    List<String> projectsInTheDay = [];
    List<ProjectModel?> list =
        await getProjectsOfMemberWhereUserIs2(userId: userId);

    for (var projectModel in list) {
      if (projectModel!.startDate.isAfter(startOfDay) &&
          projectModel.startDate!.isBefore(endOfDay)) {
        if (!projectsInTheDay.contains(projectModel.id)) {
          projectsInTheDay.add(projectModel.id);
        }
      }
    }

    if (projectsInTheDay.isEmpty) {
      throw Exception("no projects I am a member of");
    }

    yield* getProjectsWhereIdsIN(listProjectsId: projectsInTheDay);
  }

//olds
  // Stream<QuerySnapshot<ProjectModel>>
  //     getProjectsOfMemberWhereUserIsInADayStream(
  //         {required String userId, required DateTime date}) async* {
  //   final startOfDay = DateTime(date.year, date.month, date.day);
  //   final endOfDay =
  //       startOfDay.add(Duration(days: 1)).subtract(Duration(seconds: 1));
  //   List<String> prjectsInTheDay = [];
  //   List<ProjectModel?> list =
  //       await getProjectsOfMemberWhereUserIs2(userId: userId);
  //   for (var projectModel in list) {
  //     if (projectModel!.startDate.isAfter(startOfDay) &&
  //         projectModel.endDate!.isBefore(endOfDay)) {
  //       if (!prjectsInTheDay.contains(projectModel.id)) {
  //         prjectsInTheDay.add(projectModel.id);
  //       }
  //     }
  //   }
  //   if (prjectsInTheDay.isEmpty) {
  //     throw Exception("no  projects iam member of");
  //   }
  //   yield* getProjectsWhereIdsIN(listProjectsId: prjectsInTheDay);
  // }

  Future<List<ProjectModel?>> getProjectsOfMemberWhereUserIs2(
      {required String userId}) async {
    TeamController teamController = TeamController();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    List<ProjectModel?> projects = <ProjectModel>[];
    for (TeamModel team in teams) {
      List<ProjectModel?>? projects2;
      projects2 = await getProjectsOfTeam(teamId: team.id);
      projects2?.forEach((element) {
        projects.add(element);
      });
    }
    return projects;
  }

  Stream<QuerySnapshot<ProjectModel?>> getProjectsOfMemberWhereUserIs2Stream(
      {required String userId}) async* {
    TeamController teamController = TeamController();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    List<String> projects = [];
    for (TeamModel team in teams) {
      getProjectsOfTeamStream(teamId: team.id).listen(
        (event) {
          List<QueryDocumentSnapshot<ProjectModel>> list = event!.docs;
          for (var element in list) {
            projects.add(element.data().id);
          }
        },
      );
    }
    if (projects.isEmpty) {
      throw Exception("no project iam member of");
    }
    yield* getProjectsWhereIdsIN(listProjectsId: projects);
  }

  Future<List<ProjectModel?>> getProjectsOfMemberWhereUserIs(
      {required String userId}) async {
    TeamController teamController = TeamController();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    List<ProjectModel?> projects = <ProjectModel>[];
    for (TeamModel team in teams) {
      ProjectModel? projectModel = await getProjectOfTeam(teamId: team.id);
      projects.add(projectModel);
    }
    return projects;
  }

  Stream<QuerySnapshot<ProjectModel?>>
      getProjectsOfMemberWhereUserIsStreamOrderBy(
          {required String userId,
          required String field,
          required bool descending}) async* {
    TeamController teamController = TeamController();
    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);
    print("the tems is ${teams.length}");
    List<String> teamsId = <String>[];
    for (TeamModel team in teams) {
      teamsId.add(team.id);
      print("   project controller ${team.id}");
    }

    yield* projectsRef
        .where(teamIdK, whereIn: teamsId)
        .orderBy(descending: descending, nameK)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

//عطيني كل المشاريع يلي مشترك فيها هل الزلمة كعضو
  Stream<QuerySnapshot<ProjectModel?>> getProjectsOfMemberWhereUserIsStream(
      {required String userId}) async* {
    TeamController teamController = TeamController();

    List<TeamModel> teams =
        await teamController.getTeamsofMemberWhereUserId(userId: userId);

    print("the tems is ${teams.length}");
    List<String> teamsId = <String>[];
    if (teams.isNotEmpty) {
      for (TeamModel team in teams) {
        teamsId.add(team.id);
        print("   project controller ${team.id}");
      }
    } else {
      throw Exception(AppConstants.not_member_no_projects_error_key.tr);
    }

    yield* projectsRef
        .where(teamIdK, whereIn: teamsId)
        .snapshots()
        .cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsStartInASpecificTime(
      {required DateTime date, required String managerId}) async {
    List<Object?>? list = await getTasksStartInASpecificTime(
        reference: projectsRef,
        date: date,
        field: managerIdK,
        value: managerId);
    return list!.cast<ProjectModel>();
  }

  Stream<QuerySnapshot<ProjectModel>>
      getManagerProjectsStartInASpecificTimeStream(
          {required DateTime date, required String managerId}) {
    Stream<QuerySnapshot> stream = getTasksStartInASpecificTimeStream(
        reference: projectsRef,
        date: date,
        field: managerIdK,
        value: managerId);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsBetweenTowTimes({
    required DateTime firstDate,
    required DateTime secondDate,
    required String managerId,
  }) async {
    List<Object?>? list = await getTasksStartBetweenTowTimes(
      reference: projectsRef,
      field: managerIdK,
      value: managerId,
      firstDate: firstDate,
      secondDate: secondDate,
    );
    return list!.cast<ProjectModel>();
  }

  Stream<QuerySnapshot<ProjectModel>> getManagerProjectsBetweenTowTimesStream(
      {required DateTime firstDate,
      required DateTime secondDate,
      required String managerId}) {
    Stream<QuerySnapshot> stream = getTasksStartBetweenTowTimesStream(
        reference: projectsRef,
        field: managerIdK,
        value: managerId,
        firstDate: firstDate,
        secondDate: secondDate);
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<List<ProjectModel>> getManagerProjectsForAStatus(
      {required String managerId, required String status}) async {
    List<Object?>? list = await getTasksForStatus(
      status: status,
      reference: projectsRef,
      field: managerIdK,
      value: managerId,
    );
    return list!.cast<ProjectModel>();
  }

  Stream<QuerySnapshot<ProjectModel>> getManagerProjectsForAStatusStream(
      {required String managerId, required String status}) {
    Stream<QuerySnapshot> stream = getTasksForAStatusStream(
      status: status,
      reference: projectsRef,
      field: managerIdK,
      value: managerId,
    );
    return stream.cast<QuerySnapshot<ProjectModel>>();
  }

  Future<double> getPercentOfManagerProjectsForAStatus({
    required String status,
    required String managerId,
  }) async {
    return await getPercentOfTasksForAStatus(
      reference: projectsRef,
      status: status,
      field: managerIdK,
      value: managerId,
    );
  }

  Future<double> getPercentOfManagerProjectsForAStatusBetweenTowTimes({
    required String status,
    required String managerId,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: projectsRef,
        status: status,
        field: managerIdK,
        value: managerId,
        firstDate: firstDate,
        secondDate: secondDate);
  }

//تحديث معلومات المشروع والشروط الخاصة بهذا العمل
  Future<void> updateProject(
      {required String id,
      required ManagerModel managerModel,
      required Map<String, dynamic> data,
      required ProjectModel oldProject}) async {
    print("update 1");

    if (data.containsKey(startDateK)) {
      DateTime? newStartDate = data[startDateK] as DateTime;
      if (newStartDate.isAfter(oldProject.endDate!)) {
        Exception exception =
            Exception(AppConstants.start_date_update_error_key.tr);
        throw exception;
      }
      print("update 2");

      if (oldProject.endDate!.isBefore(firebaseTime(DateTime.now()))) {
        Exception exception =
            Exception(AppConstants.project_start_date_update_error_key.tr);
        throw exception;
      }
      if (await existByOne(
          collectionReference: projectMainTasksRef,
          field: projectIdK,
          value: id)) {
        Exception exception =
            Exception(AppConstants.project_already_started_error_key.tr);
        throw exception;
      }
      print("update 3");
    }
    if (data.containsKey(teamIdK)) {
      Exception exception = Exception(AppConstants.team_id_update_error_key.tr);
      throw exception;
    }
    print("update 3");

    await updateRelationalFields(
      reference: projectsRef,
      data: data,
      id: id,
      fatherField: managerIdK,
      fatherValue: managerModel.id,
      nameException: Exception(AppConstants.already_existing_project_key.tr),
    );
    //   await updateFields(reference: projectsRef, data: data, id: id);
  }

//حذف المشروع وجميع المهام الرئيسية والفرعية الخاصة به
  Future<void> deleteProject(String id) async {
    WriteBatch batch = fireStore.batch();
    DocumentSnapshot project =
        //جلب هذا المشروع
        await getDocById(reference: projectsRef, id: id);
    ProjectModel projectModel = project.data() as ProjectModel;
    //حذفه
    deleteDocUsingBatch(documentSnapshot: project, refbatch: batch);
    //حذف الصورة الخاصة بالمشروع من الداتا بيز
    await firebaseStorage.refFromURL(projectModel.imageUrl).delete();
    //جلب جميع المهام الرئيسة
    List<DocumentSnapshot> listMainTasks = await getDocsSnapShotWhere(
        collectionReference: projectMainTasksRef, field: projectIdK, value: id);
    //جلب جميع المهام الفرعية
    List<DocumentSnapshot> listSubTasks = await getDocsSnapShotWhere(
        collectionReference: projectSubTasksRef, field: projectIdK, value: id);
    //حذفهما
    deleteDocsUsingBatch(list: listMainTasks, refBatch: batch);
    deleteDocsUsingBatch(list: listSubTasks, refBatch: batch);
    batch.commit();
  }
}
