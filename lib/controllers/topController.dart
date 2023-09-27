import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mytest/models/tops/TopModel_model.dart';

import '../constants/back_constants.dart';
import '../Utils/back_utils.dart';

class TopController extends GetxController {
  //جلب الدوكبومنتس ضغري عن  طريق سناب شوت وبعتها مشان ماتعذب باخد الكويري بعدين واوصل للدوكز يلي بقلبها ضغري ببعتهن
  Future<List<QueryDocumentSnapshot<Object?>>> getDocsSnapShotWhere(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async {
    QuerySnapshot querySnapshot = await queryWhere(
        reference: collectionReference, field: field, value: value);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    return list;
  }

//جلب الدوك بشكل فوري
  Future<QueryDocumentSnapshot<Object?>?> getDocSnapShotWhere(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async {
    QuerySnapshot querySnapshot = await queryWhere(
        reference: collectionReference, field: field, value: value);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    if (list.isEmpty) {
      return null;
    }
    return list.first;
  }

  Future<List<Object?>?> getDocsWhereAndWhereForDate<t extends TopModel>({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required DateTime startDateFieldValue,
    required String endDateField,
    required DateTime endDateValue,
  }) async {
    QuerySnapshot<Object?> querydocs = (await queryWhereAndWhereForDate(
      reference: reference,
      firstField: firstField,
      firstValue: firstValue,
      startDateField: startDateField,
      secondField: secondField,
      secondValue: secondValue,
      startDateFieldValue: startDateFieldValue,
      endDateField: endDateField,
      endDateValue: endDateValue,
    ));
    List<Object?>? listDocs = [];
    for (var doc in querydocs.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

  Future<QueryDocumentSnapshot<Object?>?> getDocSnapShotWhereAndNotWhere({
    required CollectionReference collectionReference,
    required String field,
    dynamic value,
    required dynamic notValue,
    required String notField,
  }) async {
    QuerySnapshot querySnapshot = await queryWhereAndNotWhere(
        reference: collectionReference,
        field: field,
        value: value,
        notfield: notField,
        notvalue: notValue);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    if (list.isEmpty) {
      return null;
    }
    return list.first;
  }

  //جلب دوك واحد بشرطين
  Future<QueryDocumentSnapshot<Object?>> getDocSnapShotWhereAndWhere({
    required CollectionReference collectionReference,
    required String firstField,
    dynamic firstValue,
    required String secondField,
    dynamic secondValue,
  }) async {
    QuerySnapshot querySnapshot = await queryWhereAndWhere(
        reference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);
    List<QueryDocumentSnapshot<Object?>> list = querySnapshot.docs;
    return list.first;
  }

  Future<List<Object?>?> getAllListDataForRef({
    required CollectionReference refrence,
  }) async {
    QuerySnapshot<Object?> querySnapshot = await refrence.get();

    List<Object?>? listDocs = [];
    for (var doc in querySnapshot.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

  Stream<QuerySnapshot<Object?>> getAllListDataForRefStream({
    required CollectionReference refrence,
  }) {
    Query query = refrence;
    return query.snapshots();
  }

  Future<QuerySnapshot<Object?>> queryWhere({
    required CollectionReference reference,
    required dynamic value,
    required String field,
  }) async {
    Query query = reference.where(field, isEqualTo: value);
    return await query.get();
  }

  Future<QuerySnapshot<Object?>> queryWhereAndNotWhere({
    required CollectionReference reference,
    required dynamic value,
    required String field,
    required dynamic notvalue,
    required String notfield,
  }) async {
    Query query = reference
        .where(field, isEqualTo: value)
        .where(field, isNotEqualTo: value);
    return await query.get();
  }

  Stream<DocumentSnapshot> getDocWhereStream(
      {required CollectionReference collectionReference,
      required String field,
      dynamic value}) async* {
    DocumentSnapshot? doc = await getDocSnapShotWhere(
        collectionReference: collectionReference, field: field, value: value);
    yield* doc!.reference.snapshots();
  }

  Stream<QuerySnapshot<Object?>> queryWhereStream(
      {required CollectionReference reference,
      required dynamic value,
      required String field}) {
    Query query = reference.where(field, isEqualTo: value);
    return query.snapshots();
  }

  Future<List<Object?>?> getListDataWhere<t extends TopModel>({
    required CollectionReference collectionReference,
    required String field,
    dynamic value,
  }) async {
    QuerySnapshot<Object?> querydocs = await queryWhere(
      reference: collectionReference,
      field: field,
      value: value,
    );
    List<Object?>? listDocs = [];
    for (var doc in querydocs.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

  Stream<QuerySnapshot<Object?>> queryWhereForDateStream({
    required CollectionReference reference,
    required String field,
    required dynamic value,
    required String startDateField,
    required dynamic startDateFieldValue,
    required String endDateField,
    required dynamic endDateValue,
  }) {
    Query query = reference
        .where(field, isEqualTo: value)
        .where(endDateField, isLessThanOrEqualTo: endDateValue)
        .where(startDateField, isGreaterThanOrEqualTo: startDateFieldValue);
    return query.snapshots();
  }

  Future<QuerySnapshot<Object?>> queryWhereAndWhereForDate({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateFieldValue,
    required String endDateField,
    required dynamic endDateValue,
  }) async {
    Query query = reference
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .where(endDateField, isLessThanOrEqualTo: endDateValue)
        .where(startDateField, isGreaterThanOrEqualTo: startDateFieldValue);
    return await query.get();
  }

  Stream<QuerySnapshot<Object?>> queryWhereAndWhereForDateStream({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateFieldValue,
    required String endDateField,
    required dynamic endDateValue,
  }) {
    Query query = reference
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .where(endDateField, isLessThanOrEqualTo: endDateValue)
        .where(startDateField, isGreaterThanOrEqualTo: startDateFieldValue);
    return query.snapshots();
  }

  Future<QuerySnapshot<Object?>> queryWhereForDate({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required dynamic startDateValue,
    required String endDateField,
    required dynamic endDateValue,
  }) async {
    Query query = reference
        .where(firstField, isEqualTo: firstValue)
        .where(startDateField, isGreaterThanOrEqualTo: startDateValue)
        .where(endDateField, isLessThanOrEqualTo: endDateValue);
    return await query.get();
  }

  Query whereDateLess({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = reference
        .where(firstField, isEqualTo: firstValue)
        .where(startDateField, isLessThanOrEqualTo: startDateValue);
    return query;
  }

  Future<QuerySnapshot<Object?>> queryWhereDateLess({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required dynamic startDateValue,
  }) async {
    Query query = whereDateLess(
      reference: reference,
      firstField: firstField,
      firstValue: firstValue,
      startDateField: startDateField,
      startDateValue: startDateValue,
    );
    return await query.get();
  }

  Stream<QuerySnapshot<Object?>> queryWhereDateLessStream({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = whereDateLess(
      reference: reference,
      firstField: firstField,
      firstValue: firstValue,
      startDateField: startDateField,
      startDateValue: startDateValue,
    );
    return query.snapshots();
  }

  Query whereDateGreat({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = reference
        .where(firstField, isEqualTo: firstValue)
        .where(startDateField, isGreaterThanOrEqualTo: startDateValue);
    return query;
  }

  Future<QuerySnapshot<Object?>> queryWhereDateGreat({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required dynamic startDateValue,
  }) async {
    Query query = whereDateGreat(
      reference: reference,
      firstField: firstField,
      firstValue: firstValue,
      startDateField: startDateField,
      startDateValue: startDateValue,
    );
    return await query.get();
  }

  Stream<QuerySnapshot<Object?>> queryWhereDateGreatStream({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = whereDateGreat(
      reference: reference,
      firstField: firstField,
      firstValue: firstValue,
      startDateField: startDateField,
      startDateValue: startDateValue,
    );
    return query.snapshots();
  }

  Query whereAndWhereDateGreat({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = reference
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .where(startDateField, isGreaterThanOrEqualTo: startDateValue);
    return query;
  }

  Future<QuerySnapshot<Object?>> queryWhereAndWhereDateGreat({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateValue,
  }) async {
    Query query = whereAndWhereDateGreat(
        reference: reference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue,
        startDateField: startDateField,
        startDateValue: startDateValue);
    return await query.get();
  }

  Stream<QuerySnapshot<Object?>> queryWhereAndWhereDateGreatStream({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = whereAndWhereDateGreat(
        reference: reference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue,
        startDateField: startDateField,
        startDateValue: startDateValue);
    return query.snapshots();
  }

  Query whereAndWhereDateLess({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = reference
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .where(startDateField, isLessThanOrEqualTo: startDateValue);
    return query;
  }

  Future<QuerySnapshot<Object?>> queryWhereAndWhereDateLess({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateValue,
  }) async {
    Query query = whereAndWhereDateLess(
        reference: reference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue,
        startDateField: startDateField,
        startDateValue: startDateValue);
    return await query.get();
  }

  Stream<QuerySnapshot<Object?>> queryWhereAndWhereDateLessStream({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String secondField,
    required dynamic secondValue,
    required String startDateField,
    required dynamic startDateValue,
  }) {
    Query query = whereAndWhereDateLess(
        reference: reference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue,
        startDateField: startDateField,
        startDateValue: startDateValue);
    return query.snapshots();
  }

  Future<QuerySnapshot<Object?>> queryWhereAndWhere({
    required CollectionReference reference,
    required dynamic firstValue,
    required String firstField,
    required String secondField,
    required dynamic secondValue,
  }) async {
    Query query = reference;
    return await query
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .get();
  }

  Stream<QuerySnapshot<Object?>> queryWhereAndWhereStream({
    required CollectionReference reference,
    required dynamic firstValue,
    required String firstField,
    required String secondField,
    required dynamic secondValue,
  }) {
    Query query = reference;
    return query
        .where(firstField, isEqualTo: firstValue)
        .where(secondField, isEqualTo: secondValue)
        .snapshots();
  }

  //ستريم جلب دوك واحد بشرطين
  Stream<DocumentSnapshot<Object?>> getDocWhereAndWhereStream(
      {required CollectionReference collectionReference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) async* {
    DocumentSnapshot documentSnapshot = await getDocSnapShotWhereAndWhere(
        collectionReference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);
    yield* documentSnapshot.reference.snapshots();
  }

  Future<List<Object?>?> getListDataWhereAndWhere<t extends TopModel>(
      {required CollectionReference collectionReference,
      required String firstField,
      dynamic firstValue,
      required String secondField,
      dynamic secondValue}) async {
    QuerySnapshot<Object?> querydocs = await queryWhereAndWhere(
        reference: collectionReference,
        firstField: firstField,
        firstValue: firstValue,
        secondField: secondField,
        secondValue: secondValue);

    List<Object?>? listDocs = [];
    for (var doc in querydocs.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

  Future<List<Object?>?> getDocsWhereForDate<t extends TopModel>({
    required CollectionReference reference,
    required String firstField,
    required dynamic firstValue,
    required String startDateField,
    required DateTime startDateFieldValue,
    required String endDateField,
    required DateTime endDateValue,
  }) async {
    QuerySnapshot<Object?> querydocs = (await queryWhereForDate(
      reference: reference,
      firstField: firstField,
      firstValue: firstValue,
      startDateField: startDateField,
      startDateValue: startDateFieldValue,
      endDateField: endDateField,
      endDateValue: endDateValue,
    ));
    List<Object?>? listDocs = [];
    for (var doc in querydocs.docs) {
      listDocs.add(doc.data());
    }
    return listDocs;
  }

  Future<DocumentSnapshot<Object?>> getDocByModel(
      {required CollectionReference reference,
      required TopModel topModel}) async {
    return await reference.doc(topModel.id).get();
  }

  Future<DocumentSnapshot> getDocById(
      {required CollectionReference reference, required String id}) async {
    return await reference.doc(id).get();
  }

  Stream<DocumentSnapshot<Object?>> getDocByIdStream(
      {required CollectionReference reference, required String id}) {
    return reference.doc(id).snapshots();
  }

  Future<QueryDocumentSnapshot<Object?>>
      getDocSnapShotByNameInTow<t extends TopModel>({
    required CollectionReference reference,
    required String field,
    required String value,
    required String name,
  }) async {
    return await getDocSnapShotWhereAndWhere(
      collectionReference: reference,
      firstField: nameK,
      firstValue: name,
      secondField: field,
      secondValue: value,
    );
  }

  Stream<DocumentSnapshot<Object?>> getDocByNameInTowStream({
    required CollectionReference reference,
    required String field,
    required String value,
    required String name,
  }) {
    return getDocWhereAndWhereStream(
        collectionReference: reference,
        firstField: field,
        firstValue: value,
        secondField: nameK,
        secondValue: name);
  }

  Future<QueryDocumentSnapshot<Object?>?>
      getDocSnapShotByName<t extends TopModel>({
    required CollectionReference reference,
    required String name,
  }) async {
    return await getDocSnapShotWhere(
      collectionReference: reference,
      field: nameK,
      value: name,
    );
  }

  Stream<DocumentSnapshot<Object?>> getDocByNameStream({
    required CollectionReference reference,
    required String name,
  }) {
    return getDocWhereStream(
      collectionReference: reference,
      field: nameK,
      value: name,
    );
  }

  //اضافة دوكيومنت
  Future<void> addDoc(
      {required CollectionReference reference, required TopModel model}) async {
    await reference.doc(model.id).set(model);
  }

   void deleteDocUsingBatch(
      {required DocumentSnapshot? documentSnapshot,
      required WriteBatch refbatch}) {
    WriteBatch writeBatch = refbatch;
    if (documentSnapshot != null) {
      writeBatch.delete(documentSnapshot.reference);
    }
  }

  void deleteDocsUsingBatch(
      {required List<DocumentSnapshot?> list, required WriteBatch refBatch}) {
    final batch = refBatch;

    for (var doc in list) {
      if (doc != null) {
        batch.delete(doc.reference);
      }
    }
  }

  // Future<void> updateNonRelationalFields({
  //   required CollectionReference reference,
  //   required Map<String, dynamic> data,
  //   required String id,
  // }) async {
  //   DocumentSnapshot doc = await getDocById(reference: reference, id: id);
  //   if (data.containsKey(nameK)) {
  //     if (await existByTow(
  //           reference: reference,
  //           value: data[nameK],
  //           field: nameK,
  //           value2: id,
  //           field2: idK,
  //         ) &&
  //         data[nameK] != doc.get(nameK)) {}
  //   }

  //   if (data.containsKey(idK)) {
  //     Exception exception = Exception(
  //         "id cannot be updated ...this method only for Update Non-Relational fields");
  //     throw exception;
  //   }
  //   data['updatedAt'] = firebaseTime(DateTime.now());
  //   reference.doc(id).update(data);
  // }
  Future<void> updateRelationalFields({
    required CollectionReference reference,
    required Map<String, dynamic> data,
    required String id,
    required String fatherField,
    required String fatherValue,
    required Exception nameException,
  }) async {
    await updateFields(
        data: data,
        field: fatherField,
        haveFather: true,
        id: id,
        nameException: nameException,
        reference: reference,
        value: fatherValue);
  }

  Future<void> updateNonRelationalFields({
    required CollectionReference reference,
    required Map<String, dynamic> data,
    required String id,
    required Exception nameException,
  }) async {
    await updateFields(
      data: data,
      field: null,
      haveFather: false,
      id: id,
      nameException: nameException,
      reference: reference,
      value: null,
    );
  }

  Future<void> updateFields({
    required CollectionReference reference,
    required Map<String, dynamic> data,
    required String id,
    required String? field,
    required String? value,
    required bool haveFather,
    required Exception nameException,
  }) async {
    DocumentSnapshot doc = await getDocById(reference: reference, id: id);
    if (data.containsKey(nameK)) {
      if (haveFather) {
        if (await existByTow(
              reference: reference,
              value: data[nameK],
              field: nameK,
              value2: value,
              field2: field!,
            ) &&
            data[nameK] != doc.get(nameK)) {
          throw nameException;
        }
      }
      if (await existByOne(
            collectionReference: reference,
            value: data[nameK],
            field: nameK,
          ) &&
          data[nameK] != doc.get(nameK)) {
        throw nameException;
      }
    }
    if (data.containsKey("id")) {
      Exception exception = Exception(
          "id cannot be updated ...this method only for Update Non-Relational fields");
      throw exception;
    }
    data['updatedAt'] = firebaseTime(DateTime.now());
    reference.doc(id).update(data);
  }

  Future<bool> existByOne({
    required CollectionReference collectionReference,
    required dynamic value,
    required String field,
  }) async {
    Query query = collectionReference;
    AggregateQuerySnapshot querySnapshot =
        await query.where(field, isEqualTo: value).count().get();

    if (querySnapshot.count >= 1) {
      return true;
    }
    return false;
  }

  Future<bool> existByTow({
    required CollectionReference reference,
    required dynamic value,
    required String field,
    required dynamic value2,
    required String field2,
  }) async {
    Query query = reference;
    AggregateQuerySnapshot querySnapshot = await query
        .where(field, isEqualTo: value)
        .where(field2, isEqualTo: value2)
        .count()
        .get();
    if (querySnapshot.count >= 1) {
      return true;
    }
    return false;
    // return querySnapshot.count;
  }

  Future<bool> existInTowPlaces({
    required CollectionReference firstCollectionReference,
    required String firstFiled,
    dynamic firstvalue,
    required CollectionReference secondCollectionReference,
    required String secondFiled,
    dynamic secondValue,
  }) async {
    if (await existByOne(
            collectionReference: firstCollectionReference,
            field: firstFiled,
            value: firstvalue) &&
        await existByOne(
            collectionReference: secondCollectionReference,
            field: secondFiled,
            value: secondValue)) {
      return true;
    }
    return false;
  }
}
