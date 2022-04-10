import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  DateTime _focusedDay = DateTime.now();
  CollectionReference events = FirebaseFirestore.instance.collection('Events');
  Future<void> addEvent() {
    return events
        .doc()
        .set({'diaryContent': "Mary Jane", 'diaryDateTime': _focusedDay})
        .then(
          (value) => print("User Added"),
        )
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AddEventScreen"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_focusedDay.month.toString()}/${_focusedDay.day.toString()}",
              style: TextStyle(fontSize: 35),
            ),
            SizedBox(height: 20),
            Container(
              height: 300,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.blue, width: 1)),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addEvent,
                child: Text("完了"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
