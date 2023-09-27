// ignore_for_file: avoid_print

import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytest/Screens/Onboarding/onboarding_carousel.dart';
import 'package:mytest/Screens/Profile/my_profile.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/widgets/Buttons/primary_buttons.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';

import '../../Values/values.dart';
import '../../widgets/Buttons/primary_progress_button.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Dashboard/dashboard_meeting_details.dart';
import '../../widgets/Forms/form_input_with _label.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/dummy/profile_dummy.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? user;
  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "";
  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");

  RegExp regEx2 = RegExp(r'[^\w\d\u0600-\u06FF\s]');
  String password = "";
  String userName = "";
  String bio = "";
  String email = "";
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  final passController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.user!.name!;
    nameController.text = widget.user!.name!;
    userName = widget.user!.userName ?? "";
    userNameController.text = widget.user!.userName ?? "";
    bio = widget.user!.bio ?? "";
    bioController.text = widget.user!.bio ?? "";
    email = widget.user!.email ?? "";
    emailController.text = widget.user!.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    const String tabSpace = "\t\t\t";

    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TaskezAppHeader(
                        title: "$tabSpace Edit Profile",
                        widget: PrimaryProgressButton(
                          callback: () async {
                            try {
                              bool pop = false;
                              bool changes = false;
                              print(name.trim());
                              if (formKey.currentState!.validate()) {
                                showDialogMethod(context);

                                if (selectedImagePath != null) {
                                  showDialogMethod(context);
                                  print("start");
                                  final resOfUpload = await uploadImageToStorge(
                                      selectedImagePath: selectedImagePath!,
                                      imageName: AuthService.instance
                                          .firebaseAuth.currentUser!.uid,
                                      folder: "Users");
                                  resOfUpload.fold((left) {
                                    Get.key.currentState!.pop();
                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                  }, (right) async {
                                    right.then((value) async {
                                      String imageNetWork = value!;
                                      await UserController().updateUser(
                                          id: AuthService.instance.firebaseAuth
                                              .currentUser!.uid,
                                          data: {imageUrlK: imageNetWork});
                                      Get.key.currentState!.pop();
                                    });
                                  });
                                }

                                if (name.trim() != widget.user!.name) {
                                  name = name.trim();
                                  await UserController().updateUser(
                                      data: {nameK: name}, id: widget.user!.id);
                                  changes = true;
                                }
                                if (userName.isNotEmpty &&
                                    userName.trim() != widget.user!.userName) {
                                  userName = userName.trim();
                                  await UserController().updateUser(
                                      data: {userNameK: userName},
                                      id: widget.user!.id);
                                  changes = true;
                                  // UserName field has been updated
                                  // Perform the necessary action
                                }

                                if (bio.isNotEmpty &&
                                    bio.trim() != widget.user!.bio) {
                                  bio = bio.trim();
                                  await UserController().updateUser(
                                      data: {bioK: bio}, id: widget.user!.id);
                                  changes = true;
                                  // Bio field has been updated
                                  // Perform the necessary action
                                }

                                if (email.isNotEmpty &&
                                    email.trim() != widget.user!.email) {
                                  email = email.trim();
                                  var emailupdate = await AuthService.instance
                                      .updateEmail(email: email);

                                  emailupdate.fold((left) async {
                                    CustomSnackBar.showError(left.toString());
                                  }, (right) async {
                                    print(email);
                                    print(emailController.text);
                                    print("email");
                                    await UserController().updateUser(
                                        data: {emailK: email},
                                        id: widget.user!.id);
                                    print("email2");
                                    pop = true;
                                    Navigator.of(context).pop();
                                    CustomSnackBar.showSuccess(
                                        "Email updated successfully ..Please Login and verify the new Email ");
                                    AuthService.instance.logOut();
                                    changes = true;
                                    Get.offAll(
                                        () => const OnboardingCarousel());
                                    return;
                                  });

                                  // Email field has been updated
                                  // Perform the necessary action
                                }
                                if (!pop) {
                                  Navigator.of(context).pop();
                                  Get.off(
                                      () => ProfilePage(user: widget.user!));
                                }
                                if (changes) {
                                  CustomSnackBar.showSuccess(
                                      "Update completed successfully");
                                }
                                // else {
                                //   CustomSnackBar.showError(
                                //       "No Any Changes happend to update");
                                // }
                              }
                            } on Exception catch (e) {
                              Navigator.of(context).pop();
                              CustomSnackBar.showError(e.toString());
                            }
                          },
                          width: 80,
                          height: 40,
                          label: "Save",
                          textStyle: GoogleFonts.lato(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Column(
                        children: [
                          Builder(builder: (context) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _showImagePickerDialog(context);
                                    },
                                    child: Stack(
                                      children: [
                                        ProfileDummy(
                                          imageType: selectedImagePath == null
                                              ? ImageType.Network
                                              : ImageType.File,
                                          color: HexColor.fromHex("94F0F1"),
                                          dummyType: ProfileDummyType.Image,
                                          scale: 3.0,
                                          image: selectedImagePath ??
                                              widget.user!.imageUrl,
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
                                            child: const Icon(
                                                FeatherIcons.camera,
                                                color: Colors.white,
                                                size: 20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                          AppSpaces.verticalSpace20,
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
                                  nameController.text = "";
                                });
                              },
                              autovalidateMode: AutovalidateMode.always,
                              readOnly: false,
                              placeholder: widget.user!.name!,
                              keyboardType: "text",
                              controller: nameController,
                              obscureText: false,
                              label: "Your Name"),
                          AppSpaces.verticalSpace20,
                          LabelledFormInput(
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                });
                              },
                              onClear: () {
                                setState(() {
                                  userName = "";
                                  userNameController.text = "";
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              readOnly: false,
                              placeholder: widget.user!.userName == null
                                  ? ""
                                  : widget.user!.userName!,
                              keyboardType: "text",
                              controller: userNameController,
                              obscureText: false,
                              label: "Your UserName"),
                          AppSpaces.verticalSpace20,
                          Visibility(
                            visible: !AuthService
                                .instance.firebaseAuth.currentUser!.isAnonymous,
                            child: LabelledFormInput(
                                validator: (value) {
                                  if (!EmailValidator.validate(value!)) {
                                    return "Enter Valid Email";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                onClear: () {
                                  setState(() {
                                    email = "";
                                    emailController.text = "";
                                  });
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                readOnly: false,
                                placeholder: widget.user!.email == null
                                    ? ""
                                    : widget.user!.email!,
                                keyboardType: "text",
                                controller: emailController,
                                obscureText: false,
                                label: "Your Email"),
                          ),
                          AppSpaces.verticalSpace20,
                          LabelledFormInput(
                              onChanged: (value) {
                                bio = value;
                              },
                              onClear: () {
                                bio = "";
                                bioController.text = "";
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              readOnly: false,
                              placeholder: widget.user!.bio == null
                                  ? ""
                                  : widget.user!.bio!,
                              keyboardType: "text",
                              controller: bioController,
                              obscureText: true,
                              label: "Bio"),
                        ],
                      ),
                      Visibility(
                        visible: !AuthService
                            .instance.firebaseAuth.currentUser!.isAnonymous,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: AppPrimaryButton(
                              callback: () {
                                showPasswordDialog(context);
                              },
                              buttonText: "Change Password",
                              buttonHeight: 50,
                              buttonWidth: 175),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
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

void showPasswordDialog(BuildContext context) {
  final Rx<TextEditingController> passController = TextEditingController().obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String password = "";
  RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
  RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
  RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
  final RxBool obscureText = false.obs;
  Get.defaultDialog(
      backgroundColor: AppColors.primaryBackgroundColor,
      title: 'Enter The New Password',
      titleStyle: const TextStyle(color: Colors.white),
      content: Form(
        key: formKey,
        child: Column(
          children: [
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
                  obscureText.value = !obscureText.value;
                }),
                onChanged: (value) {
                  password = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                readOnly: false,
                placeholder: "Password",
                keyboardType: "text",
                controller: passController.value,
                obscureText: obscureText.value,
                label: "Your Password"),
            const SizedBox(height: 15),
          ],
        ),
      ),
      cancel: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: AppPrimaryButton(
            callback: () async {
              try {
                if (formKey.currentState!.validate()) {
                  showDialogMethod(context);
                  var updatePassword = AuthService.instance
                      .updatePassword(newPassword: password);
                  updatePassword.fold((left) {
                    Navigator.of(context).pop();
                    CustomSnackBar.showError(left.toString());
                  }, (right) {
                    Navigator.of(context).pop();

                    CustomSnackBar.showSuccess(
                        "password updated successfully ");
                    Get.back();
                  });
                }
              } on Exception catch (e) {
                Navigator.of(context).pop();
                CustomSnackBar.showError(e.toString());
              }
            },
            buttonText: "Change Password",
            buttonHeight: 40,
            buttonWidth: 110),
      ));
}
