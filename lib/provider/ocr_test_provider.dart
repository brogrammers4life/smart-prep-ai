import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oralprep/utils/showsnacker.dart';
import 'package:permission_handler/permission_handler.dart';

class OcrTestProvider extends ChangeNotifier {

  
  final ImagePicker _imagePicker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  String extracted_text = "";
  
  Future<String?> scanImage(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        print("image clicked");
        // Get the image file
        final imageFile = File(pickedFile.path);
        final inputImage =  InputImage.fromFile(imageFile);
        

        RecognizedText extractedText = await _textRecognizer.processImage(inputImage);

        this.extracted_text = extractedText.text;

 
        notifyListeners();
      } else {
        // Handle permission denied case
        showSnackBar(context, "Permission denied");
        return null;
      }
    } else {
      showSnackBar(context, "Permission denied");
      return null;
    }
  }
}
