import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsta/resurces/store_methods.dart';

import 'package:fitsta/model/user.dart' as model;

class AuthMethode {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.Users> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.Users.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error sind aufgetreten";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {}

      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String profImage = await StorageMethodes()
          .uploadImageToStorage('profilePics', file, false);

      model.Users user = model.Users(
        username: username,
        uid: cred.user!.uid,
        email: email,
        bio: bio,
        profImage: profImage,
        followers: [],
        following: [],
      );

      await _firestore
          .collection('users')
          .doc(cred.user!.uid)
          .set(user.toJason());
      res = "success";
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'keine richtige Email-Adresse';
      } else if (err.code == 'weak-password') {
        res = ' 123456sieben ist kein sicheres Passwort';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Du musst schon alles ausfüllen';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'keine richtige Email-Adresse';
      } else if (err.code == 'weak-password') {
        res = '123456sieben ist kein sicheres Passwort';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
