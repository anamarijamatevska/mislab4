library event_calendar;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import './exams.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notifications.dart';

part 'color-picker.dart';

part 'timezone-picker.dart';

part 'appointment-editor.dart';

void main2() => runApp(const MaterialApp(
      home: EventCalendar(),
      debugShowCheckedModeBanner: false,
    ));

//ignore: must_be_immutable
class EventCalendar extends StatefulWidget {
  const EventCalendar({Key? key}) : super(key: key);

  @override
  EventCalendarState createState() => EventCalendarState();
}

List<Color> _colorCodes = <Color>[];
List<String> _listOfColors = <String>[];
int _selectedColorIndex = 0;
int _selectedTimeZoneIndex = 0;
List<String> _timeZoneCollection = <String>[];
late DataSource _events;
Meeting? _selectedAppointment;
late DateTime _startDate;
late TimeOfDay _startTime;
late DateTime _endDate;
late TimeOfDay _endTime;
bool _isAllDay = false;
String _subject = '';
String _notes = '';

class EventCalendarState extends State<EventCalendar> {
  EventCalendarState();

  CalendarView _calendarView = CalendarView.month;
  late List<String> _eventsList;
  late List<Meeting> appointments;

  @override
  void initState() {
    _calendarView = CalendarView.month;
    appointments = getMeetingDetails();
    _events = DataSource(appointments);
    _selectedAppointment = null;
    _selectedColorIndex = 0;
    _selectedTimeZoneIndex = 0;
    _subject = '';
    _notes = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false, body: Padding(padding: const EdgeInsets.fromLTRB(5, 0, 5, 5), child: getEventCalendar(_calendarView, _events, onCalendarTapped)));
  }

  SfCalendar getEventCalendar(CalendarView _calendarView, CalendarDataSource _calendarDataSource, CalendarTapCallback calendarTapCallback) {
    return SfCalendar(view: _calendarView, dataSource: _calendarDataSource, onTap: calendarTapCallback, initialDisplayDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0), monthViewSettings: const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment), timeSlotViewSettings: const TimeSlotViewSettings(minimumAppointmentDuration: Duration(minutes: 60)));
  }

  void onCalendarViewChange(String value) {
    if (value == 'Day') {
      _calendarView = CalendarView.day;
    } else if (value == 'Week') {
      _calendarView = CalendarView.week;
    } else if (value == 'Work week') {
      _calendarView = CalendarView.workWeek;
    } else if (value == 'Month') {
      _calendarView = CalendarView.month;
    } else if (value == 'Timeline day') {
      _calendarView = CalendarView.timelineDay;
    } else if (value == 'Timeline week') {
      _calendarView = CalendarView.timelineWeek;
    } else if (value == 'Timeline work week') {
      _calendarView = CalendarView.timelineWorkWeek;
    }

    setState(() {});
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell && calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    ScheduleNotifications.schedule("Notification Text", new DateTime.now(), []);

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      if (_calendarView == CalendarView.month) {
        _calendarView = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null && calendarTapDetails.appointments!.length == 1) {
          final Meeting meetingDetails = calendarTapDetails.appointments![0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;
          _selectedColorIndex = _colorCodes.indexOf(meetingDetails.background);
          _selectedTimeZoneIndex = meetingDetails.startTimeZone == '' ? 0 : _timeZoneCollection.indexOf(meetingDetails.startTimeZone);
          _subject = meetingDetails.eventName == '(No title)' ? '' : meetingDetails.eventName;
          _notes = meetingDetails.description;
          _selectedAppointment = meetingDetails;
        } else {
          final DateTime date = calendarTapDetails.date!;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
        }
        _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const AppointmentEditor()),
        );
      }
    });
  }

  List<Meeting> getMeetingDetails() {
    final List<Meeting> meetings = <Meeting>[];
    _eventsList = <String>[];
    _eventsList.add('Strukturno Programiranje');
    _eventsList.add('Algoritmi na podatoci');
    _eventsList.add('Bazi na podatoci');
    _eventsList.add('MIS');
    _eventsList.add('Kalkulus');
    _eventsList.add('PNVI');
    _eventsList.add('Veb Programiranje');
    _eventsList.add('Veb Dizajn');
    _eventsList.add('Napredni bazi na podatoci');
    _eventsList.add('Verojatnost i statistika');

    _colorCodes = <Color>[];
    _colorCodes.add(const Color.fromARGB(255, 30, 31, 30));
    _colorCodes.add(const Color.fromARGB(255, 187, 47, 225));
    _colorCodes.add(const Color.fromARGB(255, 214, 32, 32));
    _colorCodes.add(const Color.fromARGB(255, 212, 31, 194));
    _colorCodes.add(const Color.fromARGB(255, 26, 190, 23));
    _colorCodes.add(const Color.fromARGB(255, 247, 18, 247));
    _colorCodes.add(const Color.fromARGB(255, 61, 80, 191));
    _colorCodes.add(const Color.fromARGB(255, 247, 177, 48));
    _colorCodes.add(const Color.fromARGB(255, 99, 99, 99));

    _listOfColors = <String>[];
    _listOfColors.add('Black');
    _listOfColors.add('Purple');
    _listOfColors.add('Red');
    _listOfColors.add('Pink');
    _listOfColors.add('Green');
    _listOfColors.add('Magenta');
    _listOfColors.add('Blue');
    _listOfColors.add('Orange');
    _listOfColors.add('Grey');

    _timeZoneCollection = <String>[];
    _timeZoneCollection.add('Default Time');

    final DateTime today = DateTime.now();
    final Random random = Random();
    for (int month = -1; month < 2; month++) {
      for (int day = -5; day < 5; day++) {
        for (int hour = 9; hour < 18; hour += 5) {
          meetings.add(Meeting(
            from: today.add(Duration(days: (month * 30) + day)).add(Duration(hours: hour)),
            to: today.add(Duration(days: (month * 30) + day)).add(Duration(hours: hour + 2)),
            background: _colorCodes[random.nextInt(9)],
            startTimeZone: '',
            endTimeZone: '',
            description: '',
            isAllDay: false,
            eventName: _eventsList[random.nextInt(7)],
          ));
        }
      }
    }

    return meetings;
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  String getStartTimeZone(int index) => appointments![index].startTimeZone;

  @override
  String getNotes(int index) => appointments![index].description;

  @override
  String getEndTimeZone(int index) => appointments![index].endTimeZone;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;
}

class Meeting {
  Meeting({required this.from, required this.to, this.background = Colors.green, this.isAllDay = false, this.eventName = '', this.startTimeZone = '', this.endTimeZone = '', this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
