// import 'package:flutter/material.dart';
// import 'package:mytest/widgets/Team/active_team_cardK.dart';
// import 'package:mytest/widgets/Team/inActive_team_cardK.dart';

// import '../active_employee_card.dart';
// import '../inactive_employee_card.dart';

// class TeamCardK extends StatelessWidget {
//   final String teamName;
//   final String teamImagePath;
//   final String employeePosition;
//   final Color backgroundColor;
//   final bool activated;
//   final int index;
//   final int selectedIndex;
//   final VoidCallback onCardSelected;
//   const TeamCardK(
//       {Key? key,
//       required this.index,
//       required this.selectedIndex,
//       required this.onCardSelected,
//       required this.teamName,
//       required this.teamImagePath,
//       required this.backgroundColor,
//       required this.employeePosition,
//       required this.activated})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final bool newBool = activated;
//     ValueNotifier<bool> totalDueTrigger = ValueNotifier(newBool);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: ValueListenableBuilder(
//           valueListenable: totalDueTrigger,
//           builder: (BuildContext context, _, __) {
//             return InkWell(
//               onTap: () {
//                 onCardSelected();
//                 activated; // Call the callback to update the selected index
//               },
//               child: Container(
//                   child: activated
//                       ? ActiveTeamCard(
//                           numberOfMembers: 4,
//                           employeeImage: teamImagePath,
//                           employeeName: teamName,
//                         )
//                       : InactiveTeamCard(
//                           color: backgroundColor,
//                           notifier: totalDueTrigger,
//                           employeeImage: teamImagePath,
//                           employeeName: teamName,
//                           employeePosition: employeePosition)),
//             );
//           }),
//     );
//   }
// }
