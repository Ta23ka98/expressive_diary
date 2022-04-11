import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  String _text = '';
  final DateTime _focusedDay = DateTime.now();
  CollectionReference events = FirebaseFirestore.instance.collection('Events');

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_printLatestValue);
    print("controller has been set!");
  }

  _printLatestValue() {
    print("入力状況: ${_textEditingController.text}");
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
    print("controller disposed!");
  }

  void _handleText(String e) {
    setState(() {
      _text = e;
    });
  }

  void _submission(String e) {
    print(_textEditingController.text);
    _textEditingController.clear();
    setState(() {
      _text = '';
    });
  }

  Future<void> addEvent() {
    return events
        .doc()
        .set({'diaryContent': _text, 'diaryDateTime': _focusedDay})
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
      appBar: AppBar(
        title: const Text("AddEventScreen"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
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
                    border: InputBorder.none, hintText: "　日記を書いてスッキリしよう！👍"),
                controller: _textEditingController,
                onChanged: _handleText,
                onSubmitted: _submission,
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
