import 'package:authentication_repository/src/models/project_data/project_entity.dart';
import 'package:authentication_repository/src/models/project_data/project_model.dart';
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

  void addDataToProjectDocument(
      Map<String, dynamic> data, String projectID, String lineID) async {
    Firestore.instance
        .collection(projectCollection)
        .document(projectID)
        .collection(lineItemsCollection)
        .document(lineID)
        .updateData(data);
  }

  void addMessageToProjectDocument(
      dynamic data, String projectID, String lineID) async {
    Map<String, dynamic> firebaseData;

    firebaseData = {
      "messages": FieldValue.arrayUnion([data]),
    };

    Firestore.instance
        .collection(projectCollection)
        .document(projectID)
        .collection(lineItemsCollection)
        .document(lineID)
        .updateData(firebaseData);
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
    if (!_documentSnapshot.exists) {
      return null;
    }
    return UserModel.fromEntity(UserEntity.fromSnapshot(_documentSnapshot));
  }

  Future<UserModel> getUserByPath(String path) async {
    DocumentSnapshot _documentSnapshot =
        await Firestore.instance.document(path).get();
    if (!_documentSnapshot.exists) {
      return null;
    }
    return UserModel.fromEntity(UserEntity.fromSnapshot(_documentSnapshot));
  }

  Future<bool> projectExists(String docID) async {
    DocumentReference cityRef =
        Firestore.instance.collection(projectCollection).document(docID);
    DocumentSnapshot doc = await cityRef.get();

    if (!doc.exists) {
      return false;
    } else {
      return true;
    }
  }

  Future<Project> addUserDataToProject(String projectID, UserModel user) async {
    FirebaseAuth.instance.currentUser().then((value) {
      if (user.isHomeowner == true) {
        addDataToProjectFirestoreDocument(projectID, projectCollection, {
          "homeowner_path": 'users/' + value.uid,
          "homeowner_sila_handle": user.silaHandle,
          "homeowner_name": user.name,
        });
      } else {
        addDataToProjectFirestoreDocument(projectID, projectCollection, {
          "general_contractor_path": 'users/' + value.uid,
          "general_contractor_sila_handle": user.silaHandle,
          "general_contractor_name": user.name,
        });
      }
      addDataToFirestoreDocument(collection, {"project_id": projectID});
    });

    DocumentSnapshot _docSnapshot = await Firestore.instance
        .collection(projectCollection)
        .document(projectID)
        .get();

    return Project.fromEntity(ProjectEntity.fromSnapshot(_docSnapshot));
  }

  void addDataToProjectFirestoreDocument(
      String projectID, String collection, Map<String, dynamic> data) async {
    Firestore.instance
        .collection(collection)
        .document(projectID)
        .setData(data, merge: true);
  }

  Future<Project> getProjects(String projectID) async {
    DocumentSnapshot _docSnapshot = await Firestore.instance
        .collection(projectCollection)
        .document(projectID)
        .get();
    if (!_docSnapshot.exists) {
      return null;
    } else {
      return Project.fromEntity(ProjectEntity.fromSnapshot(_docSnapshot));
    }
  }

  /// Return a list of all line items in a given phase.
  ///
  /// Requires phase and projectID
  Future<LineItemListModel> getPhaseLineItems(
      int phase, String projectID) async {
    //FirebaseUser lineItems = await firebaseAuth.currentUser();
    QuerySnapshot _querySnapshot = await Firestore.instance
        .collection(projectCollection)
        .document(projectID)
        .collection(lineItemsCollection)
        .orderBy('expected_finish_date')
        .getDocuments();
    //All the examples use get not getDocuments

    return LineItemListModel.fromEntity(
        LineItemListEntity.fromSnapshot(_querySnapshot));
  }

  ///Get a single line Item.
  ///
  ///Requires projectID and lineItemID
  Future<LineItem> getLineItem(String projectID, String lineItemID) async {
    //FirebaseUser lineItems = await firebaseAuth.currentUser();
    DocumentSnapshot _documentSnapshot = await Firestore.instance
        .collection(projectCollection)
        .document(projectID)
        .collection(lineItemsCollection)
        .document(lineItemID)
        .get();
    //All the examples use get not getDocuments

    return LineItem.fromEntity(LineItemEntity.fromSnapshot(_documentSnapshot));
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

  Future<bool> checkIfDocumentExists() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    final snapShot =
        await Firestore.instance.collection("users").document(user.uid).get();
    if (snapShot == null || !snapShot.exists) return false;
    return true;
  }
}
