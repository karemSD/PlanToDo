import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/Screens/Auth/email_address.dart';
import 'package:mytest/Screens/Auth/resetPassword.dart';
import 'package:mytest/Screens/Auth/verify_email_address.dart';
import 'package:mytest/Screens/Dashboard/timeline.dart';
import 'package:mytest/controllers/statusController.dart';
import 'package:mytest/models/statusmodel.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';

import '../../Values/values.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Forms/form_input_with _label.dart';
import '../../widgets/Navigation/back.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  bool obscureText = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        DarkRadialBackground(
          color: HexColor.fromHex("#181a1f"),
          position: "topLeft",
        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Login',
                              style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                            //say Hi
                            AppSpaces.verticalSpace20,
                            Text(
                              'Nice to see You!',
                              style: GoogleFonts.pacifico(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
                        obscureText: false,
                        label: "Your Email"),
                    LabelledFormInput(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password Can not be Empty";
                          }
                          return null;
                        },
                        onClear: () {
                          setState(() {
                            obscureText = !obscureText;
                            // password = "";
                            // _passController.text = "";
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                        readOnly: false,
                        placeholder: "Password",
                        keyboardType: "text",
                        controller: _passController,
                        obscureText: obscureText,
                        label: "Your Password"),
                    AppSpaces.verticalSpace20,
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ResetPasswordScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    AppSpaces.verticalSpace20,

                    // const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  });

                              UserCredential userCredential =
                                  await AuthService().sigInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.of(context).pop();

                              // CustomSnackBar.showSuccess(
                              //     "Sign IN Successfully");
                              if (userCredential.user!.emailVerified) {
                                Get.offAll(() => const Timeline());
                              } else {
                                Get.to(() => const VerifyEmailAddressScreen());
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                CustomSnackBar.showError(
                                    "No user found for that email");
                              }
                              if (e.code == 'wrong-password') {
                                CustomSnackBar.showError(
                                    "Wrong password provided for that user");
                              }
                              Navigator.of(context).pop();

                              CustomSnackBar.showError(
                                  e.code.replaceAll(RegExp(r'-'), " "));
                              return;
                            } catch (e) {
                              Navigator.of(context).pop();

                              CustomSnackBar.showError(e.toString());
                            }
                          }
                        },
                        style: ButtonStyles.blueRounded,
                        child: Text(
                          'Sign In',
                          style: GoogleFonts.lato(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    AppSpaces.verticalSpace20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          //onTap: widget.onTap,
                          onTap: () {
                            Get.to(() => const EmailAddressScreen());
                          },
                          child: Text(
                            'Make One!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryAccentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
