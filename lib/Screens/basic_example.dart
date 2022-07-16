import 'dart:collection';
import 'package:expressive_diary/eventRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../event.dart';
import '../utils.dart' as utils;
import 'add_event_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Map<DateTime, List<SampleEvent>> selectedEvents = {};
DateTime _focusedDay = DateTime.now();

/// Example event class.
class SampleEvent {
  final String title;
  const SampleEvent({required this.title});
  @override
  String toString() => title;
}

/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
var kEvents = LinkedHashMap<DateTime, List<SampleEvent>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(kEventSource);

var todayListEvents = kEvents[_focusedDay]?.toList();

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<SampleEvent> _getEventsForDay(DateTime day) {
  // Implementation example
  return kEvents[day] ?? [];
}

// Future getRepository() async {
//   final eventRepository = EventRepository();
//   //データの取得のサンプル
//   final events = await eventRepository.getEvents();
//   for (var event in events) {
//     var eventId = event.id;
//     var eventTitle = event.data().title;
//     var eventDate = event.data().createdAt;
//     print("ドキュメントID:" + eventId);
//     print("イベント名：" + eventTitle);
//     print("作成日時:" + eventDate.toString());
//     kEvents[eventDate]?.add(Event(title: eventTitle));
//   }
// }

Future getRepository() async {
  final eventRepository = EventRepository();
  final eventStream = await eventRepository.subscribeEvents();
}

Map<DateTime, List<SampleEvent>> kEventSource = {
  _focusedDay: [SampleEvent(title: "今日の日記")],
  DateTime(2022, 4, 28, 12, 15): [
    SampleEvent(title: "4/28-1"),
    SampleEvent(title: "4/28-2")
  ],
};

class DiaryScreen extends StatefulWidget {
  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime? _selectedDay = _focusedDay;
  late final ValueNotifier<List<SampleEvent>> _selectedEvents =
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
            TableCalendar<SampleEvent>(
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
              child: ValueListenableBuilder<List<SampleEvent>>(
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
                builder: (context) => AddEventScreen(),
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
  late ValueNotifier<List<SampleEvent>> _selectedEvents =
      ValueNotifier(_getEventsForDay(_selectedDay!));
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    print(eventStream);
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
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        // final String eventTitle = snapshot.data!["description"];
        // kEvents[eventDate]?.add(Event(title: eventTitle));
        //final events = snapshot.data!.docs;
        //print(events);
        if (!snapshot.hasData) {
          return Text("No data");
        }
        final events = snapshot.data!;

        ///kEvents = events.map((event) => null).toList();

        //print(snapshot.data!.docs.first.data().toString());
        // snapshot.data!.docs.map((DocumentSnapshot document) {
        //   Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        //   final String description = data["description"];
        //   final String createdAt = data["createdAt"];
        //
        //   kEvents[createdAt]?.add(Event(title: description));
        // });
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
                TableCalendar<SampleEvent>(
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
                  child: ValueListenableBuilder<List<SampleEvent>>(
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
                    builder: (context) => AddEventScreen(),
                  ));
            },
          ),
        );
      },
    );
  }
}
