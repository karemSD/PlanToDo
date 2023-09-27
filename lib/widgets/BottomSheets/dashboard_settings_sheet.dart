import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Values/values.dart';

import '../Buttons/primary_buttons.dart';
import '../Buttons/text_button.dart';
import '../Onboarding/toggle_option.dart';
import 'bottom_sheet_holder.dart';

class DashboardSettingsBottomSheet extends StatelessWidget {
  final ValueNotifier<bool> totalTaskNotifier;
  final ValueNotifier<bool> totalCompletedNotifier;
  final ValueNotifier<bool> totalworkingOnNotifier;
  final ValueNotifier<bool> totalCategoriesTrigger;
  final ValueNotifier<bool> totalTeamsTrigger;
  final ValueNotifier<bool> totalProjectsTrigger;
  final ValueNotifier<bool> totalTaskToDoTrigger;

  const DashboardSettingsBottomSheet(
      {Key? key,
      required this.totalTaskNotifier,
      required this.totalCompletedNotifier,
      required this.totalworkingOnNotifier,
      required this.totalCategoriesTrigger,
      required this.totalProjectsTrigger,
      required this.totalTeamsTrigger,
      required this.totalTaskToDoTrigger})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const BottomSheetHolder(),
                    ToggleLabelOption(
                      label: 'Task To Do Today',
                      notifierValue: totalTaskToDoTrigger,
                      icon: Icons.check_circle_outline,
                    ),
                    ToggleLabelOption(
                      label: 'Total Task',
                      notifierValue: totalTaskNotifier,
                      icon: Icons.check_circle_outline,
                    ),
                    ToggleLabelOption(
                      label: 'Total Categories',
                      notifierValue: totalCategoriesTrigger,
                      icon: Icons.check_circle_outline,
                    ),
                    ToggleLabelOption(
                      label: 'Total teams',
                      notifierValue: totalTeamsTrigger,
                      icon: Icons.check_circle_outline,
                    ),
                    ToggleLabelOption(
                      label: 'Total Projects',
                      notifierValue: totalProjectsTrigger,
                      icon: Icons.check_circle_outline,
                    ),
                    ToggleLabelOption(
                      label: 'Completed',
                      notifierValue: totalCompletedNotifier,
                      icon: Icons.check_circle,
                    ),
                    ToggleLabelOption(
                      label: 'Working On',
                      notifierValue: totalworkingOnNotifier,
                      icon: Icons.flag,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextButton(
                            buttonText: 'Clear All',
                            buttonSize: 16,
                            callback: () {
                              totalworkingOnNotifier.value = false;
                              totalTaskNotifier.value = false;
                              totalCategoriesTrigger.value = false;
                              totalCompletedNotifier.value = false;
                              totalTeamsTrigger.value = false;
                              totalProjectsTrigger.value = false;
                            },
                          ),
                          AppPrimaryButton(
                            buttonHeight: 60,
                            buttonWidth: 160,
                            buttonText: 'Select All',
                            callback: () {
                              totalTaskNotifier.value = true;
                              totalCategoriesTrigger.value = true;
                              totalCompletedNotifier.value = true;
                              totalTeamsTrigger.value = true;
                              totalProjectsTrigger.value = true;
                              totalworkingOnNotifier.value = true;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
