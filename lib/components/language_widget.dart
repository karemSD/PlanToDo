import 'package:flutter/material.dart';

import '../constants/app_constans.dart';
import '../controllers/languageController.dart';
import '../models/lang/lang.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  const LanguageWidget({super.key, required this.languageModel, required this.localizationController,
    required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        localizationController.setLanguage(locale: Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index: index);
        
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 5, spreadRadius: 1)],
        ),
        child: Stack(children: [

          Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(height: 5),
              Text(languageModel.languageName!, ),
            ]),
          ),

          localizationController.selectedIndex == index ? Positioned(
            top: 0, right: 0, left: 0, bottom: 40,
            child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 25),
          ) : const SizedBox(),

        ]),
      ),
    );
  }
}// the Developer karem saad (KaremSD) 