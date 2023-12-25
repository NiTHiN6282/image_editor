import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imageeditor/core/utils.dart';
import 'package:imageeditor/features/auth/controller/auth_controller.dart';

import '../../../core/common/custom_outline_border.dart';
import '../../../core/constants/constants.dart';
import 'signup_screen.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final visibilityProvider = StateProvider.autoDispose<bool>((ref) {
    return false;
  });

  final emailMobileController = TextEditingController();
  final passwordController = TextEditingController();

  validate() {
    unFocus();
    if (emailMobileController.text.isEmpty) {
      showSnackBar(context: context, text: "Enter Email or Mobile");
    } else if (passwordController.text.isEmpty) {
      showSnackBar(context: context, text: "Enter Password");
    } else {
      logIn();
    }
  }

  logIn() {
    ref.read(authControllerProvider.notifier).signInUser(
        emailMobile: emailMobileController.text,
        password: passwordController.text,
        context: context);
  }

  googleSignIn() {
    ref.read(authControllerProvider.notifier).googleSignIn(context: context);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: height * 0.25,
                    ),
                    TextFormField(
                      controller: emailMobileController,
                      decoration: InputDecoration(
                        border: CustomOutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.only(
                          left: 16,
                          top: 10,
                          bottom: 10,
                        ),
                        label: const Text(
                          "Email address or mobile number",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            emailMobileController.clear();
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Consumer(builder: (context, ref, child) {
                      var visibility = ref.watch(visibilityProvider);
                      return TextFormField(
                        controller: passwordController,
                        obscureText: !visibility,
                        decoration: InputDecoration(
                          border: CustomOutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.only(
                            left: 16,
                            top: 10,
                            bottom: 10,
                          ),
                          label: const Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .read(visibilityProvider.notifier)
                                  .update((state) => !state);
                            },
                            icon: Icon(
                              visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    ElevatedButton(
                      onPressed: validate,
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(width, 45)),
                      child: const Text(
                        "Log In",
                      ),
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgotten Password?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    GestureDetector(
                      onTap: () {
                        googleSignIn();
                      },
                      child: SvgPicture.asset(
                        Constants.googleIcon,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(width, 45),
                        side: const BorderSide(
                          width: 1.5,
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Create new account",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
