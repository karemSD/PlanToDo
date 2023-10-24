import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Profile/team_details.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/models/team/Team_model.dart';

import '../../Values/values.dart';

import '../dummy/green_done_icon.dart';
import '../dummy/profile_dummy.dart';

class ActiveTeamCard extends StatelessWidget {
  final String teamName;
  final VoidCallback onTap;
  final String teamImage;
  final int numberOfMembers;
  final TeamModel team;
  final ImageType imageType;
  const ActiveTeamCard(
      {Key? key,
      required this.imageType,
      required this.onTap,
      required this.team,
      required this.teamName,
      required this.teamImage,
      required this.numberOfMembers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Utils.screenWidth * 0.03,
            vertical: Utils.screenWidth * 0.02),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.pink, AppColors.lightMauveBackgroundColor],
            ),
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: HexColor.fromHex("181A1F")),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      ProfileDummy(
                        imageType: imageType,
                        dummyType: ProfileDummyType.Image,
                        scale: 2,
                        color: null,
                        image: teamImage,
                      ),
                      AppSpaces.horizontalSpace20,
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                teamName,
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Utils.screenWidth * 0.04,
                                ),
                              ),
                              SizedBox(
                                height: Utils.screenHeight *
                                    0.01, // Adjust the percentage as needed
                                width: Utils.screenWidth *
                                    0.03, // Adjust the percentage as needed
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Utils.screenWidth *
                                      0.02, // Adjust the percentage as needed
                                  vertical: Utils.screenHeight * 0.01,
                                ),
                                decoration: BoxDecoration(
                                    //color: HexColor.fromHex(color),
                                    border: Border.all(
                                        color: Colors.blue, width: 1),
                                    borderRadius: BorderRadius.circular(50.0)),
                                child: Text(
                                  "$numberOfMembers  ${AppConstants.members_key.tr}",
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Utils.screenWidth * 0.03,
                                  ),
                                ),
                              )
                            ])
                          ])
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
