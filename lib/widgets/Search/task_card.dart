import 'package:flutter/material.dart';

import '../../Values/values.dart';
import 'active_task_card.dart';
import 'inactive_task_card.dart';

class SearchTaskCard extends StatelessWidget {
  final bool activated;
  final String header;
  final String subHeader;
  final String date;
  const SearchTaskCard(
      {Key? key,
      required this.date,
      required this.activated,
      required this.header,
      required this.subHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool newBool = activated;
    ValueNotifier<bool> totalDueTrigger = ValueNotifier(newBool);

    return ValueListenableBuilder(
        valueListenable: totalDueTrigger,
        builder: (BuildContext context, _, __) {
          return totalDueTrigger.value
              ? Column(children: [
                  InactiveTaskCard(
                      header: header,
                      notifier: totalDueTrigger,
                      subHeader: subHeader,
                      date: date),
                  AppSpaces.verticalSpace10
                ])
              : Column(children: [
                  ActiveTaskCard(
                      onPressedEnd: (p0) {},
                      onPressedStart: (p0) {},
                      imageUrl: "",
                      header: header,
                      notifier: totalDueTrigger,
                      subHeader: subHeader,
                      date: date),
                  AppSpaces.verticalSpace10
                ]);
        });
  }
}
