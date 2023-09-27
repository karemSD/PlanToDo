import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/models/statusmodel.dart';
import 'package:mytest/services/collectionsrefrences.dart';

import '../constants/back_constants.dart';

class StatusController extends TopController {
  Future<List<StatusModel>> getAllStatuses() async {
    List<Object?>? list = await getAllListDataForRef(refrence: statusesRef);
    return list!.cast<StatusModel>();
  }
  Future<StatusModel> getStatusById({required String statusId}) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: idK,
      value: statusId,
    );
    return documentSnapshot!.data() as StatusModel;
  }
  Stream<DocumentSnapshot<StatusModel>> getStatusByIdStream(
      {required String idk}) {
    Stream<DocumentSnapshot<Object?>> statusDoc = getDocWhereStream(
        collectionReference: statusesRef, field: idK, value: idk);
    return statusDoc.cast<DocumentSnapshot<StatusModel>>();
  }

  Future<StatusModel> getStatusByName({required String status}) async {
    DocumentSnapshot? documentSnapshot = await getDocSnapShotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: status,
    );
    return documentSnapshot!.data() as StatusModel;
  }

  Future<void> addStatus(StatusModel statusModel) async {
    Exception exception;
    bool exist = await existByOne(
        collectionReference: statusesRef,
        value: statusModel.name,
        field: nameK);
    if (exist) {
      throw exception = Exception(AppConstants.status_name_already_added_key.tr);
    }
    await addDoc(model: statusModel, reference: statusesRef);
  }

  Future<void> deleteStatus(String id) async {
    DocumentSnapshot documentSnapshot =
        await getDocById(reference: statusesRef, id: id);
    WriteBatch batch = fireStore.batch();
    deleteDocUsingBatch(documentSnapshot: documentSnapshot, refbatch: batch);
    batch.commit();
  }

  Future<void> updateStatus(StatusModel statusModel) async {
    Exception exception;
    DocumentSnapshot? snapshot = await getDocSnapShotWhereAndNotWhere(
      collectionReference: statusesRef,
      field: nameK,
      value: statusModel.name,
      notField: idK,
      notValue: statusModel.id,
    );
    if (snapshot == null) {
      await addDoc(model: statusModel, reference: statusesRef);
      return;
    } else {
      exception = Exception(AppConstants.status_name_already_added_key.tr);
      throw exception;
    }
  }

  Future<void> updateStatus2(
      {required id, required Map<String, dynamic> data}) async {
    Exception exception;
    if (data.containsKey(id)) {
      exception = Exception(AppConstants.status_id_update_error_key.tr);
      throw exception;
    }
    await updateNonRelationalFields(
        reference: teamMembersRef,
        data: data,
        id: id,
        nameException: Exception(AppConstants.status_already_added_key.tr));
  }
}
