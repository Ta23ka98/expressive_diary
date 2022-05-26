import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final DateTime createdAt;
  final DateTime deletedAt;

  Event(
      {required this.title, required this.createdAt, required this.deletedAt});

  Event.fromJson(Map<String, Object?> json)
      : this(
          title: json['title']! as String,
          createdAt: (json['createdAt']! as Timestamp).toDate() as DateTime,
          deletedAt: (json['deletedAt']! as Timestamp).toDate() as DateTime,
        );

  Map<String, Object?> toJson() {
    Timestamp? deletedTimestamp;
    if (deletedAt != null) {
      deletedTimestamp = Timestamp.fromDate(deletedAt);
    }
    return {
      'title': title,
      'createdAt':
          Timestamp.fromDate(createdAt), //DartのDateTimeからFirebaseのTimestampへ変換
      'deletedAt': deletedTimestamp
    };
  }
}
