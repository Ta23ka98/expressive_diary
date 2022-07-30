import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("メニュー画面"),
      ),
      body: Column(
        children: const [
          SizedBox(
            height: 10.0,
          ),
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
