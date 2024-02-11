import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/widgets/Forms/search_box2.dart';

import 'package:mytest/widgets/inactive_employee_card.dart';

import '../../Screens/Dashboard/search_bar_animation.dart';
import '../../Screens/Profile/profile_overview.dart';
import '../../Values/values.dart';

import '../../models/User/User_task_Model.dart';
import '../../models/team/TeamMembers_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';

import '../../widgets/Navigation/app_header.dart';

import '../../widgets/dummy/profile_dummy.dart';
import '../Buttons/primary_progress_button.dart';
import '../Navigation/app_header2.dart';
import '../User/employee_card_sub_task.dart';

// class Search extends GetxController {
//   final selectedUser = Rx<UserModel?>(null);
//   updateSelectedUser(UserModel user) {
//     selectedUser.value = user;
//   }
// }

class SearchForMembersSubTask extends StatefulWidget {
  final UserModel? userModel;
  final TeamModel? teamModel;
  final Function({required UserModel? userModel}) onSelectedUserChanged;

  SearchForMembersSubTask({
    required this.userModel,
    Key? key,
    this.teamModel,
    required this.onSelectedUserChanged,
  }) : super(key: key);

  @override
  State<SearchForMembersSubTask> createState() =>
      _SearchForMembersSubTaskState();
}

class _SearchForMembersSubTaskState extends State<SearchForMembersSubTask> {
  static String search = "";

  final searchController = TextEditingController();
  final ValueNotifier<UserModel?> selectedUserNotifier =
      ValueNotifier<UserModel?>(null);
  // Search s = Get.put(Search());

  @override
  void initState() {
    if (widget.userModel != null) {
      print(widget.userModel!.userName);
      selectedUserNotifier.value = widget.userModel;
      print(selectedUserNotifier.value!.userName);
      // s.selectedUser.value = widget.userModel;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: Utils.screenWidth * 0.04,
                    left: Utils.screenWidth * 0.04),
                child: SafeArea(
                  child: TaskezAppHeader(
                    title: AppConstants.search_members_key.tr,
                    widget: MySearchBarWidget(
                      searchWord: AppConstants.members_key.tr,
                      editingController: searchController,
                      onChanged: (String value) {
                        setState(() {
                          print(search);
                          search = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              AppSpaces.verticalSpace40,
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecorationStyles.fadingGlory,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: DecoratedBox(
                      decoration: BoxDecorationStyles.fadingInnerDecor,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSpaces.verticalSpace20,
                            Expanded(
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: StreamBuilder<
                                    QuerySnapshot<TeamMemberModel>>(
                                  stream: TeamMemberController()
                                      .getMembersInTeamIdStream(
                                    teamId: widget.teamModel!.id,
                                  ),
                                  builder: (context, snapshotMembers) {
                                    if (snapshotMembers.hasData) {
                                      List<String> listIds = [];
                                      List<
                                              QueryDocumentSnapshot<
                                                  TeamMemberModel>> list =
                                          snapshotMembers.data!.docs;
                                      list.forEach((element) {
                                        listIds.add(element.data().userId);
                                      });
                                      if (listIds.isEmpty) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //
                                            Icon(
                                              Icons.search_off,
                                              //   Icons.heart_broken_outlined,
                                              color: Colors.red,
                                              size: Utils.screenWidth * 0.27,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: Utils.screenWidth *
                                                    0.1, // Adjust the percentage as needed
                                                vertical:
                                                    Utils.screenHeight * 0.03,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  AppConstants
                                                      .no_members_found_for_team_on_project_key
                                                      .tr,
                                                  style: GoogleFonts.fjallaOne(
                                                    color: Colors.white,
                                                    fontSize:
                                                        Utils.screenWidth *
                                                            0.09,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return StreamBuilder<
                                          QuerySnapshot<UserModel>>(
                                        stream: UserController()
                                            .getUsersWhereInIdsStream(
                                          usersId: listIds,
                                        ),
                                        builder: (context, snapshotUsers) {
                                          if (snapshotUsers.hasData) {
                                            int taskCount =
                                                snapshotUsers.data!.docs.length;
                                            List<UserModel> users = [];
                                            if (taskCount > 0) {
                                              if (search.isNotEmpty) {
                                                print(search + "helli");
                                                snapshotUsers.data!.docs
                                                    .forEach((element) {
                                                  UserModel taskModel =
                                                      element.data();
                                                  if (taskModel.userName!
                                                      .toLowerCase()
                                                      .contains(search)) {
                                                    users.add(taskModel);
                                                  }
                                                });
                                              } else {
                                                snapshotUsers.data!.docs
                                                    .forEach((element) {
                                                  UserModel taskCategoryModel =
                                                      element.data();

                                                  users.add(taskCategoryModel);
                                                });
                                              }
                                              selectedUserNotifier.value ??=
                                                  users.first;
                                            }
                                            return ValueListenableBuilder(
                                                valueListenable:
                                                    selectedUserNotifier,
                                                builder: (context, value, _) {
                                                  return ListView.separated(
                                                    padding: EdgeInsets.only(
                                                        bottom: 20),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          selectedUserNotifier
                                                                  .value =
                                                              users[index];
                                                        },
                                                        child:
                                                            EmployeeCardSubTask(
                                                          activated:
                                                              selectedUserNotifier
                                                                      .value!
                                                                      .id ==
                                                                  users[index]
                                                                      .id,
                                                          backgroundColor:
                                                              Colors.white,
                                                          Image: users[index]
                                                              .imageUrl,
                                                          Name: users[index]
                                                                  .userName ??
                                                              "",
                                                          bio: users[index]
                                                                  .bio ??
                                                              "",
                                                        ),
                                                      );
                                                    },
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return SizedBox(
                                                        height: 10,
                                                      );
                                                    },
                                                    itemCount: users.length,
                                                  );
                                                });
                                          }
                                          if (snapshotUsers.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: AppColors
                                                    .lightMauveBackgroundColor,
                                                backgroundColor: AppColors
                                                    .primaryBackgroundColor,
                                              ),
                                            );
                                          }

                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //
                                              Icon(
                                                Icons.search_off,
                                                //   Icons.heart_broken_outlined,
                                                color: Colors.red,
                                                size: Utils.screenWidth * 0.27,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: Utils
                                                          .screenWidth *
                                                      0.1, // Adjust the percentage as needed
                                                  vertical:
                                                      Utils.screenHeight * 0.05,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    AppConstants
                                                        .no_members_found_for_team_on_project_key
                                                        .tr,
                                                    style:
                                                        GoogleFonts.fjallaOne(
                                                      color: Colors.white,
                                                      fontSize:
                                                          Utils.screenWidth *
                                                              0.1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    if (snapshotMembers.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors
                                              .lightMauveBackgroundColor,
                                          backgroundColor:
                                              AppColors.primaryBackgroundColor,
                                        ),
                                      );
                                    }
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        //
                                        Icon(
                                          Icons.search_off,
                                          //   Icons.heart_broken_outlined,
                                          color: Colors.red,
                                          size: Utils.screenWidth * 0.27,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Utils.screenWidth *
                                                0.1, // Adjust the percentage as needed
                                            vertical: Utils.screenHeight * 0.05,
                                          ),
                                          child: Center(
                                            child: Text(
                                              AppConstants
                                                  .no_members_found_for_team_on_project_key
                                                  .tr,
                                              style: GoogleFonts.fjallaOne(
                                                color: Colors.white,
                                                fontSize:
                                                    Utils.screenWidth * 0.1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AppSpaces.verticalSpace10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      AppConstants.cancel_key.tr,
                      style: GoogleFonts.lato(
                        color: HexColor.fromHex("F49189"),
                        fontSize: Utils.screenWidth * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PrimaryProgressButton(
                    width: Utils.screenWidth * 0.25,
                    height: Utils.screenHeight2 * 0.07,
                    label: AppConstants.done_key.tr,
                    callback: () {
                      print(selectedUserNotifier.value!.name);
                      if (selectedUserNotifier.value != null) {
                        widget.onSelectedUserChanged(
                            userModel: selectedUserNotifier.value!);
                      }
                      Get.back();
                    },
                  )
                ],
              ),
              AppSpaces.verticalSpace10,
            ],
          ),
        ],
      ),
    );
  }
}
