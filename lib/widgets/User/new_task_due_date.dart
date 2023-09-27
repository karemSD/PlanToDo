// import 'dart:async';
// import 'package:day_night_time_picker/lib/constants.dart';
// import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
// import 'package:day_night_time_picker/lib/state/time.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import '../../Values/values.dart';
// import '../../widgets/Buttons/primary_progress_button.dart';
// import '../../widgets/DarkBackground/darkRadialBackground.dart';
// import '../../widgets/Navigation/app_header.dart';
// import '../../widgets/table_calendar.dart';
// import 'new_table_cal.dart';

// class NewTaskDueDate extends StatefulWidget {
//   NewTaskDueDate(
//       {Key? key,
//       required this.selectedDay,
//       required this.onSelectedDayChanged,
//       required this.title})
//       : super(key: key);
//   static String id = "/TaskDueDateScreen";
//   DateTime selectedDay;
//   String title;
//   final Function(DateTime) onSelectedDayChanged;
//   @override
//   State<NewTaskDueDate> createState() => _NewTaskDueDateState();
// }

// class _NewTaskDueDateState extends State<NewTaskDueDate> {
//   Time? _time;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _time =
//         Time(hour: widget.selectedDay.hour, minute: widget.selectedDay.minute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           DarkRadialBackground(
//             color: HexColor.fromHex("#181a1f"),
//             position: "topLeft",
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 60.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20, left: 20),
//                   child: TaskezAppHeader(
//                       title: widget.title, widget: const SizedBox()),
//                 ),
//                 const SizedBox(height: 40),
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     decoration: BoxDecorationStyles.fadingGlory,
//                     child: Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: DecoratedBox(
//                         decoration: BoxDecorationStyles.fadingInnerDecor,
//                         child: Padding(
//                           padding: const EdgeInsets.all(20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               NewCalendarView(
//                                   selectedDay: widget.selectedDay,
//                                   onSelectedDayChanged:
//                                       widget.onSelectedDayChanged),
//                               AppSpaces.verticalSpace20,
//                               Container(
//                                 width: double.infinity,
//                                 height: 120,
//                                 decoration: BoxDecoration(
//                                     color: AppColors.primaryBackgroundColor,
//                                     borderRadius: BorderRadius.circular(20)),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         Navigator.of(context).push(
//                                           showPicker(
//                                             themeData: ThemeData.dark(),
//                                             context: context,
//                                             value: _time!,
//                                             onChange: (value) {},
//                                             minuteInterval:
//                                                 TimePickerInterval.FIVE,
//                                             // Optional onChange to receive value as DateTime
//                                             onChangeDateTime:
//                                                 (DateTime dateTime) {
//                                               setState(() {
//                                                 widget.selectedDay = DateTime(
//                                                   widget.selectedDay.year,
//                                                   widget.selectedDay.month,
//                                                   widget.selectedDay.day,
//                                                   dateTime.hour,
//                                                   dateTime.minute,
//                                                 );
//                                                 print(widget.selectedDay);
//                                                 widget.onSelectedDayChanged(
//                                                     widget.selectedDay);
//                                               });
//                                             },
//                                           ),
//                                         );
//                                       },
//                                       child: ConditionText(
//                                           label: "Due Time",
//                                           color: HexColor.fromHex("BE5EF6"),
//                                           value: DateFormat('h:mm a')
//                                               .format(widget.selectedDay)),
//                                     ),
//                                     // AppSpaces.horizontalSpace20,
//                                     // Container(
//                                     //     width: 0.3,
//                                     //     color: HexColor.fromHex("686C7D"),
//                                     //     height: double.infinity),
//                                     AppSpaces.horizontalSpace20,
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: 50,
//             child: Container(
//               padding: const EdgeInsets.only(left: 40, right: 20),
//               width: Utils.screenWidth,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text('Cancel',
//                         style: GoogleFonts.lato(
//                             color: HexColor.fromHex("F49189"),
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold)),
//                     PrimaryProgressButton(
//                       width: Get.width > 600 ? 110 : 120,
//                       height: Get.height > 500 ? 70 : 90,
//                       label: "Done",
//                       callback: () {
//                         Get.back();
//                       },
//                     )
//                   ]),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class ConditionText extends StatelessWidget {
//   final String label;
//   final String value;
//   final Color color;
//   const ConditionText({
//     required this.label,
//     required this.value,
//     required this.color,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20.0, bottom: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(label,
//               style: GoogleFonts.lato(
//                   fontSize: 16, color: HexColor.fromHex("686C7D"))),
//           AppSpaces.verticalSpace10,
//           Text(value,
//               style: GoogleFonts.lato(
//                   color: color, fontSize: 20, fontWeight: FontWeight.bold))
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:day_night_time_picker/lib/state/time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../Values/values.dart';
import '../../widgets/Buttons/primary_progress_button.dart';
import '../../widgets/DarkBackground/darkRadialBackground.dart';
import '../../widgets/Navigation/app_header.dart';
import '../../widgets/table_calendar.dart';
import 'new_table_cal.dart';

class NewTaskDueDate extends StatefulWidget {
  NewTaskDueDate({
    Key? key,
    required this.selectedDay,
    required this.onSelectedDayChanged,
    required this.title,
  }) : super(key: key);
  static String id = "/TaskDueDateScreen";
  DateTime selectedDay;
  String title;
  final Function(DateTime) onSelectedDayChanged;
  @override
  State<NewTaskDueDate> createState() => _NewTaskDueDateState();
}

class _NewTaskDueDateState extends State<NewTaskDueDate> {
  Time? _time;
  DateTime? t;
  @override
  void initState() {
    t = widget.selectedDay;
    super.initState();
    _time =
        Time(hour: widget.selectedDay.hour, minute: widget.selectedDay.minute);
  }

  onDay(DateTime tt) {
    t = tt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DarkRadialBackground(
            color: HexColor.fromHex("#181a1f"),
            position: "topLeft",
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: TaskezAppHeader(
                      title: widget.title,
                      widget: const SizedBox(),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    // Adjust the height as needed
                    decoration: BoxDecorationStyles.fadingGlory,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: DecoratedBox(
                        decoration: BoxDecorationStyles.fadingInnerDecor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              NewCalendarView(
                                selectedDay: t!,
                                onSelectedDayChanged: onDay,
                              ),
                              AppSpaces.verticalSpace20,
                              Container(
                                width: double.infinity,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBackgroundColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          showPicker(
                                            ltrMode: true,
                                            themeData: ThemeData.dark(),
                                            context: context,
                                            value: _time!,
                                            onChange: (value) {
                                              setState(() {
                                                t = DateTime(
                                                  t!.year,
                                                  t!.month,
                                                  t!.day,
                                                  value.hour,
                                                  value.minute,
                                                );
                                                _time = Time(
                                                    hour: t!.hour,
                                                    minute: t!.minute);
                                              });
                                            },
                                            minuteInterval:
                                                TimePickerInterval.FIVE,
                                          ),
                                        );
                                      },
                                      child: ConditionText(
                                        label: "Due Time",
                                        color: HexColor.fromHex("BE5EF6"),
                                        value: DateFormat('h:mm a').format(t!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppSpaces.verticalSpace20,
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 20),
                                width: Utils.screenWidth,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.lato(
                                          color: HexColor.fromHex("F49189"),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    PrimaryProgressButton(
                                      width: Get.width > 600 ? 110 : 120,
                                      height: Get.height > 500 ? 70 : 90,
                                      label: "Done",
                                      callback: () {
                                        // print(widget.selectedDay);
                                        // print(t);
                                        widget.onSelectedDayChanged(t!);
                                        Get.back();
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConditionText extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const ConditionText({
    required this.label,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 16,
              color: HexColor.fromHex("686C7D"),
            ),
          ),
          AppSpaces.verticalSpace10,
          Text(
            value,
            style: GoogleFonts.lato(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
