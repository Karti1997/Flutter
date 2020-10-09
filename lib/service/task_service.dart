import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference todolistcollection =
    FirebaseFirestore.instance.collection('todolist');

class Taskservice {
  Stream<QuerySnapshot> getTasklist({int offset, int limit}) {
    Stream<QuerySnapshot> snapshots = todolistcollection.snapshots();
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }
}
