import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mytest/widgets/Dashboard/select_color_dialog.dart';
import '../../Values/values.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/user_task_controller.dart';
import '../../models/task/UserTaskCategory_model.dart';

import '../../services/auth_service.dart';
import '../../services/collectionsrefrences.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../Forms/form_input_with _label.dart';
import '../Snackbar/custom_snackber.dart';
import '../add_sub_icon.dart';
import 'icon_selection.dart';

// ignore: must_be_immutable
class CreateUserCategory extends StatefulWidget {
  CreateUserCategory({
    Key? key,
  }) : super(key: key);
  @override
  State<CreateUserCategory> createState() => _CreateUserCategoryState();
}

class _CreateUserCategoryState extends State<CreateUserCategory> {
  final TextEditingController _taskNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void onChanged(String value) async {
    name = value;
    // if (await TopController().existByTow(
    //     reference: usersRef,
    //     value: name,
    //     field: nameK,
    //     field2: categoryIdK,
    //     value2: widget.userTaskCategoryModel.id)) {
    //   isTaked = true;
    // } else {
    //   isTaked = false;
    // }
    // setState(() {
    //   isTaked;
    // });
  }

  String color = "#FDA7FF";
  UserTaskController userTaskController = Get.put(UserTaskController());
  TaskCategoryController taskCategoryController =
      Get.put(TaskCategoryController());
  IconData icon = Icons.home;
  bool isTaked = false;
  String name = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        AppSpaces.verticalSpace10,
        const BottomSheetHolder(),
        AppSpaces.verticalSpace10,
        Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return IconSelectionDialog(
                            onSelectedIconChanged: handleIconChanged,
                            initialIcon: icon,
                          );
                        },
                      );
                    },
                    child: Icon(
                      icon,
                      color: HexColor.fromHex(color),
                    )),
              ],
            ),
            AppSpaces.verticalSpace10,
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ColorSelectionDialog(
                          onSelectedColorChanged: handleColorChanged,
                          initialColor: color,
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: HexColor.fromHex(color)),
                  ),
                ),
                AppSpaces.horizontalSpace20,
                Expanded(
                  child: LabelledFormInput(
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (isTaked) {
                          return "Please use another CategoryName";
                        }
                      }
                      return null;
                    },
                    onClear: () {
                      setState(() {
                        name = "";
                        _taskNameController.text = "";
                      });
                    },
                    onChanged: onChanged,
                    label: "",
                    readOnly: false,
                    autovalidateMode: AutovalidateMode.always,
                    placeholder: "Category Name ....",
                    keyboardType: "text",
                    controller: _taskNameController,
                    obscureText: false,
                  ),
                ),
              ],
            ),

            // Spacer(),
            AppSpaces.verticalSpace20,
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              AddSubIcon(
                scale: 1,
                color: AppColors.primaryAccentColor,
                callback: () async {
                  await _addCategory();
                },
              ),
            ])
          ]),
        ),
      ]),
    );
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.color = selectedColor;
    });
  }

  void handleIconChanged(IconData selectedIcon) {
    setState(() {
      // Update the selectedDay variable in the first screen
      this.icon = selectedIcon;
    });
  }

  Future<void> _addCategory() async {
    try {
      UserTaskCategoryModel userTaskModel = UserTaskCategoryModel(
        fontfamilyParameter: icon.fontFamily,
        iconCodePointParameter: icon.codePoint,
        hexColorParameter: color,
        userIdParameter:AuthService.instance. firebaseAuth.currentUser!.uid,
        idParameter: usersTasksRef.doc().id,
        nameParameter: name,
        createdAtParameter: DateTime.now(),
        updatedAtParameter: DateTime.now(),
      );
      await taskCategoryController.addCategory(userTaskModel);
      CustomSnackBar.showSuccess("Category $name added successfully");

      await Future.delayed(
          const Duration(seconds: 1)); // Delay closing the widget
      Get.key.currentState!.pop();
    } catch (e) {
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
