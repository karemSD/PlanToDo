// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mytest/Screens/Dashboard/selectMyTeams.dart';
import 'package:mytest/constants/app_constans.dart';
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
import '../../controllers/user_task_controller.dart';
import '../../models/User/User_task_Model.dart';
import '../../models/statusmodel.dart';
import '../../models/task/UserTaskCategory_model.dart';
import '../../models/team/TeamMembers_model.dart';
import '../../services/collectionsrefrences.dart';
import '../../widgets/BottomSheets/bottom_sheet_holder.dart';
import '../../widgets/Dashboard/dashboard_meeting_details.dart';
import '../../widgets/Forms/form_input_with _label.dart';
import '../../widgets/Snackbar/custom_snackber.dart';
import '../../widgets/User/new_sheet_goto_calender.dart';
import '../../widgets/add_sub_icon.dart';
import '../../widgets/dummy/profile_dummy.dart';
import 'addTeamToCreateProjectScre.dart';

// ignore: must_be_immutable
class CreateProject extends StatefulWidget {
  CreateProject({
    required this.managerModel,
    Key? key,
    required this.isEditMode,
  }) : super(key: key);

  final bool isEditMode;
  ManagerModel? managerModel;
  UserTaskModel? userTaskModel;

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  String? selectedImagePath;
  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppConstants.choose_an_image_key.tr),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(AppConstants.camera_key.tr),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text(AppConstants.gallery_key.tr),
                  onTap: () {
                    _getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text(AppConstants.cancel_key.tr),
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

    formattedStartDate = formatDateTime(startDate);
    formattedDueDate = formatDateTime(dueDate);
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
  bool isTaked = false;
  bool noChangeOnTime = false;
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
                        ? ImageType.Assets
                        : ImageType.File,
                    color: HexColor.fromHex("94F0F1"),
                    dummyType: ProfileDummyType.Image,
                    scale: Utils.screenWidth *
                        0.0077, // Adjust the percentage as needed
                    image: selectedImagePath ?? "assets/projectImage.jpg",
                  ),
                  Visibility(
                    visible: selectedImagePath == null,
                    child: Container(
                      width: Utils.screenWidth *
                          0.310, // Adjust the percentage as needed
                      height: Utils.screenWidth * 0.310,
                      decoration: BoxDecoration(
                          color: AppColors.primaryAccentColor.withOpacity(0.75),
                          shape: BoxShape.circle),
                      child: Icon(FeatherIcons.camera,
                          color: Colors.white, size: Utils.screenWidth * 0.06),
                    ),
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
                  GetBuilder<AddTeamToCreatProjectScreen>(
                    init: AddTeamToCreatProjectScreen(),
                    builder: (controller) => Text(
                      controller.teams.isEmpty
                          ? AppConstants.choose_team_key.tr
                          : controller.teams.first.name!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Utils.screenWidth *
                              0.05, // Adjust the percentage as needed
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot<TeamModel?>?>(
                      stream: TeamController().getTeamsOfUserStream(
                          userId: AuthService
                              .instance.firebaseAuth.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return GetBuilder<AddTeamToCreatProjectScreen>(
                            init: AddTeamToCreatProjectScreen(),
                            builder: (controller) {
                              if (controller.teams.isEmpty) {
                                return buildStackedImagesOfTeams(
                                    addMore: true,
                                    numberOfMembers: 0.toString(),
                                    onTap: () {
                                      Get.to(() => SelectMyTeamScreen(
                                          title:
                                              AppConstants.choose_team_key.tr));
                                      print("object2");
                                    },
                                    teams: <TeamModel?>[]);
                              } else {
                                return Obx(
                                  () => buildStackedImagesTeamEdit(
                                      addMore: false),
                                );
                              }
                            },
                          );
                        }

                        if (snapshot.hasData) {
                          return GetBuilder<AddTeamToCreatProjectScreen>(
                            init: AddTeamToCreatProjectScreen(),
                            builder: (controller) {
                              if (controller.teams.isEmpty) {
                                return buildStackedImagesOfTeams(
                                    addMore: true,
                                    numberOfMembers:
                                        snapshot.data!.docs.length.toString(),
                                    onTap: () {
                                      Get.to(() => SelectMyTeamScreen(
                                          title:
                                              AppConstants.choose_team_key.tr));
                                      print("object2");
                                    },
                                    teams: snapshot.data?.docs
                                        .map((doc) => doc.data())
                                        .toList());
                              } else {
                                return Obx(
                                  () => buildStackedImagesTeamEdit(
                                      addMore: false),
                                );
                              }
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ],
              ),
              AppSpaces.verticalSpace10,
              Row(
                children: [
                  AppSpaces.horizontalSpace20,
                  Expanded(
                    child: LabelledFormInput(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppConstants.name_can_not_be_empty_key.tr;
                        }
                        if (value.isNotEmpty) {
                          if (isTaked) {
                            return AppConstants
                                .please_use_another_project_name_key.tr;
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
                        setState(() {
                          name = value;
                        });
                        if (widget.managerModel != null) {
                          print("dasdasd");
                          if (await projectController.existByTow(
                              reference: projectsRef,
                              value: name,
                              field: nameK,
                              field2: managerIdK,
                              value2: widget.managerModel!.id)) {
                            setState(() {
                              isTaked = true;
                            });
                          } else {
                            setState(() {
                              isTaked = false;
                            });
                          }
                        } else {
                          setState(() {
                            isTaked = false;
                          });
                        }
                      },
                      label: AppConstants.name_key.tr,
                      readOnly: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      placeholder: AppConstants.project_name_key.tr,
                      keyboardType: "text",
                      controller: _projectNameController,
                      obscureText: false,
                    ),
                  ),
                ],
              ),
              AppSpaces.verticalSpace20,
              LabelledFormInput(
                validator: (p0) {
                  if (p0!.isEmpty) {
                    return AppConstants
                        .description_cannot_be_empty_spaces_key.tr;
                  }
                  return null;
                },
                onChanged: (p0) {
                  setState(() {
                    desc = p0;
                  });
                },
                onClear: () {
                  setState(() {
                    desc = "";
                    _projectDescController.text = "";
                  });
                },
                label: AppConstants.description_key.tr,
                readOnly: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                placeholder: AppConstants.project_description_key.tr,
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
                  label: AppConstants.start_date_key.tr,
                ),
                NewSheetGoToCalendarWidget(
                  onSelectedDayChanged: handleDueDayChanged,
                  selectedDay: dueDate,
                  cardBackgroundColor: HexColor.fromHex("BA67A3"),
                  textAccentColor: HexColor.fromHex("BA67A3"),
                  value: formattedDueDate,
                  label: AppConstants.due_date_validation_key.tr,
                )
              ]),
              // Spacer(),
              AppSpaces.verticalSpace20,
              AppSpaces.verticalSpace20,
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AddSubIcon(
                  icon: const Icon(Icons.add, color: Colors.white),
                  scale: 1,
                  color: AppColors.primaryAccentColor,
                  callback: () async {
                    print("fdasfasd");
                    if (formKey.currentState!.validate()) {
                      if (addTeamToCreatProjectScreen.teams.isNotEmpty) {
                        showDialogMethod(context);
                        await addProject();
                        Navigator.of(context).pop();
                      } else {
                        CustomSnackBar.showError(
                            AppConstants.choose_team_first_for_project_key.tr);
                      }
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
      return "${AppConstants.today_key.tr} ${DateFormat('h:mma').format(dateTime)}";
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

  Future<void> addProject() async {
    name = name.trim();
    desc = desc.trim();
    if (startDate.isAfter(dueDate) ||
        startDate.isAtSameMomentAs(dueDate) ||
        startDate.isBefore(
          firebaseTime(
            DateTime.now().add(const Duration(minutes: 2)),
          ),
        )) {
      print("step 1");
      CustomSnackBar.showError(AppConstants
          .start_date_cannot_be_after_end_date_or_in_the_same_time_or_before_the_current_date_key
          .tr);
      return;
    }
    print("step2");
    if (widget.isEditMode == false) {
      try {
        print("creteing");
        StatusController statusController = Get.put(StatusController());
        StatusModel statusModel =
            await statusController.getStatusByName(status: statusNotDone);
        print(statusModel.createdAt);
        // if (widget.managerModel == null) {
        //   widget.managerModel = ManagerModel(
        //       idParameter: managersRef.doc().id,
        //       userIdParameter:
        //           AuthService.instance.firebaseAuth.currentUser!.uid,
        //       createdAtParameter: DateTime.now(),
        //       updatedAtParameter: DateTime.now());
        //   await managerController.addManger(widget.managerModel!);
        // }
        // setState(() {
        //   startDate = DateTime.now();
        // });
        if (selectedImagePath != null) {
          String? imagePathNetWork = "";
          final resOfUpload = await uploadImageToStorge(
            selectedImagePath: selectedImagePath!,
            imageName: name,
            folder: AppConstants.projects_key.tr,
          );
          resOfUpload.fold((left) {
            Navigator.of(context).pop();
            print(left.toString());
            CustomSnackBar.showError("${left.toString()} ");
            return;
          }, (right) async {
            right.then((value) async {
              imagePathNetWork = value;
              ProjectModel projectModel = ProjectModel(
                  managerIdParameter: widget.managerModel!.id,
                  teamIdParameter: addTeamToCreatProjectScreen.teams.first.id,
                  imageUrlParameter: imagePathNetWork!,
                  descriptionParameter: desc,
                  idParameter: projectsRef.doc().id,
                  nameParameter: name,
                  stausIdParameter: statusModel.id,
                  createdAtParameter: DateTime.now(),
                  updatedAtParameter: DateTime.now(),
                  startDateParameter: startDate,
                  endDateParameter: dueDate);
              print("creteing3");
              await projectController.addProject(projectModel: projectModel);
              if (mounted) {
                Navigator.of(context).pop();
              }
              CustomSnackBar.showSuccess(
                  "${AppConstants.create_project_key.tr} $name ${AppConstants.completed_successfully_key.tr}");
            });
          });
        } else {
          ProjectModel projectModel = ProjectModel(
              managerIdParameter: widget.managerModel!.id,
              teamIdParameter: addTeamToCreatProjectScreen.teams.first.id,
              imageUrlParameter: defaultProjectImage,
              descriptionParameter: desc,
              idParameter: projectsRef.doc().id,
              nameParameter: name,
              stausIdParameter: statusModel.id,
              createdAtParameter: DateTime.now(),
              updatedAtParameter: DateTime.now(),
              startDateParameter: startDate,
              endDateParameter: dueDate);
          print("creteing3");
          await projectController.addProject(projectModel: projectModel);
          Navigator.of(context).pop();
          CustomSnackBar.showSuccess(
              "${AppConstants.create_project_key.tr} $name ${AppConstants.completed_successfully_key.tr} ");
        }
        //  Get.key.currentState!.pop();
      } catch (e) {
        print("error");
        print(e.toString());
        CustomSnackBar.showError(e.toString());
      }
    } else {
      // await userTaskController.(data: {
      //   nameK: name,
      //   descriptionK: desc,
      //   colorK: "color",
      //   importanceK: selectedDashboardOption,
      //   startDateK: startDate,
      //   endDateK: dueDate
      // }, id: widget.userTaskModel!.id);
      // CustomSnackBar.showSuccess("task $name Updated successfully");
      // Get.key.currentState!.pop();
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
