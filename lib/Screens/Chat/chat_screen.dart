// import 'package:flutter/material.dart';
// import '../../Values/values.dart';
// import '../../constants/constants.dart';
// import '../../widgets/Chat/add_chat_icon.dart';
// import '../../widgets/Chat/badged_title.dart';
// import '../../widgets/Chat/selection_tab.dart';
// import '../../widgets/DarkBackground/darkRadialBackground.dart';
// import '../../widgets/Forms/search_box.dart';
// import '../../widgets/Navigation/app_header.dart';
// import 'new_group.dart';
// import 'new_message_screen.dart';

// class ChatScreen extends StatelessWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final searchController = TextEditingController();
//     return Scaffold(
//         body: Stack(children: [
//       DarkRadialBackground(
//         color: HexColor.fromHex("#181a1f"),
//         position: "topLeft",
//       ),
//       Padding(
//         padding: const EdgeInsets.only(left: 20, right: 20),
//         child: SafeArea(
//           child:
//               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const TaskezAppHeader(
//               title: "Chat",
//               widget: AppAddIcon(page: NewMessageScreen()),
//             ),
//             AppSpaces.verticalSpace20,
//             SearchBox(placeholder: 'Search', controller: searchController),
//             AppSpaces.verticalSpace20,
//             const SelectionTab(title: "GROUP", page: NewGroupScreen()),
//             AppSpaces.verticalSpace20,
//             const BadgedTitle(
//               title: "Marketing",
//               color: 'A5EB9B',
//               number: '12',
//             ),
//             AppSpaces.verticalSpace20,
//             Transform.scale(
//                 alignment: Alignment.centerLeft,
//                 scale: 0.8,
//                 child: buildStackedImages(
//                   numberOfMembers: "8",
//                   onTap: () {},
//                 )),
//             AppSpaces.verticalSpace20,
//             const BadgedTitle(
//               title: "Design",
//               color: 'FCA3FF',
//               number: '6',
//             ),
//             AppSpaces.verticalSpace20,
//             Transform.scale(
//                 alignment: Alignment.centerLeft,
//                 scale: 0.8,
//                 child: buildStackedImages(
//                   numberOfMembers: "2",
//                   onTap: () {},
//                 )),
//             AppSpaces.verticalSpace20,
//             const SelectionTab(
//                 title: "DIRECT MESSAGES", page: NewMessageScreen()),
//             AppSpaces.verticalSpace20,
//             Expanded(
//                 child: MediaQuery.removePadding(
//               context: context,
//               removeTop: true,
//               child: ListView(children: [...onlineUsers]),
//             )),
//           ]),
//         ),
//       )
//     ]));
//   }
// }
