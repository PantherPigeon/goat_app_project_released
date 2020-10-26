import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import './database.dart';
import '../models/user.dart';

class AuthService {
  final _firebaseAuth = auth.FirebaseAuth.instance;
  // final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // create user obj based on firebase user
  User _userFromFirebaseUser(auth.User user) {
    return user != null ? User(uid: user.uid) : null;
  }

  /*This Stream is connected to firebase auth and listens for changes. 
  if a change is detected it will store the user uid. */
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  /* Sign in using a username and password */
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (error) {
      throw (error.code);
    }
  }

  /*Resgister user - adds a user to the firebase authentication and then registers a user
  in the firestore which will contain a users profile information */
  Future<void> registerWithEmailAndPassword(
      UserData user, String password) async {
    try {
      auth.UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: password);
      user.uid = result.user.uid;
      await DatabaseService().registerUser(user);
    } catch (error) {
      throw (error.code);
    }
  }

  /*Send an email to reset the user password*/
  Future<void> resetPassword(email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (error) {
      throw (error.code);
    }
  }

  /*Sign out user - this will trigger onAuthStateChanged which will 
  handle logging the user out from the front end */
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (error) {
      print('Sign out error');
      print(error);
    }
  }
}
