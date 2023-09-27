import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Values/values.dart';
import 'package:intl/intl.dart';

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  BarChartSample1(
      {super.key, required this.percentages, required this.message});
  final List<double> percentages;
  final String message;
  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = const Color(0xFFA06AFA);
  static const Color mainColor = Color(0xFFFAA3FF);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Completed ${widget.message} in the last 7 Days",
                      style: GoogleFonts.lato(
                          color: HexColor.fromHex("616575"), fontSize: 13)),
                  IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xff0f4a3c),
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                        if (isPlaying) {
                          refreshState();
                        }
                      });
                    },
                  ),
                ],
              ),
              AppSpaces.verticalSpace10,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: BarChart(
                    isPlaying ? randomData() : mainBarData(),
                    swapAnimationDuration: animDuration,
                  ),
                ),
              ),
              AppSpaces.verticalSpace10,
              Row(children: [
                Text(widget.message,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    )),
                AppSpaces.horizontalSpace20,
              ])
            ],
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = mainColor,
    double width = 6,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100, // Set the toY value of the project bar to 100
            color: HexColor.fromHex("3A3D49"),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(widget.percentages.length, (i) {
      return makeGroupData(i, widget.percentages[i],
          isTouched: i == touchedIndex);
    });
  }

  BarChartData mainBarData() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.day);
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = DateFormat('EEEE/d/M')
                      .format(DateTime.now().subtract(const Duration(days: 6)));
                  break;
                case 1:
                  weekDay = DateFormat('EEEE/d/M')
                      .format(DateTime.now().subtract(const Duration(days: 5)));
                  break;
                case 2:
                  weekDay = DateFormat('EEEE/d/M')
                      .format(DateTime.now().subtract(const Duration(days: 4)));
                  break;
                case 3:
                  weekDay = DateFormat('EEEE/d/M')
                      .format(DateTime.now().subtract(const Duration(days: 3)));
                  break;
                case 4:
                  weekDay = DateFormat('EEEE/d/M')
                      .format(DateTime.now().subtract(const Duration(days: 2)));

                  break;
                case 5:
                  weekDay = DateFormat('EEEE/d/M')
                      .format(DateTime.now().subtract(const Duration(days: 1)));
                  break;
                case 6:
                  weekDay = DateFormat('EEEE d/M').format(DateTime.now());

                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (
          event,
          barTouchResponse,
        ) {
          setState(() {
            if (barTouchResponse?.spot != null &&
                event is! PointerUpEvent &&
                event is! PointerExitEvent) {
              touchedIndex = barTouchResponse?.spot?.touchedBarGroupIndex ?? 0;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: false,
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: (double value, TitleMeta meta) {
              switch (value.toInt()) {
                case 0:
                  return _BarChartTitle(DateFormat('E').format(
                      DateTime.now().subtract(const Duration(days: 6))));
                case 1:
                  return _BarChartTitle(DateFormat('E').format(
                      DateTime.now().subtract(const Duration(days: 5))));
                case 2:
                  return _BarChartTitle(DateFormat('E').format(
                      DateTime.now().subtract(const Duration(days: 4))));
                case 3:
                  return _BarChartTitle(DateFormat('E').format(
                      DateTime.now().subtract(const Duration(days: 3))));
                case 4:
                  return _BarChartTitle(DateFormat('E').format(
                      DateTime.now().subtract(const Duration(days: 2))));
                case 5:
                  return _BarChartTitle(DateFormat('E').format(
                      DateTime.now().subtract(const Duration(days: 1))));
                case 6:
                  return _BarChartTitle(DateFormat('E').format(DateTime.now()));
                default:
                  return const _BarChartTitle('');
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      gridData: FlGridData(
        show: false,
      ),
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: false,
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: (double value, TitleMeta meta) {
              switch (value.toInt()) {
                case 0:
                  return const _BarChartTitle('M');
                case 1:
                  return const _BarChartTitle('T');
                case 2:
                  return const _BarChartTitle('W');
                case 3:
                  return const _BarChartTitle('T');
                case 4:
                  return const _BarChartTitle('F');
                case 5:
                  return const _BarChartTitle('S');
                case 6:
                  return const _BarChartTitle('S');
                default:
                  return const _BarChartTitle('');
              }
            },
          ),
        ),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(widget.percentages.length, (i) {
        return makeGroupData(i, Random().nextInt(15).toDouble() + 6,
            barColor: widget.availableColors[
                Random().nextInt(widget.availableColors.length)]);
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      await refreshState();
    }
  }
}

class _BarChartTitle extends StatelessWidget {
  final String title;
  const _BarChartTitle(
    this.title,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }
}
