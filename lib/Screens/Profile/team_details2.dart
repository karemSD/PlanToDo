// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Project_model.dart';
import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/widgets/Dashboard/common_main_tasks.dart';

import 'package:mytest/widgets/Team/show_team_members.dart';

import '../../BottomSheets/bottom_sheets.dart';

import '../../Values/values.dart';
import '../../constants/constants.dart';
import '../../controllers/manger_controller.dart';
import '../../controllers/statusController.dart';
import '../../controllers/teamController.dart';
import '../../models/statusmodel.dart';

import '../../services/auth_service.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Dashboard/in_bottomsheet_subtitle.dart';
import '../../widgets/Dashboard/main_tasks.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/Projects/project_card_vertical.dart';
import '../../widgets/Snackbar/custom_snackber.dart';
import '../../widgets/Team/more_team_details_sheet.dart';
import '../../widgets/User/focused_menu_item.dart';
import '../../widgets/table_calendar.dart';
import '../Projects/editProject.dart';
import 'my_team.dart';

class TeamDetails2 extends StatelessWidget {
  final String title;
  TeamModel? team;
  final String? me;
  final String partner;
  TeamDetails2(
      {Key? key,
      required this.title,
      required this.team,
      required this.userAsManager,
      required this.me,
      required this.partner})
      : super(key: key);
  final ManagerModel? userAsManager;

  @override
  Widget build(BuildContext context) {
    final settingsButtonTrigger = ValueNotifier(0);

    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SafeArea(
            child: StreamBuilder<DocumentSnapshot<TeamModel>>(
                stream: TeamController().getTeamByIdStream(id: team!.id),
                builder: (context, snapshotTeam) {
                  if (snapshotTeam.hasError) {
                    return Center(
                      child: Text(
                        snapshotTeam.error.toString(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    );
                  }
                  if (snapshotTeam.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshotTeam.hasData) {
                    team = snapshotTeam.data!.data()!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskezAppHeader(
                          title: "$tabSpace Details Team",
                          widget: Visibility(
                            visible: userAsManager != null &&
                                team!.managerId == userAsManager!.id,
                            child: InkWell(
                              onTap: () {
                                showAppBottomSheet(
                                  Padding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    child: SizedBox(
                                        height: Utils.screenHeight * 0.9,
                                        child: MoreTeamDetailsSheet(
                                          userAsManager: userAsManager,
                                          teamModel: team!,
                                        )),
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: const Icon(Icons.more_horiz,
                                  size: 30, color: Colors.white),
                            ),
                          ),
                        ),
                        AppSpaces.verticalSpace40,
                        StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                            stream: TeamMemberController()
                                .getMembersInTeamIdStream(teamId: team!.id),
                            builder: (context, snapshotMembers) {
                              List<String> listIds = [];

                              if (snapshotMembers.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              for (var member in snapshotMembers.data!.docs) {
                                listIds.add(member.data().userId);
                              }
                              if (listIds.isEmpty) {
                                return TeamStory(
                                    userAsManager: userAsManager,
                                    onTap: () {
                                      print("objectsdsad");

                                      Get.to(() => ShowTeamMembers(
                                            teamModel: team!,
                                            userAsManager: userAsManager,
                                          ));
                                    },
                                    teamModel: team!,
                                    users: <UserModel>[],
                                    teamTitle: snapshotTeam.data!.data()!.name!,
                                    numberOfMembers: 0.toString(),
                                    noImages: 0.toString());
                                // buildStackedImages(
                                //   addMore: true,
                                //   numberOfMembers: 0.toString(),
                                //   users: <UserModel>[],
                                //   onTap: () {
                                //     print("dasdasd");
                                //   },
                                // );
                              }
                              return StreamBuilder<QuerySnapshot<UserModel>>(
                                  stream: UserController()
                                      .getUsersWhereInIdsStream(
                                          usersId: listIds),
                                  builder: (context, snapshotUsers) {
                                    if (snapshotUsers.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }

                                    List<UserModel> users = [];
                                    for (var element
                                        in snapshotUsers.data!.docs) {
                                      users.add(element.data());
                                    }
                                    return TeamStory(
                                        userAsManager: userAsManager,
                                        onTap: () {
                                          print("objectsdsad");
                                          Get.to(() => ShowTeamMembers(
                                                teamModel: team!,
                                                userAsManager: userAsManager,
                                              ));
                                        },
                                        teamModel: team!,
                                        users: users,
                                        teamTitle:
                                            snapshotTeam.data!.data()!.name!,
                                        numberOfMembers: snapshotUsers
                                            .data!.docs.length
                                            .toString(),
                                        noImages: snapshotUsers
                                            .data!.docs.length
                                            .toString());
                                  });
                            }),
                        AppSpaces.verticalSpace10,
                        FutureBuilder<UserModel>(
                            future: UserController().getUserWhereMangerIs(
                                mangerId: team!.managerId),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    "There is an error ${snapshot.error}");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              return InBottomSheetSubtitle(
                                  title:
                                      "Managed By ${snapshot.data!.name} that created the Team on ${snapshotTeam.data!.data()!.createdAt.month}/${snapshotTeam.data!.data()!.createdAt.day}  of ${snapshotTeam.data!.data()!.createdAt.year}",
                                  textStyle: GoogleFonts.lato(
                                      fontSize: 15, color: Colors.white70));
                            }),
                        AppSpaces.verticalSpace40,
                        ValueListenableBuilder(
                          valueListenable: settingsButtonTrigger,
                          builder: (BuildContext context, _, __) {
                            return settingsButtonTrigger.value == 0
                                ? Expanded(
                                    child: TeamProjectOverview2(
                                    userAsManager: userAsManager,
                                    me: me,
                                    partner: partner,
                                    teamModel: team!,
                                  ))
                                : const CalendarView();
                          },
                        )
                      ],
                    );
                  }
                  return Center(
                    child: Text(
                      snapshotTeam.error.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  );
                }),
          ),
        )
      ]),
    );
  }
}

class TeamProjectOverview2 extends StatefulWidget {
  final TeamModel teamModel;
  final String? me;
  final String partner;
  ManagerModel? userAsManager;
  TeamProjectOverview2({
    required this.teamModel,
    required this.me,
    required this.partner,
    required this.userAsManager,
    Key? key,
  }) : super(key: key);

  @override
  State<TeamProjectOverview2> createState() => _TeamProjectOverviewState();
}

class _TeamProjectOverviewState extends State<TeamProjectOverview2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<ProjectModel>>(
        stream: ProjectController()
            .getProjectsOfTeamStream(teamId: widget.teamModel.id),
        builder: (context, snapshotProject) {
          if (snapshotProject.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshotProject.error}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 39,
                ),
              ),
            );
          }

          if (snapshotProject.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final projects = snapshotProject.data!.docs.toList();
          if (projects.isEmpty) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Iconsax.task,
                      size: 100,
                      color: HexColor.fromHex("#999999"),
                    ),
                    AppSpaces.verticalSpace10,
                    Text(
                      "No Projects for ${widget.teamModel.name} ",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: HexColor.fromHex("#999999"),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ]),
            );
          }
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //change
                crossAxisCount: 2,
                mainAxisSpacing: 10,

                //change height 125
                mainAxisExtent: 220,
                crossAxisSpacing: 10,
              ),
              itemCount: snapshotProject.data!.size,
              itemBuilder: (_, index) {
                final teamId = snapshotProject.data!.docs[index].data().teamId!;
                return StreamBuilder<DocumentSnapshot<TeamModel>>(
                    stream: TeamController().getTeamByIdStream(id: teamId),
                    builder: (context, snapshotTeam) {
                      if (snapshotTeam.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshotTeam.error}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 39,
                            ),
                          ),
                        );
                      }

                      if (snapshotTeam.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }

                      final teamName = snapshotTeam.data?.data()?.name ?? '';

                      return StreamBuilder<DocumentSnapshot<StatusModel>>(
                        stream: StatusController().getStatusByIdStream(
                          idk:
                              snapshotProject.data!.docs[index].data().statusId,
                        ),
                        builder: (context, snapshotStatus) {
                          if (snapshotStatus.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshotStatus.error}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 39,
                                ),
                              ),
                            );
                          }

                          if (snapshotStatus.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          final status = snapshotStatus.data!.data()!.name;
                          if (widget.userAsManager != null) {
                            return FocusedMenu(
                                widget: ProjectCardVertical(
                                  idk: snapshotProject.data!.docs[index]
                                      .data()
                                      .id,
                                  status: status!,
                                  projeImagePath: snapshotProject
                                      .data!.docs[index]
                                      .data()
                                      .imageUrl,
                                  projectName: snapshotProject.data!.docs[index]
                                      .data()
                                      .name!,
                                  teamName: teamName,
                                  endDate: snapshotProject.data!.docs[index]
                                      .data()
                                      .endDate!,
                                  startDate: snapshotProject.data!.docs[index]
                                      .data()
                                      .startDate,
                                ),
                                onClick: () async {
                                  Get.to(CommonOrNotMainTaskScreen(
                                      projectId: snapshotProject
                                          .data!.docs[index]
                                          .data()
                                          .id,
                                      meAssignedTo: null,
                                      anotherMemberAssignedTo: widget.partner));
                                },
                                deleteButton: () async {
                                  try {
                                    showDialogMethod(context);
                                    await ProjectController()
                                        .deleteProject(projects[index].id);
                                    Navigator.of(context).pop();
                                    CustomSnackBar.showSuccess(
                                        "Delete successfully");
                                  } on Exception catch (e) {
                                    Navigator.of(context).pop();
                                    CustomSnackBar.showError(
                                        "Delete Field : ${e.toString()}");
                                  }
                                },
                                editButton: () {
                                  showAppBottomSheet(
                                    EditProject(
                                        userAsManager: widget.userAsManager!,
                                        teamModel: snapshotTeam.data!.data()!,
                                        projectModel: projects[index].data()!),
                                    isScrollControlled: true,
                                    popAndShow: false,
                                  );
                                });
                          } else {
                            return InkWell(
                              onTap: () {
                                Get.to(CommonOrNotMainTaskScreen(
                                    projectId: snapshotProject.data!.docs[index]
                                        .data()
                                        .id,
                                    meAssignedTo: widget.me,
                                    anotherMemberAssignedTo: widget.partner));
                              },
                              child: ProjectCardVertical(
                                idk:
                                    snapshotProject.data!.docs[index].data().id,
                                status: status!,
                                projeImagePath: snapshotProject
                                    .data!.docs[index]
                                    .data()
                                    .imageUrl,
                                projectName: snapshotProject.data!.docs[index]
                                    .data()
                                    .name!,
                                teamName: teamName,
                                endDate: snapshotProject.data!.docs[index]
                                    .data()
                                    .endDate!,
                                startDate: snapshotProject.data!.docs[index]
                                    .data()
                                    .startDate,
                              ),
                            );
                          }
                        },
                      );
                    });
              });
        });
  }
}
