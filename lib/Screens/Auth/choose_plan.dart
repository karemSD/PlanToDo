// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:mytest/Screens/Dashboard/timeline.dart';

// import '../../Values/values.dart';
// import '../../widgets/Buttons/primary_progress_button.dart';
// import '../../widgets/DarkBackground/darkRadialBackground.dart';
// import '../../widgets/Navigation/default_back.dart';
// import '../../widgets/Onboarding/plan_card.dart';
// import '../../widgets/Onboarding/toggle_option.dart';

// class ChoosePlan extends StatelessWidget {
//   const ChoosePlan({super.key});

//   @override
//   Widget build(BuildContext context) {
//     ValueNotifier<bool> multiUserTrigger = ValueNotifier(false);
//     ValueNotifier<bool> customLabelTrigger = ValueNotifier(false);
//     ValueNotifier<int> planContainerTrigger = ValueNotifier(0);
//     return Scaffold(
//         body: Stack(children: [
//       DarkRadialBackground(
//         color: HexColor.fromHex("#181a1f"),
//         position: "topLeft",
//       ),
//       Column(children: [
//         const SizedBox(height: 40),
//         const Padding(
//           padding: EdgeInsets.all(20.0),
//           child: DefaultNav(title: "New WorkSpace"),
//         ),
//         AppSpaces.verticalSpace20,
//         Expanded(
//             flex: 1,
//             child: Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 decoration: BoxDecorationStyles.fadingGlory,
//                 child: Padding(
//                   padding: const EdgeInsets.all(3.0),
//                   child: DecoratedBox(
//                       decoration: BoxDecorationStyles.fadingInnerDecor,
//                       child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               AppSpaces.verticalSpace10,
//                               Text('Choose Plan', style: AppTextStyles.header2),
//                               AppSpaces.verticalSpace10,
//                               Text('Unlock all features with Premium Plan',
//                                   style: GoogleFonts.lato(
//                                       fontSize: 14,
//                                       color: HexColor.fromHex("666A7A"))),
//                               AppSpaces.verticalSpace20,
//                               Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     PlanCard(
//                                       notifierValue: planContainerTrigger,
//                                       selectedIndex: 0,
//                                       header: "It's Free",
//                                       subHeader: "For team\nfrom 1 - 5",
//                                     ),
//                                     AppSpaces.horizontalSpace20,
//                                     PlanCard(
//                                         notifierValue: planContainerTrigger,
//                                         selectedIndex: 1,
//                                         header: "Premium",
//                                         subHeader: "\$19/mo")
//                                   ]),
//                               AppSpaces.verticalSpace20,
//                               Text('Enable Features',
//                                   style: AppTextStyles.header2),
//                               AppSpaces.verticalSpace10,
//                               SizedBox(
//                                 width: Utils.screenWidth * 0.8,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     RichText(
//                                       text: TextSpan(
//                                           text:
//                                               'You can customize the features in your workspace now. Or you can do it later in ',
//                                           style: GoogleFonts.lato(fontSize: 14, color: HexColor.fromHex("666A7A")),
//                                           children: const <TextSpan>[
//                                             TextSpan(
//                                                 text: 'Menu - Workspace',
//                                                 style: TextStyle(
//                                                     color: Colors.white))
//                                           ]),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               AppSpaces.verticalSpace20,
//                               ToggleLabelOption(
//                                   label: '    Multiple Assignees',
//                                   notifierValue: multiUserTrigger,
//                                   icon: Icons.groups),
//                               ToggleLabelOption(
//                                   label: '    Custom Labels',
//                                   notifierValue: customLabelTrigger,
//                                   icon: Icons.category)
//                             ],
//                           ))),
//                 )))
//       ]),
//       Positioned(
//           bottom: 50,
//           child: Container(
//             padding: const EdgeInsets.only(left: 40, right: 20),
//             width: Utils.screenWidth,
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text('Back',
//                       style: GoogleFonts.lato(
//                           color: HexColor.fromHex("616575"),
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                   PrimaryProgressButton(
//                       width: 120,
//                       label: "Done",
//                       callback: () {
//                         Get.to(() => const Timeline());
//                       })
//                 ]),
//           ))
//     ]));
//   }
// }
