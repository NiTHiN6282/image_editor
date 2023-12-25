import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imageeditor/core/utils.dart';
import 'package:imageeditor/features/auth/repository/auth_repository.dart';
import 'package:imageeditor/features/auth/screens/signin_screen.dart';
import 'package:imageeditor/features/home/screens/home_screen.dart';

import '../../../models/user_model.dart';

final authControllerProvider = NotifierProvider<AuthController, bool>(() {
  return AuthController();
});

class AuthController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void checkAuth({required BuildContext context}) async {
    state = true;
    final res = await ref.watch(authRepositoryProvider).checkAuth();
    state = false;
    res.fold((l) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
          (route) => false);
    }, (r) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }

  void createUser(
      {required UserModel userData, required BuildContext context}) async {
    state = true;
    final res =
        await ref.watch(authRepositoryProvider).createUser(userData: userData);
    state = false;
    res.fold((l) {
      showSnackBar(context: context, text: l.message);
    }, (r) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }

  void signInUser(
      {required String emailMobile,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await ref
        .watch(authRepositoryProvider)
        .signInUser(emailMobile: emailMobile, password: password);
    state = false;
    res.fold((l) {
      showSnackBar(context: context, text: l.message);
    }, (r) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false);
    });
  }
}
