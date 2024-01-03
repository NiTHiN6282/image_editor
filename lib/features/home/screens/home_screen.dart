import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imageeditor/core/providers/firebase_providers.dart';
import 'package:imageeditor/features/auth/controller/auth_controller.dart';

import 'file_storage.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  logOut() {
    ref.read(authControllerProvider.notifier).logOut(
          context: context,
          googleSignIn: ref.read(googleProvider),
          firebaseAuth: ref.read(authProvider),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Editor"),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  if (mounted) {
                    Uint8List uint = await image.readAsBytes();
                    if (mounted) {
                      final editedImage = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageEditor(
                            image: uint, // <-- Uint8List of image
                          ),
                        ),
                      );

                      FileStorage.writeCounter(editedImage, image.name);
                    }
                  }
                }
              },
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(20),
                child: const Text("Edit Image"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
