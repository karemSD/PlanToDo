import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Values/values.dart';
import 'dummy/green_done_icon.dart';
import 'dummy/profile_dummy.dart';

class ActiveEmployeeCard extends StatelessWidget {
  final String userName;
  final String userImage;
  final Color? color;
  final String bio;
  final ValueNotifier<bool>? notifier;
  final VoidCallback? onTap;

  const ActiveEmployeeCard(
      {Key? key,
      required this.userName,
      required this.userImage,
      required this.bio,
      required this.notifier,
      required this.color,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                        imageType: ImageType.Network,
                        dummyType: ProfileDummyType.Image,
                        scale: 0.85,
                        color: color,
                        image: userImage,
                      ),
                      AppSpaces.horizontalSpace20,
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userName,
                                style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.2)),
                            const SizedBox(height: 4),
                            Text(bio,
                                style: GoogleFonts.lato(
                                    color: HexColor.fromHex("5A5E6D")))
                          ])
                    ]),
                    const Align(
                        alignment: Alignment.topCenter, child: GreenDoneIcon())
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
