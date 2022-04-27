import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
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
              title: Text('〇〇さん'),
              subtitle: Text('現在のレベル：')),
          Divider(),
          ListTile(title: Text('日記の総数：')),
          Divider(),
          ListTile(title: Text('これまでの字数：')),
          Divider(),
          ListTile(title: Text('次のレベルアップまで：○字')),
          Divider(),
        ],
      ),
    );
  }
}
