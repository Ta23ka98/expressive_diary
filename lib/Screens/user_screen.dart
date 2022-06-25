import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserScreen extends StatelessWidget {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(userID)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
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
                title: Text('${snapshot.data!["name"]}さん'),
                subtitle: Text('現在のレベル：${snapshot.data!["userLevel"]}')),
            Divider(),
            ListTile(title: Text('日記の総数：${snapshot.data!["diaryNumbers"]}')),
            Divider(),
            ListTile(title: Text('これまでの字数：${snapshot.data!["diaryLetters"]}')),
            Divider(),
            ListTile(title: Text('次のレベルアップまで：○字')),
            Divider(),
          ],
        );
      },
    );
  }
}
