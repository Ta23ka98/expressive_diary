import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserScreen extends StatelessWidget {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  late final _usersStream =
      FirebaseFirestore.instance.collection("Users").doc(userID).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        final String userName = snapshot.data!["name"];
        final int userLevel = snapshot.data!["userLevel"];
        final int diaryNumbers = snapshot.data!["diaryNumbers"];
        final int diaryLetters = snapshot.data!["diaryLetters"];
        return Column(
          children: [
            SizedBox(
              child: Center(
                  child: Text(
                "ユーザー画面",
                style: TextStyle(fontSize: 15),
              )),
              height: 60,
            ),
            Divider(),
            ListTile(
                leading: Icon(Icons.person),
                title: Text('$userNameさん'),
                subtitle: Text('現在のレベル：$userLevel')),
            Divider(),
            ListTile(title: Text('日記の総数：$diaryNumbers')),
            Divider(),
            ListTile(title: Text('これまでの字数：$diaryLetters')),
            Divider(),
            ListTile(title: Text('次のレベルアップまで：○字')),
            Divider(),
          ],
        );
      },
    );
  }
}
