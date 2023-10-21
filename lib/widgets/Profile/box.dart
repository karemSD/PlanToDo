import 'package:flutter/material.dart';

import '../../Values/values.dart';
import '../../controllers/languageController.dart';
import '../../models/lang/lang.dart';

// ignore: must_be_immutable
class Box extends StatelessWidget {
  final String label;
  final String value;
  final String badgeColor;
  final Color? iconColor;
  final String iconpath;
  final VoidCallback? callback;
  LanguageModel? languageModel;
  LocalizationController? localizationController;
  int? index;

  Box(
      {Key? key,
      this.languageModel,
      this.localizationController,
      this.index,
      required this.iconColor,
      required this.iconpath,
      required this.label,
      required this.value,
      required this.badgeColor,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Container(
        width: double.infinity,
        height: Utils.screenHeight * 0.19,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: AppColors.primaryBackgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: Utils.screenWidth * 0.11,
              height: Utils.screenHeight * 0.11,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                iconpath,
                color: iconColor,
              )),
          // AppSpaces.horizontalSpace20,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              label,
              style: TextStyle(
                  fontSize: Utils.screenWidth * 0.05, color: Colors.white),
            ),
          )
        ]),
      ),
    );
  }
}
