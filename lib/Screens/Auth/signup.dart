import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytest/Screens/Auth/verify_email_address.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/utils/back_utils.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';
import 'dart:developer' as dev;
import '../../Values/values.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Dashboard/dashboard_meeting_details.dart';
import '../../widgets/Forms/form_input_with _label.dart';
import '../../widgets/Navigation/back.dart';
import '../../widgets/dummy/profile_dummy.dart';

class SignUp extends StatefulWidget {
  final String email;
  const SignUp({super.key, required this.email});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isTakean = false;
  String name = "";
  String password = "";
  String userName = "";
  String confirm = "";

  bool obscureText = false;

  //يستخدم لجعل المستخدم قادر على إدخال احرف فقط اي بدون ارقام او محارف خاصة

  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");

  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');

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
                      Text(
                        'Sign Up',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      AppSpaces.verticalSpace20,
                      RichText(
                        text: TextSpan(
                          text: 'Using  ',
                          style: GoogleFonts.lato(
                            color: HexColor.fromHex("676979"),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: widget.email,
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "  to login.",
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("676979"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Builder(builder: (context) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  _showImagePickerDialog(context);
                                  dev.log("message");
                                },
                                child: Stack(
                                  children: [
                                    ProfileDummy(
                                      imageType: selectedImagePath == null
                                          ? ImageType.Assets
                                          : ImageType.File,
                                      color: HexColor.fromHex("94F0F1"),
                                      dummyType: ProfileDummyType.Image,
                                      scale: 3.0,
                                      image: selectedImagePath ??
                                          "assets/dummy-profile.png",
                                    ),
                                    Visibility(
                                      visible: selectedImagePath == null,
                                      child: Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .primaryAccentColor
                                                  .withOpacity(0.75),
                                              shape: BoxShape.circle),
                                          child: const Icon(FeatherIcons.camera,
                                              color: Colors.white, size: 20)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 30),
                      LabelledFormInput(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The name can not be Empty";
                            }
                            if (regExnumbers.hasMatch(value) ||
                                regEx2.hasMatch(value)) {
                              return "The name can not contain Numbers Or Symbols ";
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            setState(() {
                              name = value;
                            });
                          },
                          onClear: () {
                            setState(() {
                              name = "";
                              _nameController.text = "";
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: "Name",
                          keyboardType: "text",
                          controller: _nameController,
                          obscureText: obscureText,
                          label: "Your Name"),
                      const SizedBox(height: 15),
                      LabelledFormInput(
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              if (isTakean) {
                                return "Please use another userName";
                              }
                            }
                            return null;
                          },
                          onClear: () {
                            setState(() {
                              userName = "";
                              _userNameController.text = "";
                            });
                          },
                          onChanged: (value) async {
                            setState(() {
                              userName = value;
                            });
                            if (await TopController().existByOne(
                                collectionReference: usersRef,
                                value: userName,
                                field: userNameK)) {
                              setState(() {
                                isTakean = true;
                              });
                            } else {
                              setState(() {
                                isTakean = false;
                              });
                            }
                            // setState(() {
                            //   isTakean;
                            // });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: "UserName",
                          keyboardType: "text",
                          controller: _userNameController,
                          obscureText: obscureText,
                          label: "Your UserName"),
                      const SizedBox(height: 15),
                      LabelledFormInput(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "The password should be more then 7 character";
                            }
                            if (regExletters.hasMatch(value) == false) {
                              return "please enter at least one small character";
                            }
                            if (regExnumbers.hasMatch(value) == false) {
                              return "please enter at least one Number";
                            }
                            if (regExbigletters.hasMatch(value) == false) {
                              return "please enter at least one big character";
                            }
                            return null;
                          },
                          onClear: (() {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          }),
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: "Password",
                          keyboardType: "text",
                          controller: _passController,
                          obscureText: obscureText,
                          label: "Your Password"),
                      const SizedBox(height: 15),
                      LabelledFormInput(
                          validator: (value) {
                            if (password.isNotEmpty && confirm != password) {
                              return "the password did not match";
                            }
                            return null;
                          },
                          onClear: () {
                            setState(() {
                              confirm = "";
                              _confirmPassController.text = "";
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              confirm = value;
                            });
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          readOnly: false,
                          placeholder: "Confirm",
                          keyboardType: "text",
                          controller: _confirmPassController,
                          obscureText: obscureText,
                          label: "confirm Password"),
                      const SizedBox(height: 40),
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
                                User? user = AuthService
                                    .instance.firebaseAuth.currentUser;
                                if (user != null) {
                                  await AuthService.instance.firebaseAuth
                                      .signOut();
                                }
                                if (selectedImagePath != null) {
                                  String? imagePathNetWork = "";
                                  final resOfUpload = await uploadImageToStorge(
                                      selectedImagePath: selectedImagePath!,
                                      imageName: name,
                                      folder: "Users");
                                  resOfUpload.fold((left) {
                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                    // return;
                                  }, (right) {
                                    right.then((value) async {
                                      imagePathNetWork = value;
                                      UserModel userModel = UserModel(
                                        userNameParameter:
                                            userName.isEmpty ? null : userName,
                                        nameParameter: name,
                                        imageUrlParameter: imagePathNetWork!,
                                        idParameter: usersRef.doc().id,
                                        createdAtParameter: DateTime.now(),
                                        updatedAtParameter: DateTime.now(),
                                      );
                                      await AuthService()
                                          .createUserWithEmailAndPassword(
                                              userModel: userModel,
                                              email: widget.email,
                                              password: password);
                                      Navigator.of(context).pop();
                                    });
                                  });
                                } else {
                                  UserModel userModel = UserModel(
                                    emailParameter: widget.email,
                                    nameParameter: name,
                                    userNameParameter:
                                        userName.isEmpty ? null : userName,
                                    imageUrlParameter: defaultUserImageProfile,
                                    idParameter: usersRef.doc().id,
                                    createdAtParameter: DateTime.now(),
                                    updatedAtParameter: DateTime.now(),
                                  );
                                  var authserviceDone = await AuthService()
                                      .createUserWithEmailAndPassword(
                                          userModel: userModel,
                                          email: widget.email,
                                          password: password);
                                  authserviceDone.fold((left) {
                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                  },
                                      (right) => {
                                            Navigator.of(context).pop(),
                                            CustomSnackBar.showSuccess(
                                                "Welcome in our team \n Plans to do team happy in you ")
                                          });
                                }
                                Get.to(() => const VerifyEmailAddressScreen());
                              } on Exception catch (e) {
                                Navigator.of(context).pop();
                                CustomSnackBar.showError(e.toString());
                              }
                            }
                            dev.log("message");
                          },
                          style: ButtonStyles.blueRounded,
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.lato(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        )
      ]),
    );
  }

  String? selectedImagePath;
  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose an Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Cancel'),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value == null) {
        // Handle the case where the user did not choose a photo
        // Display a message or perform any required actions
      }
    });
  }

  void _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImagePath = pickedFile.path;
      });
    }
  }
}
