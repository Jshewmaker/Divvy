import 'dart:async';

import 'package:authentication_repository/src/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'models/models.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
// class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    FirebaseAuth firebaseAuth,
    // GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  // _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  final FirebaseAuth _firebaseAuth;
  final firebaseUser = FirebaseAuth.instance.currentUser();

  // final GoogleSignIn _googleSignIn;

  /// Stream of [UserModel] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [UserModel.empty] if the user is not authenticated.
  Stream<UserModel> get user {
    return _firebaseAuth.onAuthStateChanged.asyncMap((event) {
      if (event == null) {
        return UserModel.empty;
      } else {
        FirebaseService _firebaseService = FirebaseService();
        return _firebaseService.getUserData();
        // DocumentSnapshot _documentSnapshot =
        //     Firestore.instance.collection("users").document(event.uid).get();
        // return UserModel.fromEntity(UserEntity.fromSnapshot(_documentSnapshot));
      }
    });
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    @required String email,
    @required String password,
  }) async {
    var value;
    assert(email != null && password != null);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
    //This is the way to get the error if the email is already taken
    // catch (_) {
    //   print(_);
    // }
    //We need to make this throw the above error
    on Exception {
      throw SignUpFailure();
    }
  }

  /// Starts the Sign In with Google Flow.
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  // Future<void> logInWithGoogle() async {
  //   try {
  //     final googleUser = await _googleSignIn.signIn();
  //     final googleAuth = await googleUser.authentication;
  //     final credential = GoogleAuthProvider.getCredential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await _firebaseAuth.signInWithCredential(credential);
  //   } on Exception {
  //     throw LogInWithGoogleFailure();
  //   }
  // }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null && password != null);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [UserModel.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        // _googleSignIn.signOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}
