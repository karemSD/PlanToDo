import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Values/values.dart';
import '../widgets/BottomSheets/project_detail_sheet.dart';

class TaskezBottomSheet {
  // static const MethodChannel _channel = MethodChannel('taskezBottomSheet');
}

showSettingsBottomSheet() =>
    showAppBottomSheet(const ProjectDetailBottomSheet());

showAppBottomSheet(Widget widget,
    {bool isScrollControlled = false,
    bool popAndShow = false,
    double? height}) {
  if (popAndShow) Get.back();
  return Get.bottomSheet(
      height == null ? widget : SizedBox(height: height, child: widget),
      backgroundColor: AppColors.primaryBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isScrollControlled: isScrollControlled);
}
