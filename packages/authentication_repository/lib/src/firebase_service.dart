import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/models.dart';

class FirebaseService {
  FirebaseAuth firebaseAuth;
  String collection;

  FirebaseService() {
    this.firebaseAuth = FirebaseAuth.instance;
    this.collection = "users";
  }

  void userSetupCreateFirestore(String collection, data) async {
    var user = await firebaseAuth.currentUser();
    Firestore.instance.collection(collection).document(user.uid).setData(data);
  }

  void addDataToFirestoreDocument(String collection, data) async {
    firebaseAuth.currentUser().then((value) {
      Firestore.instance
          .collection(collection)
          .document(value.uid)
          .updateData(data);
    });
  }

  /// Return user data in a UserModel
  Future<UserModel> getUserData() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    DocumentSnapshot _documentSnapshot =
        await Firestore.instance.collection(collection).document(user.uid).get();
    return UserModel.fromEntity(UserEntity.fromSnapshot(_documentSnapshot));
  }

  /// Return user data in a FirebaseUser object
  Future<FirebaseUser> getUser() async {
    return firebaseAuth.currentUser();
  }

  void addUserEmailToFirebaseDocument() async {
    FirebaseAuth.instance.currentUser().then((value) {
      var data = {"email": value.email};
      addDataToFirestoreDocument(collection, data);
    });
  }
}
