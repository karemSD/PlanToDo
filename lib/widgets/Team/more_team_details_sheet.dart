import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/topController.dart';
import 'package:mytest/controllers/userController.dart';
import 'package:mytest/models/User/User_model.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/services/collectionsrefrences.dart';
import 'package:mytest/utils/back_utils.dart';
import 'package:mytest/widgets/Buttons/primary_buttons.dart';
import 'package:mytest/widgets/Buttons/primary_tab_buttons.dart';
import 'package:mytest/widgets/Snackbar/custom_snackber.dart';

import '../../Values/values.dart';
import '../../controllers/team_member_controller.dart';
import '../../models/team/TeamMembers_model.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../Buttons/primary_progress_button.dart';
import '../Dashboard/dashboard_meeting_details.dart';
import '../Forms/form_input_with _label.dart';
import '../container_label.dart';
import '../dummy/profile_dummy.dart';
import 'show_team_members.dart';

class MoreTeamDetailsSheet extends StatefulWidget {
  final TeamModel teamModel;
  final ManagerModel? userAsManager;
  const MoreTeamDetailsSheet(
      {Key? key, required this.userAsManager, required this.teamModel})
      : super(key: key);

  @override
  State<MoreTeamDetailsSheet> createState() => _MoreTeamDetailsSheetState();
}

class _MoreTeamDetailsSheetState extends State<MoreTeamDetailsSheet> {
  TextEditingController teamNameController = TextEditingController();
  String name = "";
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.teamModel.name!.trim();
    teamNameController.text = widget.teamModel.name!.trim();
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

  @override
  Widget build(BuildContext context) {
    final managerNameController = TextEditingController();

    String name = "";
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              _showImagePickerDialog(context);
              //  dev.log("message");
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
                  image: selectedImagePath ?? widget.teamModel.imageUrl,
                ),
                Visibility(
                  visible: selectedImagePath == null,
                  child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: AppColors.primaryAccentColor.withOpacity(0.75),
                          shape: BoxShape.circle),
                      child: const Icon(FeatherIcons.camera,
                          color: Colors.white, size: 20)),
                )
              ],
            ),
          );
        }),
        AppSpaces.horizontalSpace10,
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot<UserModel>>(
                  stream: UserController().getUserWhereMangerIsStream(
                      mangerId: widget.teamModel.managerId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return LabelledFormInput(
                        autovalidateMode: AutovalidateMode.disabled,
                        readOnly: true,
                        placeholder: snapshot.data!.data()!.name!,
                        keyboardType: "text",
                        value: snapshot.data!.data()!.name!,
                        controller: managerNameController,
                        obscureText: false,
                        label: "Team Mangaer");
                  }),
              AppSpaces.verticalSpace20,
              Form(
                key: formKey,
                child: LabelledFormInput(
                    onClear: () {
                      name = "";
                      teamNameController.text = "";
                    },
                    validator: (p0) {
                      if (p0!.isEmpty) {
                        return "the name of team should not be empty";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      //  print("object");

                      name = value;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    readOnly: false,
                    placeholder: widget.teamModel.name!,
                    keyboardType: "text",
                    controller: teamNameController,
                    obscureText: false,
                    label: "TEAM NAME"),
              ),
              AppSpaces.verticalSpace20,
              const ContainerLabel(label: "Members"),
              AppSpaces.verticalSpace10,
              Transform.scale(
                alignment: Alignment.centerLeft,
                scale: 0.7,
                child: StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                    stream: TeamMemberController()
                        .getMembersInTeamIdStream(teamId: widget.teamModel.id),
                    builder: (context, snapshotMembers) {
                      List<String> listIds = [];
                      if (snapshotMembers.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshotMembers.data!.docs.isEmpty) {
                        return buildStackedImages(
                          addMore: true,
                          numberOfMembers: 0.toString(),
                          users: <UserModel>[],
                          onTap: () {
                            Get.to(() => ShowTeamMembers(
                                  teamModel: widget.teamModel,
                                  userAsManager: widget.userAsManager,
                                ));
                            print("dasdasd");
                          },
                        );
                      }

                      for (var member in snapshotMembers.data!.docs) {
                        listIds.add(member.data().userId);
                      }
                      // if (listIds.isEmpty) {
                      //   return buildStackedImages(
                      //     addMore: true,
                      //     numberOfMembers: 0.toString(),
                      //     users: <UserModel>[],
                      //     onTap: () {
                      //       print("dasdasd");
                      //     },
                      //   );
                      // }

                      return StreamBuilder<QuerySnapshot<UserModel>>(
                          stream: UserController()
                              .getUsersWhereInIdsStream(usersId: listIds),
                          builder: (context, snapshotUsers) {
                            if (snapshotUsers.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            List<UserModel> users = [];
                            for (var element in snapshotUsers.data!.docs) {
                              users.add(element.data());
                            }
                            return buildStackedImages(
                                onTap: () {
                                  Get.to(() => ShowTeamMembers(
                                        teamModel: widget.teamModel,
                                        userAsManager: widget.userAsManager,
                                      ));
                                },
                                users: users,
                                numberOfMembers: users.length.toString(),
                                addMore: true);
                          });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrimaryProgressButton(
                    height: 50,
                    width: 150,
                    label: "Edit Team",
                    callback: () async {
                      if (formKey.currentState!.validate()) {
                        name = name.trim();
                        if (selectedImagePath != null) {
                          showDialogMethod(context);
                          print("start");
                          final resOfUpload = await uploadImageToStorge(
                              selectedImagePath: selectedImagePath!,
                              imageName: widget.teamModel.name!,
                              folder: "Teams");
                          resOfUpload.fold((left) {
                            Get.key.currentState!.pop();
                            CustomSnackBar.showError("${left.toString()} ");
                          }, (right) async {
                            right.then((value) async{
                                  String imageNetWork= value!;
                                await TeamController().updateTeam(
                              widget.teamModel.id, {imageUrlK: imageNetWork});
                          Get.key.currentState!.pop();
                            });
                          });
                        }
                        if (name != widget.teamModel.name) {
                          showDialogMethod(context);

                          bool res = await TopController().existByTow(
                              reference: teamsRef,
                              value: name,
                              field: nameK,
                              value2: widget.teamModel.managerId,
                              field2: managerIdK);
                          if (res) {
                            Navigator.of(context).pop();
                            CustomSnackBar.showError(
                                "There is a team has the same name in your teams  ");
                          } else {
                            await TeamController()
                                .updateTeam(widget.teamModel.id, {nameK: name});
                            Navigator.of(context).pop();
                          }
                          Get.key.currentState!.pop();
                        }
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
