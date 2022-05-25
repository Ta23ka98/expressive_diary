import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';

class EventRepository {
  final eventsManager = FirebaseFirestore.instance.collection('EventExample');

  Future<List<QueryDocumentSnapshot<Event>>> getEvents() async {
    final eventRef = eventsManager.withConverter<Event>(
        fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
        toFirestore: (event, _) => event.toJson());
    final eventSnapshot = await eventRef.get();
    return eventSnapshot.docs;
  }

  Future<String> insert(Event event) async {
    final data = await eventsManager.add(event.toJson());
    return data.id;
  }
}
