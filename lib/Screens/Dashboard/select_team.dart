import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/User/User_model.dart';

import 'package:mytest/models/team/TeamMembers_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/widgets/Team/active_team_cardK.dart';

import '../../Data/data_model.dart';
import '../../Values/values.dart';
import '../../models/team/Manger_model.dart';
import '../../services/notification_service.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';

import '../../widgets/Navigation/app_header.dart';

import '../../widgets/dummy/profile_dummy.dart';

import '../Profile/profile_overview.dart';

import '../Profile/team_details.dart';
import '../Projects/addUserToTeamScreenController.dart';

class SelectTeamScreen extends StatefulWidget {
  const SelectTeamScreen({
    Key? key,
    required this.title,
    required this.managerModel,
  }) : super(key: key);
  final ManagerModel? managerModel;
  final String title;
  @override
  State<SelectTeamScreen> createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  final dynamic data = AppData.employeeData;

  @override
  void initState() {
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot<TeamModel>>(
                    stream: TeamController().getTeamsofMemberWhereUserIdStream(
                        userId:
                            AuthService.instance.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final teams = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
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
                                    return ActiveTeamCard(
                                      imageType: ImageType.Network,
                                      onTap: () {
                                        //print("object");
                                        Get.to(() => TeamDetails(
                                              userAsManager:
                                                  widget.managerModel,
                                              title: team.name!,
                                              team: team,
                                            ));
                                      },
                                      team: team,
                                      numberOfMembers: membersCount,
                                      teamName: team.name!,
                                      teamImage: team.imageUrl,
                                    );
                                  } else if (memberSnapshot.hasError) {
                                    return Text(
                                      'Error: ${memberSnapshot.error.toString().substring(11)}',
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
                AppSpaces.verticalSpace20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
