import '../model/resident_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResidentService {
  // Note collection
  final CollectionReference residents = FirebaseFirestore.instance.collection('resident');

  // CREATE
  Future<void> addUser(ResidentModel resident) {
    return residents.add(resident.mapModel());
  }
  // READ

  // Stream<QuerySnapshot> getNotesStream() {
  //   final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
  //
  //   return notesStream;
  // }

  Stream<QuerySnapshot> getUser(String email) {

    final residentData = residents.where("email", isEqualTo: email).limit(1).snapshots();
    return residentData;
  }

  // UPDATE
  Future<void> updateUser(String docID, ResidentModel resident){
    return residents.doc(docID).update(resident.mapModel());
  }

  // DELETE
  Future<void> deleteUser(String docID){
    return residents.doc(docID).delete();
  }

  bool exists(String email){
    bool exist = false;
    final residentData = residents.where("email", isEqualTo: email).limit(1).get().then(
        (doc) {
          exist = doc.docs.isEmpty;
        }
    );

    return !exist;

  }
}