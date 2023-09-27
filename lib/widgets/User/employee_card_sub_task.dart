import 'package:flutter/material.dart';

import 'active_employee_card_sub_task.dart';

import 'inactive_employee_card_sub_task.dart';

class EmployeeCardSubTask extends StatelessWidget {
  final String Name;
  final String Image;
  final String bio;
  final Color backgroundColor;
  final bool activated;
  const EmployeeCardSubTask(
      {Key? key,
      required this.Name,
      required this.Image,
      required this.backgroundColor,
      required this.bio,
      required this.activated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool newBool = activated;
    ValueNotifier<bool> totalDueTrigger = ValueNotifier(newBool);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ValueListenableBuilder(
          valueListenable: totalDueTrigger,
          builder: (BuildContext context, _, __) {
            return Container(
                child: totalDueTrigger.value
                    ? ActiveEmployeeCardSubTask(
                        color: backgroundColor,
                        notifier: totalDueTrigger,
                        userImage: Image,
                        userName: Name,
                        bio: bio)
                    : InactiveEmployeeCardSubTask(
                        onTap: null,
                        color: backgroundColor,
                        notifier: totalDueTrigger,
                        userImage: Image,
                        userName: Name,
                        bio: bio));
          }),
    );
  }
}
