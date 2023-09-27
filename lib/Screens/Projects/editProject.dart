// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mytest/Screens/Dashboard/selectMyTeams.dart';
import 'package:mytest/controllers/manger_controller.dart';
import 'package:mytest/controllers/projectController.dart';
import 'package:mytest/controllers/teamController.dart';
import 'package:mytest/controllers/team_member_controller.dart';
import 'package:mytest/models/team/Manger_model.dart';
import 'package:mytest/models/team/Project_model.dart';
import 'package:mytest/models/team/Team_model.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/utils/back_utils.dart';

import '../../Values/values.dart';
import '../../constants/back_constants.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/statusController.dart';
import '../../controllers/topController.dart';
import '../../controllers/userController.dart';
import '../../controllers/user_task_controller.dart';
import '../../models/User/User_model.dart';
import '../../models/User/User_task_Model.dart';
import '../../models/statusmodel.dart';
import '../../models/task/UserTaskCategory_model.dart';
import '../../models/team/TeamMembers_model.dart';
import '../../services/collectionsrefrences.dart';
import '../../widgets/BottomSheets/bottom_sheet_holder.dart';
import '../../widgets/Forms/form_input_with _label.dart';
import '../../widgets/Snackbar/custom_snackber.dart';
import '../../widgets/Team/show_team_members.dart';
import '../../widgets/User/new_sheet_goto_calender.dart';
import '../../widgets/add_sub_icon.dart';
import '../../widgets/dummy/profile_dummy.dart';
import 'addTeamToCreateProjectScre.dart';

class STX extends GetxController {
  RxBool isTaked = false.obs;
  updateIsTaked(bool s) {
    isTaked.value = s;
    update();
  }
}

// ignore: must_be_immutable
class EditProject extends StatefulWidget {
  EditProject({
    required this.userAsManager,
    required this.teamModel,
    required this.projectModel,
    Key? key,
  }) : super(key: key);

  ProjectModel projectModel;
  TeamModel teamModel;
  ManagerModel userAsManager;
  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  STX stx = Get.put(STX());
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

  final AddTeamToCreatProjectScreen addTeamToCreatProjectScreen =
      Get.find<AddTeamToCreatProjectScreen>();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();
  int? selectedDashboardOption;
  List<TeamMemberModel> membersList = [];
  String? teamMemberId;
  @override
  void initState() {
    super.initState();
    widget.projectModel.startDate = firebaseTime(widget.projectModel.startDate);
    widget.projectModel.endDate = firebaseTime(widget.projectModel.endDate!);
    startDate = widget.projectModel.startDate;
    dueDate = widget.projectModel.endDate!;

    formattedStartDate = formatDateTime(widget.projectModel.startDate);
    formattedDueDate = formatDateTime(widget.projectModel.endDate!);
    name = widget.projectModel.name!;
    _projectNameController.text = widget.projectModel.name!;
    desc = widget.projectModel.description!;
    _projectDescController.text = widget.projectModel.description!;
  }

  @override
  void dispose() {
    super.dispose();
    addTeamToCreatProjectScreen.teams.clear();
  }

  String formattedStartDate = "";
  String formattedDueDate = "";
  void onChanged(String value) async {}

  DateTime startDate = DateTime.now();

  DateTime dueDate = DateTime.now();
  ProjectController projectController = Get.put(ProjectController());
  TeamController teamController = Get.put(TeamController());
  TeamMemberController teamMemberController = Get.put(TeamMemberController());
  ManagerController managerController = Get.put(ManagerController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String name = "";
  String desc = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(children: [
          AppSpaces.verticalSpace10,
          const BottomSheetHolder(),
          AppSpaces.verticalSpace20,
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
                    image: selectedImagePath ?? widget.projectModel.imageUrl,
                  ),
                  Visibility(
                    visible: selectedImagePath == null,
                    child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            color:
                                AppColors.primaryAccentColor.withOpacity(0.75),
                            shape: BoxShape.circle),
                        child: const Icon(FeatherIcons.camera,
                            color: Colors.white, size: 20)),
                  )
                ],
              ),
            );
          }),
          AppSpaces.verticalSpace10,
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppSpaces.verticalSpace10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StreamBuilder<DocumentSnapshot<TeamModel>>(
                    stream: TeamController()
                        .getTeamByIdStream(id: widget.projectModel.teamId!),
                    builder: (context, snapshotTeam) {
                      return Text(
                        snapshotTeam.data!.data()!.name!,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot<TeamMemberModel>>(
                      stream: TeamMemberController().getMembersInTeamIdStream(
                          teamId: widget.projectModel.teamId!),
                      builder: (context, snapshotMembers) {
                        List<String> listIds = [];
                        if (snapshotMembers.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshotMembers.hasData) {
                          print("objectsdsad");
                          if (snapshotMembers.data!.docs.isNotEmpty) {
                            print("objectsdsadxczxczxcxzczxc");
                            for (var member in snapshotMembers.data!.docs) {
                              listIds.add(member.data().userId);
                            }
                          }
                          if (listIds.isEmpty) {
                            return buildStackedImages(
                              addMore: true,
                              numberOfMembers: 0.toString(),
                              users: <UserModel>[],
                              onTap: () {
                                print("dasdasd");
                              },
                            );
                          }
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
                        }
                        return Container();
                      }),
                ],
              ),
              AppSpaces.verticalSpace10,
              Row(
                children: [
                  AppSpaces.horizontalSpace20,
                  Expanded(
                    child: GetBuilder<STX>(
                      init: STX(),
                      builder: (controller) => LabelledFormInput(
                        ///  value: name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name Can not be Empty";
                          }
                          if (value.isNotEmpty) {
                            if (controller.isTaked.value) {
                              return "Please use another project name";
                            }
                          }
                          return null;
                        },
                        onClear: () {
                          setState(() {
                            name = "";
                            _projectNameController.text = "";
                          });
                        },
                        onChanged: (value) async {
                          //setState(() {
                          name = value;
                          //     });

                          print("dasdasd");
                          if (await projectController.existByTow(
                                  reference: projectsRef,
                                  value: name,
                                  field: nameK,
                                  field2: managerIdK,
                                  value2: widget.projectModel.managerId) &&
                              name != widget.projectModel.name) {
                            controller.updateIsTaked(true);
                            print(stx.isTaked.value);
                            //   controller.isTaked.value = true;
                          } else {
                            controller.updateIsTaked(false);
                            print(stx.isTaked.value);
                            // controller.isTaked.value = false;
                          }
                        },
                        label: "Name",
                        readOnly: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        placeholder: "Project Name ....",
                        keyboardType: "text",
                        controller: _projectNameController,
                        obscureText: false,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              LabelledFormInput(
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return "description cannot be empty spaces";
                  }
                  return null;
                },
                onChanged: (p0) {
                  // setState(() {
                  print(p0);
                  desc = p0;
                  //});
                },
                onClear: () {
                  //setState(() {
                  desc = "";
                  _projectDescController.text = "";
                  //  });
                },
                label: "Description",
                readOnly: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                placeholder: "Project Description ....",
                keyboardType: "text",
                controller: _projectDescController,
                obscureText: false,
              ),
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                NewSheetGoToCalendarWidget(
                  selectedDay: startDate,
                  onSelectedDayChanged: handleStartDayChanged,
                  cardBackgroundColor: HexColor.fromHex("7DBA67"),
                  textAccentColor: HexColor.fromHex("A9F49C"),
                  value: formattedStartDate,
                  label: 'Start Date',
                ),
                NewSheetGoToCalendarWidget(
                  onSelectedDayChanged: handleDueDayChanged,
                  selectedDay: dueDate,
                  cardBackgroundColor: HexColor.fromHex("BA67A3"),
                  textAccentColor: HexColor.fromHex("BA67A3"),
                  value: formattedDueDate,
                  label: 'Due Date',
                )
              ]),
              // Spacer(),
              AppSpaces.verticalSpace20,
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AddSubIcon(
                  
                  scale: 1,
                  color: AppColors.primaryAccentColor,
                  callback: () async {
                    print("fdasfasd");
                    if (formKey.currentState!.validate()) {
                      showDialogMethod(context);
                      await updateProjecr();
                      Navigator.of(context).pop();
                    }
                    print("sadsda");
                  },
                ),
              ])
            ]),
          ),
        ]),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return "Today ${DateFormat('h:mma').format(dateTime)}";
    } else {
      return DateFormat('dd/MM h:mma').format(dateTime);
    }
  }

  void handleDueDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      dueDate = selectedDay;
      formattedDueDate = formatDateTime(dueDate);
    });
  }

  void handleStartDayChanged(DateTime selectedDay) {
    setState(() {
      // Update the selectedDay variable in the first screen
      print("${selectedDay}the selected day");
      startDate = selectedDay;
      formattedStartDate = formatDateTime(startDate);
    });
  }

  Future<void> updateProjecr() async {
    name = name.trim();
    desc = desc.trim();

    if (startDate != widget.projectModel.startDate ||
        dueDate != widget.projectModel.endDate) {
      if (startDate.isAfter(dueDate) || startDate.isAtSameMomentAs(dueDate)) {
        print("step 1");
        CustomSnackBar.showError(
            "start date cannot be After end date Or in tha same Time");
        return;
      }
    }

    print("step2");

    try {
      print(name);
      print(desc);
      print(dueDate);
      print(startDate);
      if (name != widget.projectModel.name ||
          desc != widget.projectModel.description ||
          startDate != widget.projectModel.startDate ||
          dueDate != widget.projectModel.endDate) {
        print("creteing");
        await ProjectController().updateProject(
            managerModel: widget.userAsManager,
            oldProject: widget.projectModel,
            data: {
              nameK: name,
              descriptionK: desc,
              startDateK: startDate,
              endDateK: dueDate,
            },
            id: widget.projectModel.id);
        CustomSnackBar.showSuccess("Projec $name Updated successfully");
        Get.key.currentState!.pop();
      } else {
        CustomSnackBar.showError("No Chages to Update");
      }
    } catch (e) {
      print("error");
      CustomSnackBar.showError(e.toString());
    }
  }
}

class BottomSheetIcon extends StatelessWidget {
  final IconData icon;
  const BottomSheetIcon({
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      iconSize: 32,
      onPressed: null,
    );
  }
}
