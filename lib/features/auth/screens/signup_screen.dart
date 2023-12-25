import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/custom_outline_border.dart';
import '../../../core/utils.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();

  validate() {
    unFocus();
    if (nameController.text.isEmpty) {
      showSnackBar(context: context, text: "Enter Name");
    } else if (emailController.text.isEmpty) {
      showSnackBar(context: context, text: "Enter Email");
    } else if (mobileController.text.isEmpty) {
      showSnackBar(context: context, text: "Enter Mobile");
    } else if (passwordController.text.isEmpty) {
      showSnackBar(context: context, text: "Enter Password");
    } else {
      signUp();
    }
  }

  signUp() {}

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
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
                  "Name",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    nameController.clear();
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
            TextFormField(
              controller: emailController,
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
                  "Email",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    emailController.clear();
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
            TextFormField(
              controller: mobileController,
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
                  "Mobile",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    mobileController.clear();
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
            TextFormField(
              controller: passwordController,
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
                    passwordController.clear();
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
            ElevatedButton(
              onPressed: validate,
              child: const Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
