import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytest/widgets/Projects/project_badge.dart';
import 'package:intl/intl.dart';
import 'package:mytest/widgets/User/focused_menu_item.dart';
import '../../Values/values.dart';

class ProjectCardHorizontal extends StatelessWidget {
  final String projectName;
  final String projeImagePath;
  final String teamName;
  final DateTime endDate;
  final DateTime startDate;
  final String status;
  final String idk;
  String startDateString = "";
  String endDateString = "";
  ProjectCardHorizontal({
    Key? key,
    required this.idk,
    required this.status,
    required this.teamName,
    required this.projectName,
    required this.projeImagePath,
    required this.endDate,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: HexColor.fromHex("20222A"),
            borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ColouredProjectBadge(projeImagePath: projeImagePath),
                  AppSpaces.horizontalSpace20,
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(projectName,
                            style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 5),
                        Row(children: [
                          InkWell(
                            child: Text(
                              "Team : ",
                              style: TextStyle(
                                color: HexColor.fromHex("246CFE"),
                              ),
                            ),
                          ),
                          Text(
                            teamName,
                            style: TextStyle(
                              color: HexColor.fromHex("626677"),
                            ),
                          ),
                        ]),
                        Row(
                          children: [
                            Text(
                              "Status : ",
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("246CFE"),
                              ),
                            ),
                            Text(
                              status,
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("626677"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Start Date : ",
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("246CFE"),
                              ),
                            ),
                            Text(
                              formatDateTime(startDate),
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("626677"),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "End Date : ",
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("246CFE"),
                              ),
                            ),
                            Text(
                              formatDateTime(endDate),
                              style: GoogleFonts.lato(
                                color: HexColor.fromHex("626677"),
                              ),
                            ),
                          ],
                        ),
                      ])
                ]),
              ]),
          AppSpaces.verticalSpace10,
        ]));
  }
}

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return "Today ${DateFormat('h:mm a').format(dateTime)}";
  } else {
    return DateFormat('dd/MM h:mm a').format(dateTime);
  }
}
