import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/User/User_model.dart';

class SearchForMembersController extends GetxController {
  final searchController = TextEditingController();
  RxString searchQuery = ''.obs;
  // RxList<UserModel> users = <UserModel>[].obs;
  // RxList<UserModel> filteredUsers = <UserModel>[].obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // searchQuery.listen((query) {
  //   //   filterUsers(query);
  //   // });
  // }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // void filterUsers(String query) {
  //   if (users.isEmpty) return;

  //   filteredUsers.value = users
  //       .where((user) =>
  //           user.userName?.toLowerCase().contains(query.toLowerCase()) ?? false)
  //       .toList();
  // }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    update();
  }
}
