import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserScreen extends StatelessWidget {
  final userID = FirebaseAuth.instance.currentUser?.uid;
  late final userRef =
      FirebaseFirestore.instance.collection("Users").doc(userID).get();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userRef,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
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
                title: Text('${data["name"]}さん'),
                subtitle: Text('現在のレベル：')),
            Divider(),
            ListTile(title: Text('日記の総数：')),
            Divider(),
            ListTile(title: Text('これまでの字数：')),
            Divider(),
            ListTile(title: Text('次のレベルアップまで：○字')),
            Divider(),
          ],
        );
      },
    );
  }
}
