import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imageeditor/features/auth/controller/auth_controller.dart';
import 'package:imageeditor/models/user_model.dart';

import '../../../core/common/custom_outline_border.dart';
import '../../../core/utils.dart';

class GoogleSignUpScreen extends ConsumerStatefulWidget {
  final UserModel userData;
  const GoogleSignUpScreen({super.key, required this.userData});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<GoogleSignUpScreen> {
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
      final userData = widget.userData.copyWith(
        name: nameController.text,
        createdAt: DateTime.now(),
        mobile: mobileController.text,
        password: passwordController.text,
      );
      signUp(userData: userData);
    }
  }

  signUp({required UserModel userData}) {
    ref
        .read(authControllerProvider.notifier)
        .createUser(userData: userData, context: context);
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userData.name;
    emailController.text = widget.userData.email;
    mobileController.text = widget.userData.mobile;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
            readOnly: true,
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
    );
  }
}
