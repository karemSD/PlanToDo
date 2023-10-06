import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_constans.dart';

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
