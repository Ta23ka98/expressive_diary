import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final int wordCount;
  final DateTime createdAt;

  Event(
      {required this.title, required this.wordCount, required this.createdAt});

  Event.fromJson(Map<String, Object?> json)
      : this(
          title: json['description']! as String,
          wordCount: json['wordCount'] as int,
          createdAt: (json['createdAt']! as Timestamp).toDate() as DateTime,
        );

  Map<String, Object?> toJson() {
    // Timestamp? deletedTimestamp;
    // if (deletedAt != null) {
    //   deletedTimestamp = Timestamp.fromDate(deletedAt);
    // }
    return {
      'title': title,
      'createdAt':
          Timestamp.fromDate(createdAt), //DartのDateTimeからFirebaseのTimestampへ変換
      //'deletedAt': deletedTimestamp
    };
  }
}
