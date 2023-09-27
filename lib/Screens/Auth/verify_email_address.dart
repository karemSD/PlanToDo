// ignore_for_file: avoid_print

import 'package:either_dart/either.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:mytest/services/auth_service.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';

import '../../Values/values.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';

import '../../widgets/Navigation/back.dart';
import '../../widgets/Shapes/background_hexagon.dart';
import '../Dashboard/timeline.dart';

class VerifyEmailAddressScreen extends StatefulWidget {
  const VerifyEmailAddressScreen({super.key});

  @override
  _VerifyEmailAddressScreenState createState() =>
      _VerifyEmailAddressScreenState();
}

class _VerifyEmailAddressScreenState extends State<VerifyEmailAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
        Positioned(
          top: Utils.screenHeight / 2,
          left: Utils.screenWidth,
          child: Transform.rotate(
            angle: -math.pi / 2,
            child: CustomPaint(
              painter: BackgroundHexagon(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const NavigationBack(),
                    AppSpaces.verticalSpace20,
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Utils.screenWidth / 3),
                      child: const Icon(
                        size: 100,
                        FontAwesomeIcons.envelopeOpen,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                        "Check your an\nemail messages we have send the link to email to verify ",
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    AppSpaces.verticalSpace40,
                    SizedBox(
                      //width: 180,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          var verifyEmail =
                              await AuthService().sendVerifiectionEmail();
                          verifyEmail.fold((left) {
                            CustomSnackBar.showError(left.toString());
                          },
                              (right) => {
                                    if (right == true)
                                      {
                                        CustomSnackBar.showSuccess(
                                            "the Email is verifed"),
                                        Get.offAll(() => const Timeline()),
                                      }
                                  });
                        },
                        style: ButtonStyles.blueRounded,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.link, color: Colors.white),
                            Text('  Send Verify Link',
                                style: GoogleFonts.lato(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    AppSpaces.verticalSpace20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Verifed ? ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        GestureDetector(
                          onTap: () {
                            var verifed = AuthService().checkEmailVerifction();
                            verifed.fold((left) {
                              CustomSnackBar.showError(left.toString());
                            }, (right) {
                              if (right == true) {
                                CustomSnackBar.showSuccess("Sucess baby");
                                Get.offAll(() => const Timeline());
                              } else {
                                CustomSnackBar.showError(
                                    "Plese Verify your Email before continue ");
                              }
                            });
                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        )
      ]),
    );
  }
}
