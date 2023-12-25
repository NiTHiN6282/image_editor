import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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
      final reference = _users.doc();
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

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
