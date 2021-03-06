import 'package:cloud_firestore/cloud_firestore.dart';
import 'event.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String userID = FirebaseAuth.instance.currentUser!.uid;

class EventRepository {
  final eventsManager = FirebaseFirestore.instance
      .collection('EventExample')
      .where("madeBy", isEqualTo: userID);

  // Future<List<QueryDocumentSnapshot<Event>>> getEvents() async {
  //   final eventRef = eventsManager.withConverter<Event>(
  //       fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
  //       toFirestore: (event, _) => event.toJson());
  //   final eventSnapshot = await eventRef.get();
  //   return eventSnapshot.docs;
  // }

  // Stream<QuerySnapshot<Event>> getEvents() {
  //   final eventRef = eventsManager.withConverter<Event>(
  //       fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
  //       toFirestore: (event, _) => event.toJson());
  //   final eventSnapshot = eventRef.snapshots();
  //   return eventSnapshot;
  // }

  Stream<List<Event>> subscribeEvents() {
    final eventRef = eventsManager.withConverter<Event>(
        fromFirestore: (snapshot, _) => Event.fromJson(snapshot.data()!),
        toFirestore: (event, _) => event.toJson());
    final eventSnapshot = eventRef.snapshots();
    final result =
        eventSnapshot.map((qs) => qs.docs.map((qds) => qds.data()).toList());
    return result;
  }
}
