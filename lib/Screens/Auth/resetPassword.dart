// ignore_for_file: avoid_print

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/services/collectionsrefrences.dart';

import '../../Values/values.dart';
import '../../components/sqaure_Button.dart';
import '../../services/auth_service.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Forms/form_input_with _label.dart';
import '../../widgets/Navigation/back.dart';
import '../../widgets/Shapes/background_hexagon.dart';
import '../../widgets/Snackbar/custom_snackber.dart';
import '../Dashboard/timeline.dart';
import 'signup.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
  });

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String email = "";
  bool obscureText = false;
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
                child: CustomPaint(painter: BackgroundHexagon()))),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NavigationBack(),
                      const SizedBox(height: 40),
                      Text(
                        "What's your\nemail\naddress? to send reset password Link",
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      AppSpaces.verticalSpace20,
                      LabelledFormInput(
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) {
                            if (!EmailValidator.validate(value!)) {
                              return "Enter Valid Email";
                            } else {
                              return null;
                            }
                          },
                          onClear: () {
                            setState(() {
                              email = "";
                              _emailController.text = "";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          readOnly: false,
                          placeholder: "Email",
                          keyboardType: "text",
                          controller: _emailController,
                          obscureText: obscureText,
                          label: "Your Email"),
                      AppSpaces.verticalSpace40,
                      SizedBox(
                        //width: 180,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                showDialogMethod(context);
                                await AuthService.instance
                                    .resetPassword(email: email);
                                Get.key.currentState!.pop();
                                CustomSnackBar.showSuccess(
                                    "We have send the reset password link");
                              } on Exception catch (e) {
                                Get.key.currentState!.pop();
                                CustomSnackBar.showError(e.toString());
                              }
                            }
                          },
                          style: ButtonStyles.blueRounded,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.email, color: Colors.white),
                              Text(
                                '   Send Reset Password Link',
                                style: GoogleFonts.lato(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppSpaces.verticalSpace20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SquareButtonIcon(
                              imagePath: "lib/images/google2.png",
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    });

                                var authG =
                                    await AuthService().signInWithGoogle();
                                authG.fold((left) {
                                  Navigator.of(context).pop();
                                  CustomSnackBar.showError(left.toString());
                                }, (right) {
                                  Navigator.of(context).pop();
                                  CustomSnackBar.showSuccess("Done byby");
                                });
//   dev.log("message");
                                Get.to(Get.to(() => const Timeline()));
                              }),
                          SquareButtonIcon(
                              imagePath: "lib/images/anonymos.png",
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: Colors.white,
                                      elevation: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 16),
                                            Text(
                                              'Waiting',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                await AuthService().anonymosSignInMethod();
                                Navigator.of(context).pop();

                                //    dev.log("message");
                                Get.to(() => const Timeline());
                              }),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
