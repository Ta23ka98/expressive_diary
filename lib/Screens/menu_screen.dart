import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          SizedBox(
            child: Center(
                child: Text(
              "メニュー画面",
              style: TextStyle(fontSize: 15),
            )),
            height: 60,
          ),
          Divider(),
          ListTile(title: Text('アプリの使い方')),
          Divider(),
          ListTile(title: Text('利用規約')),
          Divider(),
          ListTile(title: Text('プライバシーポリシー')),
          Divider(),
        ],
      ),
    );
  }
}
