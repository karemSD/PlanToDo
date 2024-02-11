import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/app_constans.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Team_model.dart';

import '../../Values/values.dart';
import '../../constants/constants.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/Projects/project_card_vertical.dart';
import '../../widgets/add_sub_icon.dart';
import '../../widgets/container_label.dart';
import 'team_details.dart';


class TeamStory extends StatelessWidget {
  final String teamTitle;
  final String numberOfMembers;
  final String noImages;
  final TeamModel teamModel;
  final ManagerModel? userAsManager;
  final List<UserModel> users;
  final VoidCallback? onTap;
  const TeamStory(
      {Key? key,
      required this.userAsManager,
      required this.onTap,
      required this.teamModel,
      required this.users,
      required this.teamTitle,
      required this.numberOfMembers,
      required this.noImages,
      required})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(teamTitle, style: AppTextStyles.header2.copyWith(fontSize: 35)),
        AppSpaces.verticalSpace10,
        ContainerLabel(
            label: "$numberOfMembers ${AppConstants.members_key.tr}"),
        AppSpaces.verticalSpace10,
        InkWell(
          onTap: () {
            Get.to(() => TeamDetails(
                  userAsManager: userAsManager,
                  title: teamTitle,
                  team: teamModel,
                ));
          },
          child: Transform.scale(
              alignment: Alignment.centerLeft,
              scale: 0.7,
              child: buildStackedImages(
                  onTap: onTap,
                  users: users,
                  numberOfMembers: noImages,
                  addMore: true)),
        ),
      ],
    );
  }
}
