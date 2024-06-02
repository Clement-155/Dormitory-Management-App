import '../model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  // Note collection
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // CREATE
  Future<void> addUser(UserModel user) {
    return users.add(user.mapModel());
  }
  // READ

  // Stream<QuerySnapshot> getNotesStream() {
  //   final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
  //
  //   return notesStream;
  // }

  Stream<QuerySnapshot> getUser(String email) {
    //TODO : Check if requested email exists
    final userData = users.where("email", isEqualTo: email).limit(1).snapshots();
    return userData;
  }

  // UPDATE
  Future<void> updateUser(String docID, UserModel user){
    return users.doc(docID).update(user.mapModel());
  }

  // DELETE
  Future<void> deleteUser(String docID){
    return users.doc(docID).delete();
  }
}