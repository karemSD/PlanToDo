import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/statusController.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/models/User/User_task_Model.dart';
import 'package:mytest/models/tops/Var2TopModel.dart';

import '../constants/back_constants.dart';
import '../models/statusmodel.dart';
import '../models/team/Task_model.dart';
import '../models/tops/TopModel_model.dart';
import '../services/collectionsrefrences.dart';
import '../Utils/back_utils.dart';

class ProjectAndTaskController extends TopController {
  Future<List<Object?>?> getTasksForStatus<t extends TopModel>({
    required String status,
    required CollectionReference reference,
    required String field,
    required dynamic value,
  }) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    final StatusModel statusModel = documentSnapshot!.data() as StatusModel;
    return await getListDataWhereAndWhere(
      collectionReference: reference,
      firstField: statusIdK,
      firstValue: statusModel.id,
      secondField: field,
      secondValue: value,
    );
  }

  Stream<QuerySnapshot<Object?>> getTasksForAStatusStream({
    required String status,
    required CollectionReference reference,
    required String field,
    required dynamic value,
  }) async* {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    final StatusModel statusModel = documentSnapshot!.data() as StatusModel;
    print(statusModel.name);
    yield* queryWhereAndWhereStream(
      reference: reference,
      firstField: statusIdK,
      firstValue: statusModel.id,
      secondField: field,
      secondValue: value,
    );
  }

  Future<double> getPercentOfTasksForAStatus(
      {required String field,
      required dynamic value,
      required String status,
      required CollectionReference reference}) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    final StatusModel statusModel = documentSnapshot!.data() as StatusModel;

    int matchingStatusAndFieldValue = (await queryWhereAndWhere(
            reference: reference,
            firstField: statusIdK,
            firstValue: statusModel.id,
            secondField: field,
            secondValue: value))
        .size;
    int totalMatchingFieldValue =
        (await queryWhere(reference: reference, field: field, value: value))
            .size;
    if (totalMatchingFieldValue == 0) {
      return 0;
    } else {
      return (matchingStatusAndFieldValue / totalMatchingFieldValue) * 100;
    }
  }

  Stream<double> getPercentOfTasksForAStatusStream(
      {required String field,
      required dynamic value,
      required String status,
      required CollectionReference reference}) async* {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    final StatusModel statusModel = documentSnapshot!.data() as StatusModel;
    Stream<int> matchingStatusAndFieldValues = queryWhereAndWhereStream(
            reference: reference,
            firstField: statusIdK,
            firstValue: statusModel.id,
            secondField: field,
            secondValue: value)
        .map((snapshot) => snapshot.size);
    Stream<int> totalMatchingFieldValues = await (queryWhereAndWhereStream(
            reference: reference,
            firstField: statusIdK,
            firstValue: statusModel.id,
            secondField: field,
            secondValue: value)
        .map((snapshot) => snapshot.size));
    int matchingStatusAndFieldValue = await (queryWhereAndWhereStream(
            reference: reference,
            firstField: statusIdK,
            firstValue: statusModel.id,
            secondField: field,
            secondValue: value))
        .length;
    int totalMatchingFieldValue = await (queryWhereStream(
            reference: reference, field: field, value: value))
        .length;
    if (totalMatchingFieldValue == 0) {
      yield 0;
    }
    yield (matchingStatusAndFieldValue / totalMatchingFieldValue) * 100;
  }

//! TODO make this func work
  Future<List<double>> getPercentagesForLastSevenDays({
    required CollectionReference reference,
    required String status,
    required String field,
    required dynamic value,
    required DateTime currentDate,
  }) async {
    List<double> percentages = [];

    for (int i = 0; i < 7; i++) {
      DateTime startDate = currentDate.subtract(Duration(days: i));
      DateTime startDate1 =
          DateTime(startDate.year, startDate.month, startDate.day);

      DateTime endDate = startDate1.add(const Duration(days: 1));
      double percentage = await getPercentOfTasksForAStatusBetweenTowStartTimes(
        reference: reference,
        status: status,
        field: field,
        value: value,
        firstDate: startDate1,
        secondDate: endDate,
      );

      percentages.add(percentage.toDouble());
    }
    List<double> rev = percentages.reversed.toList();
    return rev;
  }

  Future<double> getPercentOfTasksForAStatusBetweenTowStartTimes({
    required CollectionReference reference,
    required String status,
    required String field,
    required dynamic value,
    required DateTime firstDate,
    required DateTime secondDate,
  }) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    final StatusModel statusModel = documentSnapshot!.data() as StatusModel;

    int matchingStatusAndFieldValue =
        (await getTasksAndProjectBetweenTowTimesByTowFields(
                reference: reference,
                firstField: statusIdK,
                firstValue: statusModel.id,
                secondField: field,
                secondValue: value,
                firstDateField: startDateK,
                firstDate: firstDate,
                secondDateField: startDateK,
                secondDate: secondDate))
            .length;
    int totalMatchingFieldValue =
        (await getTasksAndProjectBetweenTowTimesByOneField(
                reference: reference,
                field: field,
                value: value,
                firstDateField: startDateK,
                firstDate: firstDate,
                secondDateField: startDateK,
                secondDate: secondDate))
            .length;
    if (totalMatchingFieldValue == 0) {
      return 0;
    }
    return (matchingStatusAndFieldValue / totalMatchingFieldValue) * 100;
  }

  Stream<double> getPercentOfTasksForAStatusBetweenTowStartTimesStream({
    required CollectionReference reference,
    required String status,
    required String field,
    required dynamic value,
    required DateTime firstDate,
    required DateTime secondDate,
  }) async* {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    final StatusModel statusModel = documentSnapshot!.data() as StatusModel;
    int matchingStatusAndFieldValue =
        (await getTasksAndProjectBetweenTowTimesByTowFields(
                reference: reference,
                firstField: statusIdK,
                firstValue: statusModel,
                secondField: field,
                secondValue: value,
                firstDateField: startDateK,
                firstDate: firstDate,
                //TODO
                secondDateField: startDateK,
                secondDate: secondDate))
            .length;
    int totalMatchingFieldValue =
        (await getTasksAndProjectBetweenTowTimesByOneField(
                reference: reference,
                field: field,
                value: value,
                firstDateField: startDateK,
                firstDate: firstDate,
                //TODO
                secondDateField: startDateK,
                secondDate: secondDate))
            .length;
    if (totalMatchingFieldValue == 0) {
      yield 0;
    }
    yield (matchingStatusAndFieldValue / totalMatchingFieldValue) * 100;
  }

  Future<List<Object?>?> getTasksForAnImportance<t extends TopModel>({
    required CollectionReference reference,
    required String field,
    required String value,
    required int importance,
  }) async {
    Exception exception;
    if (importance < 1) {
      exception = Exception(AppConstants.importance_min_value_error_key);
      throw exception;
    }
    if (importance > 5) {
      exception = Exception(AppConstants.importance_max_value_error_key);
      throw exception;
    }
    return await getListDataWhereAndWhere(
      collectionReference: reference,
      firstField: field,
      firstValue: value,
      secondField: importanceK,
      secondValue: importance,
    );
  }

  Stream<QuerySnapshot<Object?>>
      getTasksForAnImportanceStream<t extends TopModel>({
    required CollectionReference reference,
    required String field,
    required String value,
    required int importance,
  }) {
    Exception exception;
    if (importance < 1) {
      exception = Exception(AppConstants.importance_min_value_error_key);
      throw exception;
    }
    if (importance > 5) {
      exception = Exception(AppConstants.importance_max_value_error_key);
      throw exception;
    }
    return queryWhereAndWhereStream(
      reference: reference,
      firstField: field,
      firstValue: value,
      secondField: importanceK,
      secondValue: importance,
    );
  }

  Future<List<Object?>?> getTasksStartInADayForAStatus<t extends TopModel>({
    required CollectionReference reference,
    required DateTime date,
    required String field,
    required dynamic value,
    required dynamic status,
  }) async {
    date = firebaseTime(date);
    DateTime newDate = DateTime(
      date.year,
      date.month,
      date.day,
      0,
      0,
      0,
    );
    print(newDate);
    StatusController statusController = Get.put(StatusController());
    StatusModel statusModel =
        await statusController.getStatusByName(status: status);
    return await getDocsWhereAndWhereForDate(
      secondField: statusIdK,
      secondValue: statusModel.id,
      reference: reference,
      firstField: field,
      firstValue: value,
      startDateField: startDateK,
      startDateFieldValue: date,
      endDateField: startDateK,
      endDateValue: date.add(
        const Duration(days: 1),
      ),
    );
  }

  Stream<QuerySnapshot<Object?>> getTasksStartInADayStream({
    required CollectionReference reference,
    required DateTime date,
    required String field,
    required dynamic value,
  }) async* {
    DateTime startDate = DateTime(
      date.year,
      date.month,
      date.day,
      0,
      0,
      0,
    );
    DateTime endDate = startDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    print(startDate);
    StatusController statusController = Get.put(StatusController());
    yield* queryWhereForDateStream(
        reference: reference,
        field: field,
        value: value,
        startDateField: startDateK,
        startDateFieldValue: startDate,
        endDateField: startDateK,
        endDateValue: endDate);
  }

  Stream<QuerySnapshot<Object?>> getTasksStartInADayForAStatusStream({
    required CollectionReference reference,
    required DateTime date,
    required String field,
    required dynamic value,
    required String status,
  }) async* {
    DateTime newDate = DateTime(
      date.year,
      date.month,
      date.day,
      0,
      0,
      0,
    );
    StatusController statusController = Get.put(StatusController());
    StatusModel statusModel =
        await statusController.getStatusByName(status: status);
    yield* queryWhereAndWhereForDateStream(
      reference: reference,
      firstField: field,
      firstValue: value,
      secondField: statusIdK,
      secondValue: statusModel.id,
      startDateField: startDateK,
      startDateFieldValue: newDate,
      endDateField: startDateK,
      endDateValue: newDate.add(
        const Duration(days: 1),
      ),
    );
  }

  List<Var2TopModel> getTasksAndProjectBetweenTowTimesByTowFieldsStream({
    required CollectionReference reference,
    required String secondField,
    required dynamic secondValue,
    required String firstField,
    required dynamic firstValue,
    required DateTime firstDate,
    required String firstDateField,
    required DateTime secondDate,
    required String secondDateField,
  }) {
    Stream<QuerySnapshot<Object?>> querySnapshot =
        queryWhereAndWhereDateGreatStream(
            reference: reference,
            firstField: firstField,
            firstValue: firstValue,
            secondField: secondField,
            secondValue: secondValue,
            startDateField: firstDateField,
            startDateValue: firstDate);
    Stream<QuerySnapshot<Object?>> querySnapshot1 =
        queryWhereAndWhereDateLessStream(
            reference: reference,
            firstField: firstField,
            firstValue: firstValue,
            secondField: userIdK,
            secondValue: secondValue,
            startDateField: secondDateField,
            startDateValue: secondDate);
    List<Var2TopModel> s = [];
    querySnapshot1.listen((event) {
      for (QueryDocumentSnapshot<Object?> element in event.docs) {
        s.add(element.data() as Var2TopModel);
        print(element.data());
      }
    });
    querySnapshot.listen((event) {
      for (QueryDocumentSnapshot<Object?> element in event.docs) {
        s.add(element.data() as Var2TopModel);
        print(element.data());
      }
    });
    List<Var2TopModel> ss = s.unique((s) => s.id);
    for (var element in ss) {
      print(element.name);
    }
    return ss;
  }

  Future<List<Var2TopModel>> getTasksAndProjectBetweenTowTimesByTowFields({
    required CollectionReference reference,
    required String secondField,
    required dynamic secondValue,
    required String firstField,
    required dynamic firstValue,
    required DateTime firstDate,
    required String firstDateField,
    required DateTime secondDate,
    required String secondDateField,
  }) async {
    QuerySnapshot<Object?> querySnapshot = await queryWhereAndWhereDateGreat(
        reference: reference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue,
        startDateField: firstDateField,
        startDateValue: firstDate);
    QuerySnapshot<Object?> querySnapshot1 = await queryWhereAndWhereDateLess(
        reference: reference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue,
        startDateField: secondDateField,
        startDateValue: secondDate);
    List<Var2TopModel> great = [];
    List<Var2TopModel> less = [];
    for (var element in querySnapshot1.docs) {
      less.add(element.data() as Var2TopModel);
    }
    for (var element in querySnapshot.docs) {
      great.add(element.data() as Var2TopModel);
    }

    List<Var2TopModel> finalList = [];
    for (var obj1 in less) {
      for (var obj2 in great) {
        if (obj1.name == obj2.name) {
          finalList.add(obj2);
          break; // Move to the next obj1
        }
      }
    }
    finalList.forEach((element) {
      print(element!.name! + "hello");
    });
    return finalList;
  }

  List<Var2TopModel> getTasksAndProjectBetweenTowTimesByOneFieldStream({
    required CollectionReference reference,
    required String field,
    required dynamic value,
    required DateTime firstDate,
    required String firstDateField,
    required DateTime secondDate,
    required String secondDateField,
  }) {
    Stream<QuerySnapshot<Object?>> querySnapshot = queryWhereDateGreatStream(
        reference: reference,
        firstField: field,
        firstValue: value,
        startDateField: firstDateField,
        startDateValue: firstDate);
    Stream<QuerySnapshot<Object?>> querySnapshot1 = queryWhereDateLessStream(
        reference: reference,
        firstField: field,
        firstValue: value,
        startDateField: secondDateField,
        startDateValue: secondDate);
    List<Var2TopModel> s = [];
    querySnapshot1.listen((event) {
      for (QueryDocumentSnapshot<Object?> element in event.docs) {
        s.add(element.data() as Var2TopModel);
      }
    });
    querySnapshot.listen((event) {
      for (QueryDocumentSnapshot<Object?> element in event.docs) {
        s.add(element.data() as Var2TopModel);
      }
    });
    List<Var2TopModel> ss = s.unique((s) => s.id);
    for (var element in ss) {}
    return ss;
  }

  Future<List<Var2TopModel>> getTasksAndProjectBetweenTowTimesByOneField({
    required CollectionReference reference,
    required String field,
    required dynamic value,
    required DateTime firstDate,
    required String firstDateField,
    required DateTime secondDate,
    required String secondDateField,
  }) async {
    QuerySnapshot<Object?> querySnapshot = await queryWhereDateGreat(
        reference: reference,
        firstField: field,
        firstValue: value,
        startDateField: firstDateField,
        startDateValue: firstDate);
    QuerySnapshot<Object?> querySnapshot1 = await queryWhereDateLess(
        reference: reference,
        firstField: field,
        firstValue: value,
        startDateField: secondDateField,
        startDateValue: secondDate);
    List<Var2TopModel> great = [];
    List<Var2TopModel> less = [];
    for (var element in querySnapshot1.docs) {
      less.add(element.data() as Var2TopModel);
    }
    for (var element in querySnapshot.docs) {
      great.add(element.data() as Var2TopModel);
    }
    List<Var2TopModel> finalList = [];
    for (var obj1 in less) {
      for (var obj2 in great) {
        if (obj1.name == obj2.name) {
          finalList.add(obj2);
          break; // Move to the next obj1
        }
      }
    }

    return finalList;
  }

  Future<List<Object?>?> getTasksStartInASpecificTime<t extends TopModel>({
    required CollectionReference reference,
    required DateTime date,
    required String field,
    required dynamic value,
  }) async {
    date = firebaseTime(date);
    return await getListDataWhereAndWhere(
      collectionReference: reference,
      firstField: field,
      firstValue: value,
      secondField: startDateK,
      secondValue: date,
    );
  }

  Stream<QuerySnapshot<Object?>> getTasksStartInASpecificTimeStream({
    required CollectionReference reference,
    required DateTime date,
    required String field,
    required dynamic value,
  }) {
    date = firebaseTime(date);
    return queryWhereAndWhereStream(
      reference: reference,
      firstValue: field,
      firstField: value,
      secondField: startDateK,
      secondValue: date,
    );
  }

  Future<List<Object?>?> getTasksStartBetweenTowTimes<t extends TaskClass>({
    required CollectionReference reference,
    required String field,
    required String value,
    required DateTime firstDate,
    required DateTime secondDate,
  }) async {
    return await getDocsWhereForDate(
        reference: reference,
        firstField: field,
        firstValue: value,
        startDateField: startDateK,
        startDateFieldValue: firstDate,
        endDateField: startDateK,
        endDateValue: secondDate);
  }

  Stream<QuerySnapshot<Object?>> getTasksStartBetweenTowTimesStream({
    required CollectionReference reference,
    required String field,
    required String value,
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    return queryWhereForDateStream(
        reference: reference,
        field: field,
        value: value,
        startDateField: startDateK,
        startDateFieldValue: firstDate,
        endDateField: startDateK,
        endDateValue: secondDate);
  }

  Future<void> addTask<t extends TaskClass>({
    required t taskModel,
    required String field,
    required dynamic value,
    required CollectionReference reference,
    required Exception exception,
  }) async {
    if (await existByTow(
      reference: reference,
      field: field,
      value: value,
      field2: nameK,
      value2: taskModel.name,
    )) {
      throw exception;
    }

    await addDoc(reference: reference, model: taskModel);
  }

  Future<void> addLateTask<t extends TaskClass>({
    required TaskClass taskModel,
    required String field,
    required String value,
    required CollectionReference reference,
    required Exception exception,
  }) async {
    if (await existByTow(
      reference: reference,
      field: field,
      value: value,
      field2: nameK,
      value2: taskModel.name,
    )) {
      throw exception;
    }
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: statusDone,
    );
    final StatusModel statusModel = documentSnapshot!.data() as StatusModel;
    taskModel.statusId = statusModel.id;
    await addDoc(reference: reference, model: taskModel);
  }

  Future<void> updateTask({
    required Map<String, dynamic> data,
    required String id,
    required String field,
    required String value,
    required CollectionReference reference,
    required Exception exception,
  }) async {
    print(data);
    //TODO مرر البارمترات يلي بدك تضيفن حسب الحكي يلي حكيناه اخر مرة
    await updateRelationalFields(
      reference: reference,
      data: data,
      id: id,
      fatherField: field,
      fatherValue: value,
      nameException: exception,
    );
    return;
  }
}
