// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Profile/team_details.dart';
import 'package:mytest/Screens/Projects/searchForMembers.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/controllers/waitingMamberController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/models/team/waitingMamber.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';
import 'package:mytest/widgets/active_employee_card.dart';
import 'package:mytest/widgets/inactive_employee_card.dart';
import '../../Data/data_model.dart';
import '../../Screens/Profile/profile_overview.dart';
import '../../Screens/Profile/team_details2.dart';
import '../../Values/values.dart';
import '../../controllers/teamController.dart';
import '../../models/team/Project_model.dart';
import '../../models/team/TeamMembers_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/Buttons/primary_buttons.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';

import '../../widgets/Navigation/app_header.dart';

import '../Dashboard/common_main_tasks.dart';
import '../dummy/profile_dummy.dart';

class ShowTeamMembers extends StatelessWidget {
  final TeamModel teamModel;
  final ManagerModel? userAsManager;
  const ShowTeamMembers({
    required this.userAsManager,
    required this.teamModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final dynamic data = AppData.employeeData;
    // List<Widget> cards = List.generate(
    //   AppData.employeeData.length,
    //   (index) => Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
    //     child: InactiveEmployeeCard(
    //       onTap: null,
    //       userImage: data[index]['userImage'],
    //       userName: data[index]['userName'],
    //       color: null,
    //       bio: data[index]["bio"],
    //     ),
    //   ),
    // );
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(right: 20, left: 20),
              child: TaskezAppHeader(
                title: "The Memebers",
                widget: GestureDetector(
                  onTap: () async {
                    // bool fcmStutas =
                    //     await FcmNotifications.getNotificationStatus();
                    // Get.to(() => ProfileOverview(
                    //       isSelected: fcmStutas,
                    //     ));
                  },
                  child: FutureBuilder<UserModel>(
                      future: UserController()
                          .getUserWhereMangerIs(mangerId: teamModel.managerId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        return ProfileDummy(
                          imageType: ImageType.Network,
                          color: Colors.white,
                          dummyType: ProfileDummyType.Image,
                          image: snapshot.data!.imageUrl,
                          scale: 1.2,
                        );
                      }),
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
                                child:
                                    StreamBuilder<
                                            QuerySnapshot<TeamMemberModel>>(
                                        stream: TeamMemberController()
                                            .getMembersInTeamIdStream(
                                                teamId: teamModel.id),
                                        builder:
                                            (context, snapshotTeamMembers) {
                                          List<String> usersId = [];
                                          if (snapshotTeamMembers
                                                  .connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }

                                          if (snapshotTeamMembers.hasError) {
                                            return Center(
                                              child: Text(
                                                  snapshotTeamMembers.error
                                                      .toString(),
                                                  style: TextStyle(
                                                      backgroundColor:
                                                          Colors.red)),
                                            );
                                          }
                                          for (var member in snapshotTeamMembers
                                              .data!.docs) {
                                            usersId.add(member.data().userId);
                                          }
                                          return StreamBuilder<
                                              QuerySnapshot<
                                                  WaitingMemberModel>>(
                                            stream: WaitingMamberController()
                                                .getWaitingMembersInTeamIdStream(
                                                    teamId: teamModel.id),
                                            builder:
                                                (context, snapShotWatingUsers) {
                                              if (snapShotWatingUsers
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              }

                                              if (snapShotWatingUsers.hasData) {
                                                for (var member
                                                    in snapShotWatingUsers
                                                        .data!.docs) {
                                                  usersId.add(
                                                      member.data().userId);
                                                }
                                              }
                                              if (usersId.isEmpty) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
//
                                                    const Icon(
                                                      Icons.search_off,
                                                      //   Icons.heart_broken_outlined,
                                                      color: Colors.red,
                                                      size: 120,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50,
                                                          vertical: 40),
                                                      child: Center(
                                                        child: Text(
                                                          "No Any Members yet",
                                                          style: GoogleFonts
                                                              .fjallaOne(
                                                            color: Colors.white,
                                                            fontSize: 40,
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
                                                          usersId: usersId),
                                                  builder:
                                                      (context, snapshotUsers) {
                                                    if (snapshotUsers
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return CircularProgressIndicator();
                                                    }
                                                    return ListView.builder(
                                                      itemCount: snapshotUsers
                                                          .data!.size,
                                                      itemBuilder:
                                                          (context, index) {
                                                        print(snapshotUsers
                                                            .data!.size);
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 3,
                                                                  vertical: 6),
                                                          child: Slidable(
                                                            endActionPane: userAsManager !=
                                                                        null &&
                                                                    teamModel
                                                                            .managerId ==
                                                                        userAsManager
                                                                            ?.id
                                                                ? index <
                                                                        snapshotTeamMembers
                                                                            .data!
                                                                            .size
                                                                    ? ActionPane(
                                                                        motion:
                                                                            StretchMotion(),
                                                                        children: [
                                                                            SlidableAction(
                                                                              backgroundColor: Colors.red,
                                                                              borderRadius: BorderRadius.circular(16),
                                                                              onPressed: (context) {
                                                                                print("object deete");
                                                                                CustomDialog.showConfirmDeleteDialog(
                                                                                    onDelete: () async {
                                                                                      print("delete member");
                                                                                      await TeamMemberController().deleteMember(id: snapshotTeamMembers.data!.docs[index].data().id);
                                                                                      Get.back();
                                                                                    },
                                                                                    content: Text("Are You sure ro Delete the member ${snapshotUsers.data!.docs[index].data().name} from this Team ?"));
                                                                              },
                                                                              label: 'Delete',
                                                                              icon: FontAwesomeIcons.trash,
                                                                            ),
                                                                          ])
                                                                    : ActionPane(
                                                                        motion:
                                                                            StretchMotion(),
                                                                        children: [
                                                                            SlidableAction(
                                                                              backgroundColor: Colors.red,
                                                                              borderRadius: BorderRadius.circular(16),
                                                                              onPressed: (context) async {
                                                                                showDialogMethod(context);
                                                                                await WaitingMamberController().deleteWaitingMamberDoc(waitingMemberId: snapShotWatingUsers.data!.docs[index].data().id);
                                                                                Get.key.currentState!.pop();
                                                                                print("object dlete waitiing member");
                                                                              },
                                                                              label: 'Delete',
                                                                              icon: FontAwesomeIcons.trash,
                                                                            ),
                                                                          ])
                                                                : null,
                                                            startActionPane: index <
                                                                    snapshotTeamMembers
                                                                        .data!
                                                                        .size
                                                                ? userAsManager !=
                                                                            null &&
                                                                        teamModel.managerId ==
                                                                            userAsManager
                                                                                ?.id
                                                                    ? ActionPane(
                                                                        motion:
                                                                            const ScrollMotion(),
                                                                        children: [
                                                                            SlidableAction(
                                                                              borderRadius: BorderRadius.circular(16),
                                                                              backgroundColor: Colors.blueAccent,
                                                                              onPressed: (context) {
                                                                                TeamMemberModel teamMemberModel = snapshotTeamMembers.data!.docs[index].data();
                                                                                Get.to(TeamDetails2(
                                                                                  me: null,
                                                                                  partner: teamMemberModel.id,
                                                                                  team: teamModel,
                                                                                  title: "",
                                                                                  userAsManager: userAsManager,
                                                                                ));

                                                                                print("see tasks as manager");
                                                                              },
                                                                              label: "Tasks",
                                                                              icon: FontAwesomeIcons.listCheck,
                                                                            ),
                                                                          ])
                                                                    : ActionPane(
                                                                        motion:
                                                                            const ScrollMotion(),
                                                                        children: [
                                                                            SlidableAction(
                                                                              borderRadius: BorderRadius.circular(16),
                                                                              backgroundColor: Colors.blueAccent,
                                                                              onPressed: (context) async {
                                                                                TeamMemberModel teamMemberModel = snapshotTeamMembers.data!.docs[index].data();
                                                                                TeamMemberModel me = await TeamMemberController().getMemberByTeamIdAndUserId(teamId: teamModel.id, userId: AuthService.instance.firebaseAuth.currentUser!.uid);
                                                                                Get.to(TeamDetails2(
                                                                                  me: me.id,
                                                                                  partner: teamMemberModel.id,
                                                                                  team: teamModel,
                                                                                  title: "",
                                                                                  userAsManager: userAsManager,
                                                                                ));
                                                                                print("see tasks as parnter in main tasks");
                                                                              },
                                                                              label: "Tasks",
                                                                              icon: FontAwesomeIcons.listCheck,
                                                                            ),
                                                                          ])
                                                                : null,
                                                            child: index <
                                                                    snapshotTeamMembers
                                                                        .data!
                                                                        .size
                                                                ? ActiveEmployeeCard(
                                                                    notifier:
                                                                        null,
                                                                    userImage: snapshotUsers
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()
                                                                        .imageUrl,
                                                                    userName: snapshotUsers
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()
                                                                        .name!,
                                                                    color: null,
                                                                    bio: snapshotUsers
                                                                            .data!
                                                                            .docs[index]
                                                                            .data()
                                                                            .bio ??
                                                                        " ",
                                                                  )
                                                                : Visibility(
                                                                    visible: userAsManager !=
                                                                            null &&
                                                                        teamModel.managerId ==
                                                                            userAsManager?.id,
                                                                    child:
                                                                        InactiveEmployeeCard(
                                                                      onTap:
                                                                          null,
                                                                      userName: snapshotUsers
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()
                                                                          .name!,
                                                                      color:
                                                                          null,
                                                                      userImage: snapshotUsers
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()
                                                                          .imageUrl,
                                                                      bio: snapshotUsers
                                                                              .data!
                                                                              .docs[index]
                                                                              .data()
                                                                              .bio ??
                                                                          "",
                                                                    ),
                                                                  ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  });
                                            },
                                          );
                                        }),
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ),
            //AppSpaces.verticalSpace20,
            Visibility(
              visible: userAsManager != null &&
                  teamModel.managerId == userAsManager?.id,
              child: AppPrimaryButton(
                  buttonHeight: 50,
                  buttonWidth: 150,
                  buttonText: "Add Member",
                  callback: () {
                    Get.to(
                      () => SearchForMembers(
                        teamModel: teamModel,
                        users: null,
                        newTeam: false,
                      ),
                    );
                  }),
            ),
            AppSpaces.verticalSpace20,
          ]),
        ),
      ]),
    );
  }

  void GoToCommon(String projectId, bool isManager) {}
}
