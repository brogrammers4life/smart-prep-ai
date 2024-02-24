import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context, e.toString());
  }

  return image;
}


String getVideoIdFromUrl(String videoUrl) {
  if (videoUrl == null || videoUrl.isEmpty) {
    throw ArgumentError("Video URL cannot be null or empty.");
  }

  Uri uri = Uri.parse(videoUrl);
  String? videoId = uri.queryParameters['v'];

  if (videoId == null || videoId.isEmpty) {
    throw FormatException("Invalid YouTube video URL.");
  }

  return videoId;
}

