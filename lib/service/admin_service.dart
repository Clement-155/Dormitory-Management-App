import '../model/admin_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  // Note collection
  final CollectionReference admins = FirebaseFirestore.instance.collection('admin');

  // CREATE
  Future<void> addUser(AdminModel admin) {
    return admins.add(admin.mapModel());
  }
  // READ

  // Stream<QuerySnapshot> getNotesStream() {
  //   final notesStream = notes.orderBy('timestamp', descending: true).snapshots();
  //
  //   return notesStream;
  // }

  Stream<QuerySnapshot> getUser(String email) {
    //TODO : Check if requested email exists
    final residentData = admins.where("email", isEqualTo: email).limit(1).snapshots();
    return residentData;
  }

  // UPDATE
  Future<void> updateUser(String docID, AdminModel admin){
    return admins.doc(docID).update(admin.mapModel());
  }

  // DELETE
  Future<void> deleteUser(String docID){
    return admins.doc(docID).delete();
  }

  bool exists(String email){
    bool exist = false;
    final adminsData = admins.where("email", isEqualTo: email).limit(1).get().then(
            (doc) {
          exist = doc.docs.isEmpty;
        }
    );

    return !exist;

  }
}