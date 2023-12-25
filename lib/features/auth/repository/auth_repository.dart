import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:imageeditor/core/providers/firebase_providers.dart';
import 'package:imageeditor/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/failure.dart';
import '../../../core/type_defs.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(firestore: ref.watch(firestoreProvider));
});

class AuthRepository {
  final FirebaseFirestore _firestore;
  AuthRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid checkAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString("uid") ?? "";
    if (uid == "") {
      return left(Failure("Not Login"));
    }
    return right(uid);
  }

  FutureVoid createUser({required UserModel userData}) async {
    try {
      var usersDoc = await _users
          .where(
            Filter.or(
              Filter('email', isEqualTo: userData.email),
              Filter('mobile', isEqualTo: userData.mobile),
            ),
          )
          .get();
      if (usersDoc.docs.isNotEmpty) {
        return left(Failure('Email or Mobile already exists'));
      }
      final reference = _users.doc(userData.uid == "" ? null : userData.uid);
      final userDataWithId = userData.copyWith(
        uid: reference.id,
        reference: reference,
      );
      reference.set(userDataWithId.toJson());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", reference.id);
      return right(reference.id);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid signInUser(
      {required String emailMobile, required String password}) async {
    try {
      var usersDoc = await _users
          .where(
            Filter.or(
              Filter('email', isEqualTo: emailMobile),
              Filter('mobile', isEqualTo: emailMobile),
            ),
          )
          .where("password", isEqualTo: password)
          .get();
      if (usersDoc.docs.isEmpty) {
        return left(Failure('Invalid Credentials'));
      }
      final uid = usersDoc.docs.first.get("uid");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", uid);
      return right(uid);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid googleSignIn({required GoogleSignIn googleSignIn}) async {
    try {
      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredentail =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final users = await _users
          .where("email", isEqualTo: userCredentail.user!.email)
          .get();

      if (users.docs.isEmpty) {
        return right({
          "newUser": true,
          "userData": UserModel(
            name: userCredentail.user?.displayName ?? '',
            createdAt: DateTime.now(),
            deleted: false,
            email: userCredentail.user?.email ?? '',
            mobile: userCredentail.user?.phoneNumber ?? '',
            password: "",
            status: 0,
            uid: userCredentail.user!.uid,
          )
        });
      } else {
        final uid = users.docs.first.get("uid");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", uid);
        return right({"newUser": false});
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid logOut({
    required GoogleSignIn googleSignIn,
    required FirebaseAuth firebaseAuth,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
      return right("");
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
