import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'basic_example.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  int charLength = 0;
  String _text = '';
  final DateTime _focusedDay = DateTime.now();
  CollectionReference events = FirebaseFirestore.instance.collection('Events');

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _handleText(String e) {
    setState(() {
      _text = e;
      charLength = _text.length;
    });
  }

  Future<void> addEvent() {
    Navigator.pop(context);
    setState(() {});
    if (_textEditingController.text.isEmpty) {
    } else {
      if (selectedEvents[_focusedDay] != null) {
        selectedEvents[_focusedDay]!.add(
          Event(title: _textEditingController.text),
        );
      }
    }
    return events
        .doc()
        .set({
          'diaryContent': _text,
          'diaryDateTime': _focusedDay,
          'wordCount': charLength
        })
        .then(
          (value) => print("Event Added!!!"),
        )
        .catchError(
          (error) => print("Failed to add event...: $error"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("AddEventScreen"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_focusedDay.month.toString()}/${_focusedDay.day.toString()}",
              style: const TextStyle(fontSize: 35),
            ),
            const SizedBox(height: 20),
            Container(
              height: 230,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.blue, width: 1)),
              child: TextField(
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: " 日記を書こう！"),
                controller: _textEditingController,
                onChanged: _handleText,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${charLength.toString()}字！",
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addEvent,
                child: const Text("完了"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
