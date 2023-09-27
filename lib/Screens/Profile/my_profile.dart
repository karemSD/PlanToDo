import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Dashboard/projects.dart';
import 'package:mytest/Screens/Dashboard/selectMyTeams.dart';
import 'package:mytest/Screens/Dashboard/select_team.dart';
import 'package:mytest/controllers/manger_controller.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Manger_model.dart';

import '../../Values/values.dart';
import '../../controllers/userController.dart';
import '../../services/auth_service.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Navigation/default_back.dart';
import '../../widgets/Profile/profile_text_option.dart';
import '../../widgets/Profile/text_outlined_button.dart';
import '../../widgets/dummy/profile_dummy.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final UserModel user;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ValueNotifier<bool> totalTaskNotifier = ValueNotifier(true);
  final String tabSpace = "\t\t";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      DarkRadialBackground(
        color: HexColor.fromHex("#181a1f"),
        position: "topLeft",
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DefaultNav(
                    userModel: widget.user,
                    title: "$tabSpace Profile",
                    type: ProfileDummyType.Button),
                const SizedBox(height: 30),
                StreamBuilder<DocumentSnapshot<UserModel>>(
                    stream: UserController().getUserByIdStream(
                        id: AuthService.instance.firebaseAuth.currentUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Column(
                        children: [
                          ProfileDummy(
                              imageType: ImageType.Network,
                              color: HexColor.fromHex("0000"),
                              dummyType: ProfileDummyType.Image,
                              scale: 4.0,
                              image: snapshot.data!.data()!.imageUrl),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("${snapshot.data!.data()!.name} ",
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Text(
                              AuthService.instance.firebaseAuth.currentUser!
                                      .isAnonymous
                                  ? "Sign in Anonmouslly"
                                  : snapshot.data!.data()!.email!,
                              style: GoogleFonts.lato(
                                  color: HexColor.fromHex("B0FFE1"),
                                  fontSize: 17)),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: OutlinedButtonWithText(
                                width: 75,
                                content: "Edit",
                                onPressed: () {
                                  Get.to(() => EditProfilePage(
                                      user: snapshot.data?.data()));
                                }),
                          ),
                        ],
                      );
                    }),
                AppSpaces.verticalSpace20,
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF262A34),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // child: Column(
                      //   children: [
                      //     ToggleLabelOption(
                      //       label: '$tabSpace Show me as away',
                      //       notifierValue: totalTaskNotifier,
                      //       icon: Icons.directions_run_rounded,
                      //       margin: 7.0,
                      //     ),
                      //   ],
                      // ),
                    ),
                    AppSpaces.verticalSpace10,
                    ProfileTextOption(
                      inTap: () {
                        Get.to(() => Scaffold(
                              backgroundColor: HexColor.fromHex("#181a1f"),
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.centerFloat,
                              body: ProjectScreen(),
                            ));
                      },
                      label: '$tabSpace My Projects',
                      icon: Icons.cast,
                      margin: 5.0,
                    ),
                    AppSpaces.verticalSpace10,
                    ProfileTextOption(
                      inTap: () async {
                        showDialogMethod(context);
                        ManagerModel? userAsManger = await ManagerController()
                            .getMangerWhereUserIs(
                                userId: AuthService
                                    .instance.firebaseAuth.currentUser!.uid);
                        if (mounted) {
                          Navigator.of(context).pop();
                        }
                        Get.to(() => SelectTeamScreen(
                            title: "My Teams", managerModel: userAsManger));
                      },
                      label: '$tabSpace My Teams',
                      icon: Icons.group,
                      margin: 5.0,
                    ),
                    AppSpaces.verticalSpace10,
                    ProfileTextOption(
                      inTap: () {
                        Get.to(
                            () => SelectMyTeamScreen(title: "Manager Teams"));
                      },
                      label: '$tabSpace Manager Teams',
                      icon: FeatherIcons.share2,
                      margin: 5.0,
                    ),
                    AppSpaces.verticalSpace10,
                    ProfileTextOption(
                      inTap: () {
                        print("to nour");
                      },
                      label: '$tabSpace All My Task',
                      icon: Icons.check_circle_outline,
                      margin: 5.0,
                    ),
                    AppSpaces.verticalSpace20,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ]));
  }
}
