import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/project_main_task_controller.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/controllers/waitingMamberController.dart';
import 'package:mytest/controllers/waitingSubTasks.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/models/team/waitingMamber.dart';
import 'package:mytest/models/team/waitingSubTasksModel.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/widgets/Profile/box.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';
import '../../Values/values.dart';
import '../../models/team/Project_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/Buttons/primary_tab_buttons.dart';
import '../../widgets/Forms/search_box.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/Navigation/dasboard_header.dart';
import '../../widgets/Search/active_task_card.dart';
import '../../widgets/Search/task_card.dart';
import '../../widgets/Shapes/app_settings_icon.dart';
import '../../widgets/dummy/profile_dummy.dart';
import '../Chat/chat_screen.dart';
import '../Profile/profile_overview.dart';
import 'DashboardTabScreens/boxController.dart';

class Invitions extends StatelessWidget {
  Invitions({Key? key}) : super(key: key);
  final BoxController boxController = Get.put(BoxController());
  @override
  Widget build(BuildContext context) {
    final settingsButtonTrigger = ValueNotifier(0);
    boxController.selectTab(0);
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: GetBuilder<BoxController>(
            init: BoxController(),
            builder: (controller) {
              return Column(children: [
                TaskezAppHeader(
                  title: "Invitations",
                  widget: GestureDetector(
                    onTap: () async {
                      bool fcmStutas =
                          await FcmNotifications.getNotificationStatus();
                      Get.to(() => ProfileOverview(
                            isSelected: fcmStutas,
                          ));
                    },
                    child: StreamBuilder<DocumentSnapshot<UserModel>>(
                        stream: UserController().getUserByIdStream(
                            id: AuthService
                                .instance.firebaseAuth.currentUser!.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text("Loading");
                          }
                          if (snapshot.hasData) {
                            return ProfileDummy(
                              imageType: ImageType.Network,
                              color: Colors.white,
                              dummyType: ProfileDummyType.Image,
                              image: snapshot.data!.data()!.imageUrl,
                              scale: 1.2,
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }),
                  ),
                ),
                AppSpaces.verticalSpace20,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //tab indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              PrimaryTabButton(
                                  callback: () {
                                    boxController.selectTab(0);
                                    settingsButtonTrigger.value =
                                        controller.selectedTabIndex.value;
                                    print("0");
                                  },
                                  buttonText: " Task In Box",
                                  itemIndex: 0,
                                  notifier: settingsButtonTrigger),
                              PrimaryTabButton(
                                  callback: () {
                                    boxController.selectTab(1);
                                    settingsButtonTrigger.value =
                                        controller.selectedTabIndex.value;
                                    print(1);
                                  },
                                  buttonText: "Join requests In Box",
                                  itemIndex: 1,
                                  notifier: settingsButtonTrigger),
                            ],
                          ),
                        ]),
                  ),
                ),
                AppSpaces.verticalSpace20,
                Expanded(
                  child: controller.selectedTabIndex.value == 0
                      ? StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                          stream: TeamMemberController()
                              .getMemberWhereUserIsStream(
                                  userId: AuthService
                                      .instance.firebaseAuth.currentUser!.uid),
                          builder: (context, snapshotMembersforUser) {
                            if (snapshotMembersforUser.hasError) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search_off,
                                    //   Icons.heart_broken_outlined,
                                    color: Colors.red,
                                    size: 120,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 40),
                                    child: Center(
                                      child: Text(
                                        "  ${snapshotMembersforUser.error}",
                                        style: GoogleFonts.fjallaOne(
                                          color: Colors.white,
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (!snapshotMembersforUser.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.search,
                                    //   Icons.heart_broken_outlined,
                                    color: Colors.lightBlue,
                                    size: 120,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 40),
                                    child: Center(
                                      child: Text(
                                        "Loading..",
                                        style: GoogleFonts.fjallaOne(
                                          color: Colors.white,
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (snapshotMembersforUser.hasData) {
                              if (snapshotMembersforUser.data!.docs.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //
                                    const Icon(
                                      Icons.search_off,
                                      //   Icons.heart_broken_outlined,
                                      color: Colors.red,
                                      size: 120,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 40),
                                      child: Center(
                                        child: Text(
                                          "You Are Not Member In Any Team yet",
                                          style: GoogleFonts.fjallaOne(
                                            color: Colors.white,
                                            fontSize: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              List<String> membersId = <String>[];
                              List<TeamMemberModel> listMembers =
                                  snapshotMembersforUser.data!.docs
                                      .map((doc) => doc.data())
                                      .toList();
                              for (var member in listMembers) {
                                membersId.add(member.id);
                              }
                              if (snapshotMembersforUser.hasData) {
                                return StreamBuilder<
                                        QuerySnapshot<WaitingSubTaskModel>>(
                                    stream: WatingSubTasksController()
                                        .getWaitingSubTasksInMembersId(
                                            membersId: membersId),
                                    builder:
                                        (context, snapshotOfWaitngSubTasks) {
                                      if (snapshotOfWaitngSubTasks.hasError) {
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 40),
                                              child: Center(
                                                child: Text(
                                                  snapshotOfWaitngSubTasks.error
                                                      .toString(),
                                                  style: GoogleFonts.fjallaOne(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      if (snapshotOfWaitngSubTasks.hasData) {
                                        List<WaitingSubTaskModel>
                                            listWaitingSubTasks =
                                            snapshotOfWaitngSubTasks.data!.docs
                                                .map((doc) => doc.data())
                                                .toList();
                                        if (snapshotOfWaitngSubTasks
                                            .data!.docs.isEmpty) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.search_off,
                                                //   Icons.heart_broken_outlined,
                                                color: Colors.red,
                                                size: 120,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50,
                                                        vertical: 40),
                                                child: Center(
                                                  child: Text(
                                                    "No Invitions for Tasks ",
                                                    style:
                                                        GoogleFonts.fjallaOne(
                                                      color: Colors.white,
                                                      fontSize: 40,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                        return ListView.builder(
                                          itemCount: snapshotOfWaitngSubTasks
                                              .data!.size,
                                          itemBuilder: (context, index) =>
                                              StreamBuilder<
                                                      DocumentSnapshot<
                                                          ProjectModel>>(
                                                  stream: ProjectController()
                                                      .getProjectByIdStream(
                                                          id: listWaitingSubTasks[
                                                                  index]
                                                              .projectSubTaskModel
                                                              .projectId),
                                                  builder: (context,
                                                      snapshotOfProjectMainTask) {
                                                    ProjectModel? projectModel =
                                                        snapshotOfProjectMainTask
                                                            .data!
                                                            .data();
                                                    return Column(children: [
                                                      ActiveTaskCard(
                                                          onPressedEnd:
                                                              (p0) async {
                                                            try {
                                                              showDialogMethod(
                                                                  context);
                                                              await WatingSubTasksController().rejectSubTask(
                                                                  waitingSubTaskId:
                                                                      listWaitingSubTasks[
                                                                              index]
                                                                          .id,
                                                                  rejectingMessage:
                                                                      "rejectingMessage");
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } on Exception catch (e) {
                                                              CustomSnackBar
                                                                  .showError(e
                                                                      .toString());
                                                            }
                                                          },
                                                          onPressedStart:
                                                              (p0) async {
                                                            try {
                                                              showDialogMethod(
                                                                  context);
                                                              await WatingSubTasksController()
                                                                  .accpetSubTask(
                                                                waitingSubTaskId:
                                                                    listWaitingSubTasks[
                                                                            index]
                                                                        .id,
                                                              );
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } on Exception catch (e) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              CustomSnackBar
                                                                  .showError(e
                                                                      .toString());
                                                            }
                                                          },
                                                          imageUrl:
                                                              projectModel!
                                                                  .imageUrl,
                                                          header: "Team Name",
                                                          subHeader:
                                                              "Manager Team Name",
                                                          date:
                                                              " ${formatFromDate(dateTime: DateTime.now(), fromat: "MMM")}  ${DateTime.now().day}"),
                                                      AppSpaces.verticalSpace10
                                                    ]);
                                                  }),
                                        );
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    });
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          })
                      //: Container(),
                      : StreamBuilder<QuerySnapshot<WaitingMemberModel>>(
                          stream: WaitingMamberController()
                              .getWaitingMembersInUserIdStream(
                                  userId: AuthService
                                      .instance.firebaseAuth.currentUser!.uid),
                          builder: (context, snapshotOfWaithingMembers) {
                            if (!snapshotOfWaithingMembers.hasData) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //
                                  const Icon(
                                    Icons.search_off,
                                    //   Icons.heart_broken_outlined,
                                    color: Colors.lightBlue,
                                    size: 120,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 40),
                                    child: Center(
                                      child: Text(
                                        "Loading..",
                                        style: GoogleFonts.fjallaOne(
                                          color: Colors.white,
                                          fontSize: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (snapshotOfWaithingMembers.hasData) {
                              List<WaitingMemberModel> listWaitingMembers =
                                  snapshotOfWaithingMembers.data!.docs
                                      .map((doc) => doc.data())
                                      .toList();
                              if (snapshotOfWaithingMembers
                                  .data!.docs.isEmpty) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //
                                    const Icon(
                                      Icons.search_off,
                                      //   Icons.heart_broken_outlined,
                                      color: Colors.red,
                                      size: 120,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 40),
                                      child: Center(
                                        child: Text(
                                          "There Is No Invitation",
                                          style: GoogleFonts.fjallaOne(
                                            color: Colors.white,
                                            fontSize: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return ListView.builder(
                                itemCount: snapshotOfWaithingMembers.data!.size,
                                itemBuilder: (context, index) => StreamBuilder<
                                        DocumentSnapshot<TeamModel>>(
                                    stream: TeamController().getTeamByIdStream(
                                        id: listWaitingMembers[index].teamId),
                                    builder: (context, snapshotTeam) {
                                      if (!snapshotTeam.hasData) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //
                                            const Icon(
                                              Icons.search,
                                              //   Icons.heart_broken_outlined,
                                              color: Colors.lightBlue,
                                              size: 120,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50,
                                                      vertical: 40),
                                              child: Center(
                                                child: Text(
                                                  "loading..",
                                                  style: GoogleFonts.fjallaOne(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      if (snapshotTeam.hasData) {
                                        TeamModel teamModel =
                                            snapshotTeam.data!.data()!;
                                        return StreamBuilder<
                                                DocumentSnapshot<UserModel>>(
                                            stream: UserController()
                                                .getUserWhereMangerIsStream(
                                                    mangerId: snapshotTeam.data!
                                                        .data()!
                                                        .managerId),
                                            builder: (context, snapshotOfUser) {
                                              if (!snapshotOfUser.hasData) {
                                                return Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    //
                                                    const Icon(
                                                      Icons.search,
                                                      //   Icons.heart_broken_outlined,
                                                      color: Colors.lightBlue,
                                                      size: 120,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50,
                                                          vertical: 40),
                                                      child: Center(
                                                        child: Text(
                                                          "loading...",
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
                                              UserModel? userModel =
                                                  snapshotOfUser.data!.data();
                                              return Column(children: [
                                                ActiveTaskCard(
                                                    onPressedEnd: (p0) async {
                                                      showDialogMethod(context);
                                                      await WaitingMamberController()
                                                          .declineTeamInvite(
                                                              rejectingMessage:
                                                                  "i dont like it",
                                                              waitingMemberId:
                                                                  listWaitingMembers[
                                                                          index]
                                                                      .id);
                                                      Get.key.currentState!
                                                          .pop();
                                                      print("end");
                                                    },
                                                    onPressedStart: (p0) async {
                                                      showDialogMethod(context);
                                                      await WaitingMamberController()
                                                          .acceptTeamInvite(
                                                              waitingMemberId:
                                                                  listWaitingMembers[
                                                                          index]
                                                                      .id);
                                                      // Navigator.of(context)
                                                      //     .pop();
                                                      print("start");
                                                    },
                                                    header: teamModel.name!,
                                                    //  header: "Team Name",
                                                    subHeader:
                                                        "Manager:  ${userModel!.name!}",
                                                    //subHeader: "Manager Team Name",
                                                    imageUrl:
                                                        teamModel.imageUrl,
                                                    date:
                                                        " ${formatFromDate(dateTime: listWaitingMembers[index].createdAt, fromat: "MMM")}  ${listWaitingMembers[index].createdAt.day}"),
                                                //   " ${formatFromDate(dateTime: DateTime.now(), fromat: "MMM")}  ${DateTime.now().day}"),
                                                AppSpaces.verticalSpace10
                                              ]);
                                            });
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                )
              ]);
            },
          ),
        ));
  }
}

String formatFromDate({required DateTime dateTime, required String fromat}) {
  return DateFormat(fromat).format(dateTime);
}
