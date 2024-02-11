import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/language_widget.dart';
import '../constants/app_constans.dart';
import '../controllers/languageController.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});
  static const String id = "/LanguagePage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return Column(
          children: [
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(5),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            widthFactor: 120,
                            child: Image.asset("assets/images/logo.png"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(AppConstants.select_language_key.tr),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 1),
                              itemCount: 2,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => LanguageWidget(
                                  languageModel:
                                      localizationController.languages[index],
                                  localizationController:
                                      localizationController,
                                  index: index)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      })),
    );
  }
}
// the Developer karem saad (KaremSD) 