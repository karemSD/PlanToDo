import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytest/models/team/Project_sub_task_Model.dart';
import 'package:mytest/models/tops/TopModel_model.dart';

import '../../constants/back_constants.dart';

class WaitingSubTaskModel with TopModel {
  WaitingSubTaskModel({
    required createdAt,
    required updatedAt,
    required id,
    this.reasonOfRefuse,
    required this.projectSubTaskModel,
  }) {
    setId = id;
    setCreatedAt = createdAt;
    setUpdatedAt = updatedAt;
  }
  String? reasonOfRefuse;
  late ProjectSubTaskModel projectSubTaskModel;
  @override
  set setCreatedAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  @override
  set setId(String id) {
    this.id = id;
  }

  @override
  set setUpdatedAt(DateTime updatedAt) {
    this.updatedAt = updatedAt;
  }

//لاخذ البيانات القادمة من الداتا بيز بشكل جيسون وتحويلها بشكل فوري إلى مودل
  factory WaitingSubTaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    Map<String, dynamic>? data = snapshot.data()!;
    return WaitingSubTaskModel(
      //projectSubTaskModel: data['subTask'],
      projectSubTaskModel: ProjectSubTaskModel.fromJson(data['subTask']),
      id: data[idK],
      createdAt: data[createdAtK].toDate(),
      updatedAt: data[updatedAtK].toDate(),
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subTask'] = projectSubTaskModel.toFirestore();
    data[idK] = id;
    data[createdAtK] = createdAt;
    data[updatedAtK] = updatedAt;
    return data;
  }
}
