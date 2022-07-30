import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expressive_diary/eventRepository.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../event.dart';
import '../utils.dart' as utils;
import 'add_event_screen.dart';

Map<DateTime, List<Event>> selectedEvents = {};
DateTime _focusedDay = DateTime.now();

/// Example event class.
// class Event {
//   final String title;
//   const Event({required this.title});
//   @override
//   String toString() => title;
// }

/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
var kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(kEventSource);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<Event> _getEventsForDay(DateTime day) {
  return kEvents[day] ?? [];
}

Future getRepository() async {
  final eventRepository = EventRepository();
  final eventStream = await eventRepository.subscribeEvents();
}

Map<DateTime, List<Event>> kEventSource = {
  // _focusedDay: [const Event(title: "今日の日記")],
  // DateTime(2022, 4, 28, 12, 15): [
  //   const Event(title: "4/28-1"),
  //   const Event(title: "4/28-2")
  // ],
};

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime? _selectedDay = _focusedDay;
  late final ValueNotifier<List<Event>> _selectedEvents =
      ValueNotifier(_getEventsForDay(_selectedDay!));
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    //_selectedDay = _focusedDay;
    //_selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(
        () {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        },
      );
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              child: Center(
                  child: Text(
                "日記画面",
                style: TextStyle(fontSize: 15),
              )),
              height: 50,
            ),
            const Divider(),
            TableCalendar<Event>(
              firstDay: utils.kFirstDay,
              lastDay: utils.kLastDay,
              focusedDay: _focusedDay,
              selectedDayPredicate: (DateTime date) {
                return isSameDay(_selectedDay, date);
              },
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              onDaySelected: _onDaySelected,
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
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              child: ValueListenableBuilder<List<Event>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
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
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEventScreen(),
              ));
        },
      ),
    );
  }
}

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final eventStream = EventRepository().subscribeEvents();
  DateTime? _selectedDay = _focusedDay;
  late ValueNotifier<List<Event>> _selectedEvents =
      ValueNotifier(_getEventsForDay(_selectedDay!));
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    //print(eventStream);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(
        () {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        },
      );
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: EventRepository().subscribeEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (!snapshot.hasData) {
          return const Text("No data");
        }

        final events = snapshot.data!;
        for (var event in events) {
          var eventDate = event.createdAt!.toDate();
          var eventTitle = event.title;
          var wordCount = event.wordCount;
          Timestamp createdAtTimestamp = Timestamp.fromDate(eventDate);
          if (kEvents[eventDate] == null) {
            kEvents[eventDate] = [
              Event(
                  title: eventTitle,
                  wordCount: wordCount,
                  createdAt: createdAtTimestamp)
            ];
          } else {
            kEvents[eventDate]!.add(Event(
                title: eventTitle,
                wordCount: wordCount,
                createdAt: createdAtTimestamp));
          }
        }
        //kEventSource = eventMap;
        print(kEvents[DateTime(2022, 07, 31)]?.length);

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  child: Center(
                      child: Text(
                    "日記画面",
                    style: TextStyle(fontSize: 15),
                  )),
                  height: 50,
                ),
                const Divider(),
                TableCalendar<Event>(
                  firstDay: utils.kFirstDay,
                  lastDay: utils.kLastDay,
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(_selectedDay, date);
                  },
                  calendarFormat: _calendarFormat,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: const CalendarStyle(
                    // Use `CalendarStyle` to customize the UI
                    outsideDaysVisible: false,
                  ),
                  onDaySelected: _onDaySelected,
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
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  child: ValueListenableBuilder<List<Event>>(
                    valueListenable: _selectedEvents,
                    builder: (context, value, _) {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
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
                              onTap: () => print('${value[index].title}'),
                              title: Text('${value[index].title}'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEventScreen(),
                  ));
            },
          ),
        );
      },
    );
  }
}
