import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScreen extends StatelessWidget {
  late final userID = FirebaseAuth.instance.currentUser?.uid;
  late final _usersStream =
      FirebaseFirestore.instance.collection("Users").doc(userID).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        final String userName = snapshot.data!["name"];
        final int userLevel = snapshot.data!["userLevel"];
        final int diaryNumbers = snapshot.data!["diaryNumbers"];
        final int diaryLetters = snapshot.data!["diaryLetters"];
        final int lettersUntilNextLevel =
            snapshot.data!["lettersUntilNextLevel"];
        return Column(
          children: [
            const SizedBox(
              child: Center(
                  child: Text(
                "ユーザー画面",
                style: TextStyle(fontSize: 15),
              )),
              height: 60,
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.person),
                title: Text('$userNameさん'),
                subtitle: Text('現在のレベル：$userLevel')),
            const Divider(),
            ListTile(title: Text('日記の総数：$diaryNumbers')),
            const Divider(),
            ListTile(title: Text('これまでの字数：$diaryLetters')),
            const Divider(),
            ListTile(title: Text('次のレベルアップまで：$lettersUntilNextLevel字')),
            const Divider(),
          ],
        );
      },
    );
  }
}
