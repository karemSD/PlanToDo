import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Values/values.dart';

import '../dummy/profile_dummy.dart';

class InactiveTeamCard extends StatelessWidget {
  final String employeeName;
  final String employeeImage;
  final ValueNotifier<bool> notifier;
  final String employeePosition;
  final Color color;

  const InactiveTeamCard(
      {Key? key,
      required this.employeeName,
      required this.color,
      required this.employeeImage,
      required this.employeePosition,
      required this.notifier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        notifier.value = !notifier.value;
        print("object");
      },
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
                                          imageType: ImageType.Assets,

            dummyType: ProfileDummyType.Image,
            scale: 0.85,
            color: null,
            image: employeeImage,
          ),
          AppSpaces.horizontalSpace20,
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(employeeName,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.2)),
                  const SizedBox(
                    height: 4,
                    width: 13,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5.0),
                      decoration: BoxDecoration(
                          //color: HexColor.fromHex(color),
                          border: Border.all(color: Colors.blue, width: 1),
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Text("5 members",
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)))
                ])
              ])
        ]),
      ),
    );
  }
}
