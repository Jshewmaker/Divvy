import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'models/models.dart';

class FirebaseService {
  FirebaseAuth firebaseAuth;
  String collection;
  String projectCollection;
  String lineItemsCollection;

  FirebaseService() {
    this.firebaseAuth = FirebaseAuth.instance;
    this.collection = "users";
    this.projectCollection = "projects";
    this.lineItemsCollection = "line_items";
  }

  void userSetupCreateFirestore(String collection, data) async {
    var user = await firebaseAuth.currentUser();
    Firestore.instance.collection(collection).document(user.uid).setData(data);
  }

  void createBusinessAdminInFirestore(String collection, data) async {
    var user = await firebaseAuth.currentUser();
    var documentID = user.uid + '-divvyBusinessUser';
    var businessAdminDocumentID = {'businessAdminDocumentID': documentID};
    addDataToFirestoreDocument(collection, businessAdminDocumentID);
    Firestore.instance
        .collection(collection)
        .document(documentID)
        .setData(data);
  }

  ///Add new line of data to an existing document.
  ///
  ///data field should be a map in the format [Field, value]
  void addDataToFirestoreDocument(
      String collection, Map<String, dynamic> data) async {
    firebaseAuth.currentUser().then((value) {
      Firestore.instance
          .collection(collection)
          .document(value.uid)
          .updateData(data);
    });
  }

  void addDataToBusinessUserDocument(
      String collection, Map<String, dynamic> data) async {
    FirebaseUser user = await firebaseAuth.currentUser();
    DocumentSnapshot _documentSnapshot = await Firestore.instance
        .collection(collection)
        .document(user.uid)
        .get();
    UserModel userData =
        UserModel.fromEntity(UserEntity.fromSnapshot(_documentSnapshot));

    Firestore.instance
        .collection(collection)
        .document(userData.businessAdminDocumentID)
        .updateData(data);
  }

  /// Return user data in a UserModel
  Future<UserModel> getUserData() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    DocumentSnapshot _documentSnapshot = await Firestore.instance
        .collection(collection)
        .document(user.uid)
        .get();
    return UserModel.fromEntity(UserEntity.fromSnapshot(_documentSnapshot));
  }

  /// Return user data in a UserModel
  ///
  /// /*
  Future<LineItemListModel> getPhaseLineItems(int phase) async {
    UserModel user = await getUserData();

    //FirebaseUser lineItems = await firebaseAuth.currentUser();
    QuerySnapshot _querySnapshot = await Firestore.instance
        .collection(projectCollection)
        .document(user.projectID)
        .collection(lineItemsCollection)
        .where('phase', isEqualTo: 1)
        .getDocuments();
    //All the examples use get not getDocuments

    return LineItemListModel.fromEntity(
        LineItemListEntity.fromSnapshot(_querySnapshot));
  }

//Gets individual that is link to a business
  Future<UserModel> getBusinessUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    DocumentSnapshot _documentSnapshot = await Firestore.instance
        .collection(collection)
        .document(user.uid)
        .get();
    UserModel userData =
        UserModel.fromEntity(UserEntity.fromSnapshot(_documentSnapshot));

    _documentSnapshot = await Firestore.instance
        .collection(collection)
        .document(userData.businessAdminDocumentID)
        .get();
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
