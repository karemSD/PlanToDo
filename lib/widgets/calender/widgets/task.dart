import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:sizer/sizer.dart';

import '../core/res/color.dart';
import 'package:intl/intl.dart';

class TaskWidgetCalender extends StatelessWidget {
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  const TaskWidgetCalender(
      {Key? key,
      required this.name,
      required this.startDate,
      required this.endDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20.w,
                child: GlowText(
                  DateFormat('dd/MM/yy h:mma').format(startDate),
                  style: const TextStyle(
                    color: Colors.white,
                    // Colors.grey[800]
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                width: 70.w,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    gradient: AppColors2.getDarkLinearGradient(
                      Colors.blue,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                        offset: const Offset(2, 6),
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${DateFormat('h:mma').format(startDate)} - ${DateFormat('h:mma').format(endDate)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Divider(),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
