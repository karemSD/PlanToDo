import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Team_model.dart';

import '../../Data/data_model.dart';
import '../../Values/values.dart';
import '../../constants/constants.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/Projects/project_card_vertical.dart';
import '../../widgets/add_sub_icon.dart';
import '../../widgets/container_label.dart';
import 'team_details.dart';

// class MyTeams extends StatelessWidget {
//   const MyTeams({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(children: [
//       DarkRadialBackground(
//         color: HexColor.fromHex("#181a1f"),
//         position: "topLeft",
//       ),
//       Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: SafeArea(
//               child: SingleChildScrollView(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                 TaskezAppHeader(
//                     title: "$tabSpace $tabSpace Team",
//                     widget: const Row(children: [
//                       Icon(Icons.more_horiz, size: 30, color: Colors.white),
//                       AppSpaces.horizontalSpace20,
//                       AddSubIcon()
//                     ])),
//                 AppSpaces.verticalSpace40,
//                 const TeamStory(
//                     users: [],
//                     teamTitle: "Marketing",
//                     numberOfMembers: "12",
//                     noImages: "8"),
//                 SizedBox(
//                   height: Utils.screenHeight / 2,
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       //change
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 10,

//                       //change height 125
//                       mainAxisExtent: 220,
//                       crossAxisSpacing: 10,
//                     ),
//                     itemBuilder: (_, index) => ProjectCardVertical(
//                       idk: AppData.productData[index][idK],
//                       status: AppData.productData[index]['status'],
//                       projeImagePath: AppData.productData[index]
//                           ['projeImagePath'],
//                       projectName: AppData.productData[index]['projectName'],
//                       teamName: AppData.productData[index]['teamName'],
//                       endDate: AppData.productData[index]['endDate'],
//                       startDate: AppData.productData[index]['startDate'],
//                     ),
//                     itemCount: 2,
//                   ),
//                 ),
//                 AppSpaces.verticalSpace40,
//                 const TeamStory(
//                     users: [],
//                     teamTitle: "Design",
//                     numberOfMembers: "12",
//                     noImages: "8"),
//                 SizedBox(
//                   height: Utils.screenHeight / 2,
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       //change
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 10,

//                       //change height 125
//                       mainAxisExtent: 220,
//                       crossAxisSpacing: 10,
//                     ),
//                     itemBuilder: (_, index) => ProjectCardVertical(
//                       idk: AppData.productData[index][idK],
//                       status: AppData.productData[index]['status'],
//                       projeImagePath: AppData.productData[index]
//                           ['projeImagePath'],
//                       projectName: AppData.productData[index]['projectName'],
//                       teamName: AppData.productData[index]['teamName'],
//                       endDate: AppData.productData[index]['ratingsUpperNumber'],
//                       startDate: AppData.productData[index]
//                           ['ratingsLowerNumber'],
//                     ),
//                     itemCount: 4,
//                   ),
//                 ),
//                 AppSpaces.verticalSpace40,
//                 const TeamStory(
//                   teamModel: te,
//                     users: [],
//                     teamTitle: "Accounting",
//                     numberOfMembers: "12",
//                     noImages: "8"),
//                 SizedBox(
//                   height: Utils.screenHeight / 2,
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       //change
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 10,

//                       //change height 125
//                       mainAxisExtent: 220,
//                       crossAxisSpacing: 10,
//                     ),
//                     itemBuilder: (_, index) => ProjectCardVertical(
//                       idk: AppData.productData[index][idK],
//                       status: AppData.productData[index]['status'],
//                       projeImagePath: AppData.productData[index]
//                           ['projeImagePath'],
//                       projectName: AppData.productData[index]['projectName'],
//                       teamName: AppData.productData[index]['category'],
//                       endDate: AppData.productData[index]['ratingsUpperNumber'],
//                       startDate: AppData.productData[index]
//                           ['ratingsLowerNumber'],
//                     ),
//                     itemCount: 1,
//                   ),
//                 )
//               ]))))
//     ]));
//   }
// }

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
        ContainerLabel(label: "$numberOfMembers Members"),
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
