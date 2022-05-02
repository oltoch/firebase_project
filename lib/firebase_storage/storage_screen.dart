import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_project/custom_widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({Key? key}) : super(key: key);

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  File? file;
  @override
  Widget build(BuildContext context) {
    final fileName = file == null ? 'No file selected' : 'File selected';
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          primaryButton(onPressed: selectFile, text: 'Select file'),
          const SizedBox(height: 20),
          Text(fileName),
          const SizedBox(height: 20),
          primaryButton(
              onPressed: () async {
                final task = await uploadFile();
                if (task == null) {
                  return;
                }
                getUrl(task);
              },
              text: 'Upload file'),
        ],
      ),
    );
  }

  Future selectFile() async {
    final file = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (file == null) return;
    final path = file.files.single.path!;
    setState(() {
      this.file = File(path);
    });
  }

  Future<UploadTask?> uploadFile() async {
    if (file == null) return null;
    final fileName = file!.path.split('/').last;
    final destination = 'files/$fileName';
    try {
      final storage = FirebaseStorage.instance.ref().child(destination);

      final uploadTask = storage.putFile(file!);
      return uploadTask;
      //final url = await (await uploadTask.).ref.getDownloadURL();
    } on FirebaseException catch (error) {
      debugPrint(error.message);
      return null;
    }
  }

  void getUrl(UploadTask task) async {
    final snapshot = await task.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    debugPrint('URL:' + url);
  }
}
