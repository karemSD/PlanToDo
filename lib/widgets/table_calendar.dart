import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Data/my_task.dart';
import 'Shapes/roundedborder_with_icon.dart';

const kBlueCircleForCalendar = BoxDecoration(
  color: Color(0xFF246CFD),
  shape: BoxShape.circle,
);
// the Developer karem saad (KaremSD)
class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  bool isClassLoading = true;
  List<MyTask> classes = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //getClassesOf();
  }

  // @override
  List<MyTask> _getEventsForDay(DateTime day) {
    if (day.weekday == DateTime.tuesday) {
      return [MyTask('', '', day)];
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return
        //isClassLoading ? CustomWidget.rectangular(height: 300) :
        Container(
      decoration: BoxDecoration(
          color: const Color(0xFF262A34),
          borderRadius: BorderRadius.circular(10)),
      child: TableCalendar(
        // event here
        eventLoader: _getEventsForDay,
        // range of calendar time
        firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
        lastDay: DateTime.utc(DateTime.now().year, DateTime.december, 31),
        locale: 'en_US',
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        daysOfWeekStyle:
            const DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.grey)),
        headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextStyle: GoogleFonts.lato(
                color: const Color(0xFFAEF8A3),
                fontWeight: FontWeight.bold,
                fontSize: 20),
            formatButtonVisible: false,
            leftChevronIcon: const RoundedBorderWithIcon(
              icon: Icons.arrow_back,
              width: 30,
              height: 30,
            ),
            rightChevronIcon: const RoundedBorderWithIcon(
              icon: Icons.arrow_forward,
              width: 30,
              height: 30,
            )),
        calendarStyle: CalendarStyle(
            weekendTextStyle: const TextStyle(color: Colors.grey),
            defaultTextStyle: const TextStyle(color: Colors.white),
            outsideTextStyle: const TextStyle(color: Colors.white),
            markerDecoration:
                kBlueCircleForCalendar.copyWith(color: const Color(0xCC448AFF)),
            markerSize: 5,
            selectedDecoration: kBlueCircleForCalendar,
            todayDecoration:
                kBlueCircleForCalendar.copyWith(color: const Color(0x995C6BC0)),
            isTodayHighlighted: true),
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          print(selectedDay);
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            //_selectedEvents.value = _getEventsForDay(selectedDay);
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
    );
  }
}
