import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertRecords({required Map<String, dynamic> data}) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await db.collection("counter").doc("vote_counter").get();

    Map<String, dynamic>? counterData = documentSnapshot.data();

    int counter = counterData!['counter'];
    int length = counterData['length'];

    counter++;
    length++;

    await db.collection("tbl_vote").doc("$counter").set(data);

    await db
        .collection("counter")
        .doc("vote_counter")
        .update({"counter": counter, "length": length});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> checkUser() {
    return db.collection("tbl_vote").snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchVote() {
    return db.collection("vote_party").snapshots();
  }

  Future<void> updateData(
      {required String Party, required Map<String, dynamic> data}) async {
    await db.collection("vote_party").doc(Party).update(data);
  }
}
