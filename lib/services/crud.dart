import 'package:cloud_firestore/cloud_firestore.dart';

///Firebase instance to current database
FirebaseFirestore db = FirebaseFirestore.instance;

///Upload and download data from Firebase
class CrudMethods {
  ///Upload to firebase
  Future<void> addData(Map<String, dynamic> blogData) async {
    //await Firebase.initializeApp();
    await db.collection('blogs').add(blogData).catchError((e) {
      return e;
    });
  }

  ///Get data from Firebase
  Stream<QuerySnapshot<Map<String, dynamic>>> getData(String blogs) {
    //await Firebase.initializeApp();
    return db.collection(blogs).snapshots();
  }
}
