import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // READ: Get a stream of test items
  Stream<QuerySnapshot> getTestItems() {
    return _db.collection('test_items').snapshots();
  }

  // CREATE: Add a new test item
  Future<void> addTestItem(String name) async {
    await _db.collection('test_items').add({
      'name': name,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // UPDATE: Update a test item
  Future<void> updateTestItem(String id, String newName) async {
    await _db.collection('test_items').doc(id).update({
      'name': newName,
    });
  }

  // DELETE: Delete a test item
  Future<void> deleteTestItem(String id) async {
    await _db.collection('test_items').doc(id).delete();
  }
}
