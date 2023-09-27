import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Screens/Task/task_due_date.dart';
import '../../Values/values.dart';
import 'new_task_due_date.dart';

class NewSheetGoToCalendarWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color cardBackgroundColor;
  DateTime selectedDay;
  final Function(DateTime) onSelectedDayChanged;
  final Color textAccentColor;
  NewSheetGoToCalendarWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.cardBackgroundColor,
    required this.textAccentColor,
    required this.selectedDay,
    required this.onSelectedDayChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
            () => NewTaskDueDate(
                  title: label,
                  selectedDay: selectedDay,
                  onSelectedDayChanged: onSelectedDayChanged,
                ),
            fullscreenDialog: true);
      },
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircularCalendarCard(color: cardBackgroundColor),
        AppSpaces.horizontalSpace10,
        CircularCardLabel(
          label: label,
          value: value,
          color: textAccentColor,
        )
      ]),
    );
  }
}

class CircularCalendarCard extends StatelessWidget {
  final Color color;
  const CircularCalendarCard({
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = Get.width;
    final isSmallScreen = maxWidth < 600;
    return Container(
        width: isSmallScreen ? 40 : 60,
        height: isSmallScreen ? 40 : 60,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: const Icon(Icons.calendar_today, color: Colors.white));
  }
}

class CircularCardLabel extends StatelessWidget {
  final String? label;
  final String? value;
  final Color? color;
  const CircularCardLabel({
    Key? key,
    this.label,
    this.color,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = Get.width;
    final isSmallScreen = maxWidth < 600;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpaces.verticalSpace10,
          Text(label!,
              style: GoogleFonts.lato(
                  fontSize: isSmallScreen ? 13 : 16,
                  color: HexColor.fromHex("626777"))),
          Text(value!,
              style: GoogleFonts.lato(
                  fontSize: isSmallScreen ? 13 : 16, color: color))
        ]);
  }
}
