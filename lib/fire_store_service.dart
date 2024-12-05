import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:games/game.dart';
// import 'package:firebase_core/firebase_core.dart';

class FireStoreService {
  static final FireStoreService _instance = FireStoreService._internal();

   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  factory FireStoreService(){
    return _instance;
  }

  FireStoreService._internal();

  Stream<List<Game>> getData(String collection){
    return _firestore.collection(collection).snapshots().map((snapshot){
      return snapshot.docs
      .map((doc) => Game.fromDocumentSnapShot(doc))
      .toList();
    });
  }
  
  Future<void> insertData(String collection, Map<String, dynamic> data){
    return _firestore.collection(collection).add(data);
  }

  Future<void> updateData(String collection, String docId, Map<String, dynamic> data){
    return _firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteData(String collection, String docId){
    return _firestore.collection(collection).doc(docId).delete();
  }

}