////////////////
// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mytest/Screens/Projects/searchForMembers.dart';
import 'package:mytest/controllers/manger_controller.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/waitingMamberController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/models/team/waitingMamber.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/utils/back_utils.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';
import 'dart:developer' as dev;
import '../../Screens/Projects/addUserToTeamScreenController.dart';

import '../../Values/values.dart';
import '../../services/auth_service.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../BottomSheets/bottom_sheet_selectable_container.dart';
import '../Buttons/primary_buttons.dart';
import '../Forms/form_input_with _label.dart';
import '../dummy/profile_dummy.dart';

import 'in_bottomsheet_subtitle.dart';

class DashboardMeetingDetails extends StatefulWidget {
  static List<UserModel?>? users = <UserModel?>[];
  const DashboardMeetingDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardMeetingDetails> createState() =>
      _DashboardMeetingDetailsState();
}

class _DashboardMeetingDetailsState extends State<DashboardMeetingDetails> {
  String teamName = "";
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

  TextEditingController teamNameCobtroller = TextEditingController();
  final DashboardMeetingDetailsScreenController userController =
      Get.find<DashboardMeetingDetailsScreenController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void clearUsers() {
    userController.users.clear();
    print("object");
  }

  @override
  @override
  void dispose() {
    clearUsers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex("#181a1f"),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppSpaces.verticalSpace10,
                      const BottomSheetHolder(),
                      AppSpaces.verticalSpace20,
                      Builder(builder: (context) {
                        return GestureDetector(
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
                                    "assets/defaultGroup.png",
                              ),
                              Visibility(
                                visible: selectedImagePath == null,
                                child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryAccentColor
                                            .withOpacity(0.75),
                                        shape: BoxShape.circle),
                                    child: const Icon(FeatherIcons.camera,
                                        color: Colors.white, size: 20)),
                              )
                            ],
                          ),
                        );
                      }),
                      AppSpaces.verticalSpace10,
                      InBottomSheetSubtitle(
                        title: teamName.isEmpty ? "Team Name" : teamName,
                        alignment: Alignment.center,
                        textStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.w600,
                          fontSize: 26,
                          color: Colors.white,
                        ),
                      ),
                      AppSpaces.verticalSpace10,
                      const InBottomSheetSubtitle(
                        title: "Tap the logo to upload new file",
                        alignment: Alignment.center,
                      ),
                      AppSpaces.verticalSpace20,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: LabelledFormInput(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Team Name Should be not Empty";
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            readOnly: false,
                            onClear: () {
                              setState(() {
                                teamNameCobtroller.clear();
                                teamName = "";
                              });
                            },
                            onChanged: (value) {
                              setState(() {
                                teamName = value;
                                // teamNameCobtroller.text = value;
                              });
                            },
                            placeholder: "Enter the Name of Team",
                            keyboardType: "text",
                            controller: teamNameCobtroller,
                            obscureText: false,
                            label: "Team  Name"),
                      ),
                      AppSpaces.verticalSpace20,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            print("object");
                            Get.to(() => SearchForMembers(
                                  newTeam: true,
                                  users: DashboardMeetingDetails.users,
                                ));
                          },
                          child: LabelledSelectableContainer(
                            label: "Member",
                            value: "Select Members",
                            icon: Icons.add,
                            valueColor: AppColors.primaryAccentColor,
                          ),
                        ),
                      ),
                      AppSpaces.verticalSpace20,
                      Obx(
                        () => buildStackedImagesKaremEdit(),
                      ),
                      AppSpaces.verticalSpace40,
                      AppPrimaryButton(
                        buttonHeight: 50,
                        buttonWidth: 180,
                        buttonText: "Create New Team",
                        callback: () async {
                          teamName = teamName.trim();
                          if (formKey.currentState!.validate()) {
                            try {
                              if (userController.users.isEmpty) {
                                CustomSnackBar.showError(
                                    "Please choose one member at leaset to make a Team ");
                              } else {
                                showDialogMethod(context);
                                ManagerModel managerModel =
                                    await ManagerController()
                                        .getManagerOrMakeOne(
                                            userId: AuthService.instance
                                                .firebaseAuth.currentUser!.uid);
                                if (selectedImagePath != null) {
                                  String? imagePathNetWork = "";
                                  final resOfUpload = await uploadImageToStorge(
                                      selectedImagePath: selectedImagePath!,
                                      imageName: teamName,
                                      folder: "Teams");

                                  resOfUpload.fold((left) {
                                    Navigator.of(context).pop();

                                    CustomSnackBar.showError(
                                        "${left.toString()} ");
                                    return;
                                  }, (right) async {
                                    right.then((value) async {
                                      imagePathNetWork = value;
                                      TeamModel teamModel = TeamModel(
                                        idParameter: teamsRef.doc().id,
                                        managerIdParameter: managerModel.id,
                                        nameParameter: teamName,
                                        imageUrlParameter: imagePathNetWork!,
                                        createdAtParameter: DateTime.now(),
                                        updatedAtParameter: DateTime.now(),
                                      );
                                      await createTheTeam(teamModel: teamModel);
                                      Navigator.of(context).pop();

                                      CustomSnackBar.showSuccess(
                                          "Creating team ${teamModel.name} completed successfully ");
                                    });
                                  });
                                } else {
                                  TeamModel teamModel = TeamModel(
                                      idParameter: teamsRef.doc().id,
                                      managerIdParameter: managerModel.id,
                                      nameParameter: teamName,
                                      imageUrlParameter: defaultProjectImage,
                                      createdAtParameter: DateTime.now(),
                                      updatedAtParameter: DateTime.now());
                                  await createTheTeam(teamModel: teamModel);
                                  Navigator.of(context).pop();

                                  CustomSnackBar.showSuccess(
                                      "Creating team ${teamModel.name} completed successfully ");
                                }

                                dev.log("message Ysss");
                                Get.close(1);
                              }
                            } on Exception catch (e) {
                              CustomSnackBar.showError(e.toString());
                            }
                          } else {
                            print("Not vadsd");
                          }
                        },
                      ),
                      AppSpaces.verticalSpace20,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

EitherException<Future<String?>> uploadImageToStorge({
  required String selectedImagePath,
  required String imageName,
  required String folder,
}) async {
  try {
    Random random = Random();
    int number = random.nextInt(10000000);

    final Reference reference =
        firebaseStorage.ref().child("images/$folder/$number$imageName.png");
    final UploadTask uploadTask = reference.putFile(File(selectedImagePath));

    TaskSnapshot snapshot = await uploadTask;
    if (snapshot.state == TaskState.success) {
      final String downloadURL = await reference.getDownloadURL();
      print('Image download URL: $downloadURL');
      // Handle the completion of the upload
      print('Upload complete');
      return Right(Future.value(downloadURL)); // Return Right for success case
    } else {
      print('Image upload failed');
      return Left(
          Exception('Image upload failed')); // Return Left for failure case
    }
  } catch (error) {
    print('Image upload error: $error');
    return Left(Exception(
        'Image upload error: ${error.toString()}}')); // Return Left for any exception/error
  }
}

createTheTeam({required TeamModel teamModel}) async {
  await TeamController().addTeam(teamModel);
  for (var user in userController.users) {
    WaitingMemberModel waitingMemberModel = WaitingMemberModel(
        idParameter: watingMamberRef.doc().id,
        userIdParameter: user.id,
        teamIdParameter: teamModel.id,
        createdAtParameter: DateTime.now(),
        updatedAtParameter: DateTime.now());

    await WaitingMamberController()
        .addWaitingMamber(waitingMemberModel: waitingMemberModel);
  }
}
