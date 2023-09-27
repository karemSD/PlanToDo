import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/constants/back_constants.dart';
import 'package:mytest/controllers/categoryController.dart';
import 'package:mytest/widgets/Dashboard/select_color_dialog.dart';

import '../../Values/values.dart';
import '../../models/task/UserTaskCategory_model.dart';
import '../BottomSheets/bottom_sheet_holder.dart';
import '../Forms/form_input_with _label.dart';
import '../Snackbar/custom_snackber.dart';
import '../add_sub_icon.dart';
import 'icon_selection.dart';

class EditUserCategory extends StatefulWidget {
  final UserTaskCategoryModel category;

  EditUserCategory({
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  _EditUserCategoryState createState() => _EditUserCategoryState();
}

class _EditUserCategoryState extends State<EditUserCategory> {
  final TextEditingController _taskNameController = TextEditingController();
  String color = "";
  IconData icon = Icons.home;
  String name = "";

  @override
  void initState() {
    super.initState();
    color = widget.category.hexColor;
    icon = IconData(widget.category.iconCodePoint,
        fontFamily: widget.category.fontfamily);
    name = widget.category.name!;
    _taskNameController.text = name;
  }

  void onChanged(String value) {
    setState(() {
      name = value;
    });
  }

  void handleColorChanged(String selectedColor) {
    setState(() {
      color = selectedColor;
    });
  }

  void handleIconChanged(IconData selectedIcon) {
    setState(() {
      icon = selectedIcon;
    });
  }

  Future<void> _editCategory() async {
    try {
      TaskCategoryController taskCategoryController =
          Get.put(TaskCategoryController());
      await taskCategoryController.updateCategory(data: {
        fontFamilyK: icon.fontFamily,
        iconK: icon.codePoint,
        colorK: color,
        nameK: name,
        createdAtK: widget.category.createdAt,
        updatedAtK: DateTime.now(),
      }, id: widget.category.id);
      CustomSnackBar.showSuccess("Category $name updated successfully");
      await Future.delayed(const Duration(seconds: 1));
      Get.key.currentState!.pop();
    } catch (e) {
      CustomSnackBar.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppSpaces.verticalSpace10,
            const BottomSheetHolder(),
            AppSpaces.verticalSpace10,
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        ),
                      ),
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
                            color: HexColor.fromHex(color),
                          ),
                        ),
                      ),
                      AppSpaces.horizontalSpace20,
                      Expanded(
                        child: LabelledFormInput(
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              // Add your validation logic here
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
                          label: "Name",
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
                  AppSpaces.verticalSpace20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AddSubIcon(
                        scale: 1,
                        color: AppColors.primaryAccentColor,
                        callback: () async {
                          await _editCategory();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
