import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  sign_up_completed,
  sign_up_failed
}

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final _firebase = FirebaseAuth.instance;

  Stream<AuthenticationStatus> get status async* {
    yield* _controller.stream;
  }

  void isUserLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      _controller.add(AuthenticationStatus.authenticated);
    } else {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  void logIn({
    required String username,
    required String password,
  }) async {
    try {
      await _firebase.signInWithEmailAndPassword(
          email: username, password: password);
      _controller.add(AuthenticationStatus.authenticated);
    } on FirebaseAuthException {
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  void signUp(
      {required String email,
      required String password,
      required File? pickedImage}) async {
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: email, password: password);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredentials.user!.uid}.jpg');
      await storageRef.putFile(pickedImage!);
      final downloadUrl = await storageRef.getDownloadURL();
      FirebaseFirestore.instance
          .collection("users")
          .doc(userCredentials.user!.uid)
          .set(
              {"email": userCredentials.user!.email, "image_url": downloadUrl});
      _controller.add(AuthenticationStatus.sign_up_completed);
    } on FirebaseAuthException {
      _controller.add(AuthenticationStatus.sign_up_failed);
    }
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
