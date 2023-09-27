import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Profile/team_details.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/models/team/Project_model.dart';

import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/widgets/Dashboard/dashboard_meeting_details.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';
import 'package:mytest/widgets/Team/active_team_cardK.dart';

import '../../Data/data_model.dart';
import '../../Values/values.dart';
import '../../controllers/manger_controller.dart';
import '../../controllers/userController.dart';
import '../../models/User/User_model.dart';
import '../../models/team/Manger_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/Buttons/primary_buttons.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';

import '../../widgets/Navigation/app_header.dart';

import '../../widgets/dummy/profile_dummy.dart';

import '../Profile/profile_overview.dart';

import '../Projects/addTeamToCreateProjectScre.dart';
import '../Projects/addUserToTeamScreenController.dart';

enum TeamSortOption {
  name,
  createDate,
  updatedDate,
  // numbersOfMembers
  // Add more sorting options if needed
}

class TeamInfo {
  final TeamModel team;
  int? membersNumber;

  TeamInfo(this.team, this.membersNumber);
  static List<TeamModel> sortTeams(
      {required List<TeamModel> teams,
      required TeamSortOption sortOption,
      bool ascending = true}) {
    switch (sortOption) {
      case TeamSortOption.name:
        print("objectsadsdsssssssssssss");
        teams.sort((a, b) => a.name!.compareTo(b.name!));
        break;
      case TeamSortOption.createDate:
        teams.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TeamSortOption.updatedDate:
        teams.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
    }

    if (!ascending) {
      teams = teams.reversed.toList();
    }
    return teams;
  }
}

class SelectMyTeamScreen extends StatefulWidget {
  SelectMyTeamScreen({Key? key, required this.title}) : super(key: key);
  final String title;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  DashboardMeetingDetailsScreenController controller =
      Get.put(DashboardMeetingDetailsScreenController(), permanent: true);
  AddTeamToCreatProjectScreen addTeamToCreatProjectScreen =
      Get.put(AddTeamToCreatProjectScreen());

  @override
  State<SelectMyTeamScreen> createState() => _SelectMyTeamScreenState();
}

class _SelectMyTeamScreenState extends State<SelectMyTeamScreen> {
  final dynamic data = AppData.employeeData;

  @override
  void initState() {
    userController.users.clear();
    addTeamToCreatProjectScreen.teams.clear();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  TeamSortOption selectedSortOption = TeamSortOption.name;

  String _getSortOptionText(TeamSortOption option) {
    switch (option) {
      case TeamSortOption.name:
        return 'Name';
      case TeamSortOption.updatedDate:
        return 'Updated Date';
      case TeamSortOption.createDate:
        return 'Created Date';

      // Add cases for more sorting options if needed
      default:
        return '';
    }
  }

  bool sortAscending = true; // Variable for sort order
  void toggleSortOrder() {
    setState(() {
      print("sdsdsd");
      sortAscending = !sortAscending; // Toggle the sort order
    });
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
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20),
                  child: TaskezAppHeader(
                    title: widget.title,
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            return ProfileDummy(
                              imageType: ImageType.Network,
                              color: Colors.white,
                              dummyType: ProfileDummyType.Image,
                              image: snapshot.data!.data()!.imageUrl,
                              scale: 1.2,
                            );
                          }),
                    ),
                  ),
                ),
                AppSpaces.verticalSpace40,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<TeamSortOption>(
                        value: selectedSortOption,
                        onChanged: (TeamSortOption? newValue) {
                          setState(() {
                            selectedSortOption = newValue!;
                            // Implement the sorting logic here
                          });
                        },
                        items:
                            TeamSortOption.values.map((TeamSortOption option) {
                          return DropdownMenuItem<TeamSortOption>(
                            value: option,
                            child: Text(
                              _getSortOptionText(option),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),

                        // Add extra styling
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          size: 35,
                        ),
                        underline: const SizedBox(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          width: 2,
                          color: HexColor.fromHex("616575"),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          sortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Colors.white,
                        ),
                        onPressed: toggleSortOrder, // Toggle the sort order
                      ),
                    ),
                  ],
                ),
                AppSpaces.verticalSpace40,
                Expanded(
                  child: StreamBuilder<QuerySnapshot<TeamModel>?>(
                    stream: TeamController().getTeamsOfUserStream(
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<TeamModel> teams = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
                        switch (selectedSortOption) {
                          case TeamSortOption.name:
                            print("objectsadsdsssssssssssss");
                            teams.sort((a, b) => a.name!.compareTo(b.name!));
                            break;
                          case TeamSortOption.createDate:
                            teams.sort(
                                (a, b) => a.createdAt.compareTo(b.createdAt));
                            break;
                          case TeamSortOption.updatedDate:
                            teams.sort(
                                (a, b) => a.updatedAt.compareTo(b.updatedAt));
                            break;
                        }

                        if (!sortAscending) {
                          teams = teams.reversed.toList();
                        }

                        // // Create a list of TeamInfo objects
                        // List<TeamInfo> teamInfos = teams.map((team) {
                        //   // Calculate the number of members for each team here
                        //   int membersCount;
                        //   // Replace this with your actual logic

                        //   return TeamInfo(team, null);
                        // }).toList();
                        return MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                            itemCount: teams.length,
                            itemBuilder: (context, index) {
                              final team = teams[index];
                              return StreamBuilder<
                                  QuerySnapshot<TeamMemberModel>>(
                                stream: TeamMemberController()
                                    .getMembersInTeamIdStream(teamId: team.id),
                                builder: (context, memberSnapshot) {
                                  if (memberSnapshot.hasData) {
                                    final membersCount =
                                        memberSnapshot.data!.docs.length;
                                    // for (var element in teamInfos) {
                                    //   element.membersNumber = membersCount;
                                    // }
                                    // teamInfos = TeamInfo.sortTeams(
                                    //     teams: teamInfos,
                                    //     sortOption: selectedSortOption,
                                    //     ascending: sortAscending);
                                    print("sadsdsdasdasdasdasdasda");
                                    return Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                            extentRatio: .30,
                                            motion: const StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                label: "Delete ",
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                backgroundColor: Colors.red,
                                                icon: FontAwesomeIcons.trash,
                                                onPressed: (context) async {
                                                  try {
                                                    print("prdasdas");
                                                    // showDialogMethod(context);

                                                    List<ProjectModel>
                                                        projects =
                                                        await ProjectController()
                                                            .getProjectsOfTeamKarem(
                                                                teamId:
                                                                    team.id);
                                                    List<String> projectsIds =
                                                        <String>[];
                                                    for (var element
                                                        in projects) {
                                                      projectsIds
                                                          .add(element.id);
                                                    }
                                                    await TeamController()
                                                        .deleteTeam(
                                                            id: team.id,
                                                            projectIds:
                                                                projectsIds);

                                                    print("delete");
                                                    CustomSnackBar.showSuccess(
                                                        "Team Deleted 'Successfully");
                                                  } on Exception catch (e) {
                                                    Navigator.of(context).pop();
                                                    CustomSnackBar.showError(
                                                        e.toString());
                                                    // TODO
                                                  }
                                                },
                                              ),
                                            ]),
                                        startActionPane: ActionPane(
                                            extentRatio: .30,
                                            motion: const StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                label: "Projects",
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                backgroundColor: Colors.blue,
                                                icon:
                                                    FontAwesomeIcons.listCheck,
                                                onPressed: (context) async {
                                                  showDialogMethod(context);
                                                  ManagerModel? userAsManger =
                                                      await ManagerController()
                                                          .getMangerWhereUserIs(
                                                              userId: AuthService
                                                                  .instance
                                                                  .firebaseAuth
                                                                  .currentUser!
                                                                  .uid);

                                                  Get.key.currentState!.pop();

                                                  Get.to(() => TeamDetails(
                                                      title: team.name!,
                                                      team: team,
                                                      userAsManager:
                                                          userAsManger));
                                                  print("projects");
                                                },
                                              ),
                                            ]),
                                        child: ActiveTeamCard(
                                          imageType: ImageType.Network,
                                          onTap: () {
                                            if (widget.title !=
                                                "Manager Teams") {
                                              print("objectsasa");
                                              addTeamToCreatProjectScreen
                                                  .addUser(team);
                                              print("objectssdadsdasa");

                                              addTeamToCreatProjectScreen
                                                  .update();
                                              Get.close(1);
                                            }
                                          },
                                          team: team,
                                          numberOfMembers: membersCount,
                                          teamName: team.name!,
                                          teamImage: team.imageUrl,
                                        ),
                                      ),
                                    );
                                  } else if (memberSnapshot.hasError) {
                                    return Text(
                                      'Error: ${memberSnapshot.error}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 39,
                                      ),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
//                             Container(
// //width: 100,
//                               height: 75,
//                               child: Image.asset("assets/icon/error.png"),
//                             ),
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
                                  snapshot.error.toString().substring(11),
                                  style: GoogleFonts.fjallaOne(
                                    color: Colors.white,
                                    fontSize: 40,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                AppPrimaryButton(
                  buttonHeight: 50,
                  buttonWidth: 180,
                  buttonText: "Add New Team",
                  callback: () {
                    DashboardMeetingDetails.users = [];
                    Get.to(() => const DashboardMeetingDetails());
                    // Get.to(() => TeamDetails(
                    //       title: "TEMaM",
                    //     ));
                    // int count = 0;
                    // Navigator.of(context).popUntil((_) => count++ >= 2);
                  },
                ),
                AppSpaces.verticalSpace20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
