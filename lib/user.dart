import 'package:flutter/material.dart';

class User {
  final String userName;
  final int userLevel;
  final int diaryLetters;
  final int lettersUntilNextLevel;

  User({
    required this.userName,
    required this.userLevel,
    required this.diaryLetters,
    required this.lettersUntilNextLevel,
  });
}
