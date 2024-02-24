


import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:oralprep/provider/ocr_test_provider.dart';
import 'package:provider/provider.dart';


class ImageTestScreen extends StatefulWidget {
  ImageTestScreen({Key? key}) : super(key: key);

  @override
  State<ImageTestScreen> createState() => _ImageTestScreenState();
}

class _ImageTestScreenState extends State<ImageTestScreen> {
  @override
  Widget build(BuildContext context) {
    final OcrTestProvider _ocrTestProvider = Provider.of<OcrTestProvider>(context);
    return Scaffold(
      body: Center(child: Text("extracted text ${_ocrTestProvider.extracted_text}", style: TextStyle(backgroundColor: Colors.white), )),
    );
  }
}