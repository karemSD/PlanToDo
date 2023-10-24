import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytest/Values/values.dart';
import 'package:mytest/services/auth_service.dart';
import 'package:mytest/widgets/Buttons/primary_buttons.dart';
import 'package:mytest/widgets/dummy/profile_dummy.dart';

import '../../constants/app_constans.dart';
import '../Forms/form_input_with _label.dart';

class CustomSnackBar {
  static void showSuccess(String message) {
    Get.snackbar(
      boxShadows: [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      AppConstants.success_key.tr,
      message,
      backgroundColor: Colors.greenAccent.withOpacity(.65),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  static void showError(String message) {
    Get.snackbar(
      boxShadows: [
        BoxShadow(
          blurStyle: BlurStyle.outer,
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 4),
        ),
      ],
      AppConstants.error_key.tr,
      " $message ${AppConstants.please_Try_Again_key.tr} ",
      // AppConstants.error_key.tr,
      // //'Error',
      // "${AppConstants.SomeThing_Wrong_happened_key.tr} \n  $message ${AppConstants.please_Try_Again_key.tr} ",
      duration: const Duration(seconds: 20),
      backgroundColor: Colors.red.withOpacity(.65),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}

class CustomDialog {
  static void showPasswordDialog(BuildContext context) {
    final Rx<TextEditingController> passController =
        TextEditingController().obs;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String password = "";
    RegExp regExletters = RegExp(r"(?=.*[a-z])\w+");
    RegExp regExnumbers = RegExp(r"(?=.*[0-9])\w+");
    RegExp regExbigletters = RegExp(r"(?=.*[A-Z])\w+");
    final RxBool obscureText = false.obs;
    Get.defaultDialog(
        backgroundColor: AppColors.primaryBackgroundColor,
        title: AppConstants.enter_new_password_key.tr,
        titleStyle: const TextStyle(color: Colors.white),
        content: Form(
          key: formKey,
          child: Column(
            children: [
              LabelledFormInput(
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return AppConstants
                          .the_password_should_be_more_then_7_character_key.tr;
                    }
                    if (regExletters.hasMatch(value) == false) {
                      return AppConstants
                          .please_enter_at_least_one_small_character_key.tr;
                    }
                    if (regExnumbers.hasMatch(value) == false) {
                      return AppConstants
                          .please_enter_at_least_one_number_key.tr;
                    }
                    if (regExbigletters.hasMatch(value) == false) {
                      return AppConstants
                          .please_enter_at_least_one_big_character_key.tr;
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
                  placeholder: AppConstants.password_key.tr,
                  keyboardType: "text",
                  controller: passController.value,
                  obscureText: obscureText.value,
                  label: AppConstants.your_password_key.tr),
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
                      //dev.log("Password Updated ");
                      CustomSnackBar.showSuccess(
                          AppConstants.password_updated_successfully_key.tr);
                      Get.back();
                    });
                  }
                } on Exception catch (e) {
                  Navigator.of(context).pop();

                  CustomSnackBar.showError(e.toString());
                }
              },
              buttonText: AppConstants.change_password_key.tr,
              buttonHeight: 50,
              buttonWidth: 110),
        ));
  }

  static void userInfoDialog(
      {required String imageUrl,
      required String name,
      required String userName,
      String? title,
      String? bio}) {
    Get.defaultDialog(
      radius: 50,
      backgroundColor: AppColors.primaryBackgroundColor.withOpacity(.8),
      contentPadding: const EdgeInsets.all(0),
      titleStyle: const TextStyle(color: Colors.grey),
      titlePadding: title == null
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(vertical: 5),
      title: title ?? "",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileDummy(
              color: Colors.white,
              scale: 2.5,
              dummyType: ProfileDummyType.Image,
              imageType: ImageType.Network,
              image: imageUrl
              //'assets/dummy-profile.png',
              ),
          Text(name, style: AppTextStyles.header2),
          AppSpaces.verticalSpace20,
          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Expanded(
                child: Text(
                  overflow: TextOverflow.clip,
                  bio ?? AppConstants.empty_bio_key.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              AppSpaces.horizontalSpace20,
            ],
          ),
          AppSpaces.verticalSpace10,

          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                AppConstants.bio_key.tr,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              )
            ],
          ),
          AppSpaces.verticalSpace10,

          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                "# $userName",
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
          AppSpaces.verticalSpace10,

          Row(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaces.horizontalSpace20,
              Text(
                " ${AppConstants.user_name_key.tr}",
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold),
              )
            ],
          )

          // Add your custom content widgets here
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle button action
            Get.back(); // Close the dialog
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  static void showConfirmDeleteDialog(
      {required Text content, required VoidCallback onDelete}) {
    Get.defaultDialog(
        backgroundColor: Colors.white,
        title: AppConstants.confirm_delete_key.tr,
        titleStyle: const TextStyle(color: Colors.redAccent),
        content: content,
        textConfirm: AppConstants.delete_key.tr,
        textCancel: AppConstants.cancel_key.tr,
        confirmTextColor: Colors.white.withOpacity(.5),
        confirm: ClipOval(
          child: MaterialButton(
            color: Colors.white.withOpacity(.5),
            onPressed: onDelete,
            child: Text(
              AppConstants.cancel_key.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        radius: 10,
        cancel: ClipOval(
          child: MaterialButton(
            color: Colors.white.withOpacity(.5),
            onPressed: () {
              // Perform delete operation
              // ...

              Get.back();
            },
            child: Text(
              AppConstants.cancel_key.tr,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ));
  }
}
