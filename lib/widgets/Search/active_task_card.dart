import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mytest/constants/back_constants.dart';

import '../../Values/values.dart';
import '../dummy/profile_dummy.dart';

class ActiveTaskCard extends StatelessWidget {
  final String header;
  final String subHeader;
  final String imageUrl;
  final void Function(BuildContext) onPressedStart;
  final void Function(BuildContext) onPressedEnd;
  final ValueNotifier<bool>? notifier;
  final String date;
  const ActiveTaskCard(
      {Key? key,
      required this.header,
      this.notifier,
      required this.onPressedEnd,
      required this.onPressedStart,
      required this.imageUrl,
      required this.subHeader,
      required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        extentRatio: .30,
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            label: "Accept",
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.blue.shade300,
            icon: FontAwesomeIcons.userCheck,
            onPressed: onPressedStart,
          ),
        ],
      ),
      endActionPane: ActionPane(
          extentRatio: .30,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              label: "Decline",
              borderRadius: BorderRadius.circular(20),
              icon: FontAwesomeIcons.userXmark,
              backgroundColor: Colors.red,
              onPressed: onPressedEnd,
            ),
          ]),
      child: InkWell(
        onTap: () {
//notifier.value = !notifier.value;
        },
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: AppColors.primaryBackgroundColor,
              borderRadius: BorderRadius.circular(35)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              ProfileDummy(
                imageType: ImageType.Network,
                color: Colors.white,
                dummyType: ProfileDummyType.Image,
                image: imageUrl,
                scale: 1.2,
              ),
              AppSpaces.horizontalSpace20,
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      header,
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    Text(
                      subHeader,
                      style: GoogleFonts.lato(
                        color: HexColor.fromHex("5A5E6D"),
                      ),
                    )
                  ])
            ]),
            Text(
              date,
              style: GoogleFonts.lato(
                color: HexColor.fromHex("F5A3FF"),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
