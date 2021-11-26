import 'package:flutter/material.dart';
import 'package:spotter/main.dart';
import 'package:spotter/services/session_svc.dart';
import 'package:spotter/widgets/topbar.dart';
import 'package:table_calendar/table_calendar.dart';


class Plan extends StatefulWidget {
  SessionSvc svc;

  Plan({required this.svc});

  @override
  _PlanState createState() => _PlanState();
}

class _PlanState extends State<Plan> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    if(_selectedEvents != null) {
      _selectedEvents.dispose();
    }

    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return widget.svc.kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    var db = widget.svc.getDb();

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: TopBar(
        onTitleTapped: () {
        },
        title: 'Plan',
        onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyHomePage(db: db,
                      title: 'Spotter',)
            ));},
        child: const Icon(Icons.arrow_back),
        svc: widget.svc,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
              child:  TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
            defaultTextStyle: TextStyle(color: Colors.black45),
            rangeHighlightColor: Colors.white,
            outsideDaysVisible: false,
            rangeEndTextStyle: TextStyle(color: Colors.blueGrey),
            rangeStartTextStyle: TextStyle(color: Colors.blueGrey)
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          )),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          onPressed: startSession,
          tooltip: 'Start Session',
          child:   Icon(widget.svc.activeSessionExists() ? Icons
              .play_arrow_rounded :
          Icons.add_rounded),
        )
    );
  }

  void startSession() {
  }
}