import 'package:flutter/material.dart';

class UserClass {
  final String userName;
  final int userLevel;
  final int diaryLetters;
  final int lettersUntilNextLevel;

  UserClass({
    required this.userName,
    required this.userLevel,
    required this.diaryLetters,
    required this.lettersUntilNextLevel,
  });

  // UserClass.fromJson(Map<String, Object>? json) : this(
  //   userName: json[name] as String,
  // );
}
