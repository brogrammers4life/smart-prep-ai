import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadFileAndGetDownloadURL(File file, String storagePath) async {
  try {
    final Reference storageReference = FirebaseStorage.instance.ref().child(storagePath+ DateTime.now().toString());
    final UploadTask uploadTask = storageReference.putFile(file);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
    if (snapshot.state == TaskState.success) {
      final String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } else {
      throw Exception("Failed to upload file");
    }
  } catch (e) {
    print("Error uploading file: $e");
    throw e;
  }
}
