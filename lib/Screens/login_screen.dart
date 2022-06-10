import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String newUserEmail = "";
  String newUserPassword = "";
  String loginUserEmail = "";
  String loginUserPassword = "";
  String infoText = "";

  Future<void> SignUp() async {
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
        email: newUserEmail,
        password: newUserPassword,
      );

      final User user = result.user!;
      setState(() {
        infoText = "登録OK：${user.email}";
      });
    } catch (e) {
      infoText = "登録NG：${e.toString()}";
    }
  }

  Future<void> Login() async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
        email: loginUserEmail,
        password: loginUserPassword,
      );

      final User user = result.user!;
      setState(() {
        infoText = "ログインOK：${user.email}";
      });
    } catch (e) {
      infoText = "ログインNG：${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "E-mail"),
              onChanged: (String value) {
                setState(() {
                  newUserEmail = value;
                });
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              onChanged: (String value) {
                setState(() {
                  newUserPassword = value;
                });
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: SignUp, child: const Text("ユーザー登録")),
            const SizedBox(height: 30),
            TextFormField(
              decoration: const InputDecoration(labelText: "E-mail"),
              onChanged: (String value) {
                setState(() {
                  loginUserEmail = value;
                });
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
              onChanged: (String value) {
                setState(() {
                  loginUserPassword = value;
                });
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: Login, child: const Text("ログイン")),
            const SizedBox(height: 8),
            Text(infoText),
          ],
        ),
      ),
    );
  }
}
