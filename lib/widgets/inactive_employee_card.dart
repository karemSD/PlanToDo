import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/widgets/Dashboard/dashboard_meeting_details.dart';

import '../Screens/Projects/addUserToTeamScreenController.dart';
import '../Values/values.dart';
import 'dummy/profile_dummy.dart';

class InactiveEmployeeCard extends StatelessWidget {
  final DashboardMeetingDetailsScreenController addWatingMemberController =
      Get.find<DashboardMeetingDetailsScreenController>();
  final String userName;
  final String userImage;
  final ValueNotifier<bool>? notifier;
  final String bio;
  final Color? color;
  final UserModel? user;
  final VoidCallback? onTap;
  InactiveEmployeeCard(
      {Key? key,
      this.user,
      required this.onTap,
      required this.userName,
      required this.color,
      required this.userImage,
      required this.bio,
      this.notifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            color: AppColors.primaryBackgroundColor,
            // border: Border.all(color: AppColors.primaryBackgroundColor, width: 4),
            borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          ProfileDummy(
            imageType: ImageType.Network,
            dummyType: ProfileDummyType.Image,
            scale: 1.2,
            color: color,
            image: userImage,
          ),
          AppSpaces.horizontalSpace20,
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.4)),
                Text(bio,
                    style: GoogleFonts.lato(color: HexColor.fromHex("5A5E6D")))
              ])
        ]),
      ),
    );
  }
}
