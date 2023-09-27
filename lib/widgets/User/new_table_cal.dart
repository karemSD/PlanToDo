import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Shapes/roundedborder_with_icon.dart';

const kBlueCircleForCalendar = BoxDecoration(
  color: Color(0xFF246CFD),
  shape: BoxShape.circle,
);

class NewCalendarView extends StatefulWidget {
  NewCalendarView(
      {super.key,
      required this.selectedDay,
      required this.onSelectedDayChanged});
  DateTime selectedDay;
  final Function(DateTime) onSelectedDayChanged;
  @override
  _NewCalendarViewState createState() => _NewCalendarViewState();
}

class _NewCalendarViewState extends State<NewCalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  bool isClassLoading = true;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
  }

  // @override

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
        // range of calendar time
        firstDay: DateTime.utc(_focusedDay.year, _focusedDay.month, 1),
        lastDay: DateTime.utc(DateTime.now().year, DateTime.december, 31),
        availableGestures: AvailableGestures.none,
        locale: 'en_US',
        focusedDay: widget.selectedDay,
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
          return isSameDay(_focusedDay, day);
        },

        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(widget.selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              widget.selectedDay = DateTime(
                  selectedDay.year,
                  selectedDay.month,
                  selectedDay.day,
                  widget.selectedDay.hour,
                  widget.selectedDay.minute);
              _focusedDay = focusedDay;
              widget.onSelectedDayChanged(widget.selectedDay);
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
