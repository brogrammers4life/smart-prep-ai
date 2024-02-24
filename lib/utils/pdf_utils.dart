// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:guruji_academy/utils/utils.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:firebase_storage/firebase_storage.dart';


// class PdfUtils {
//   Future<File> downloadPDFFromFirebase( String pdfUrl) async {
//     try {
//       var response = await http.get(Uri.parse(pdfUrl));
//       if (response.statusCode == 200) {
//         var file = await DefaultCacheManager().putFile(
//           pdfUrl,
//           response.bodyBytes,
//         );
//         return file;
//       } else {
//         throw Exception('Failed to download PDF');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }


// Future<String?> getPDFDownloadUrl(BuildContext context ,String filePath) async {
//   try {
//     // Get a reference to the file in Firebase Storage
//     Reference storageReference = FirebaseStorage.instance.ref().child('magazine/mg_8_june.pdf');

//     // Get the download URL for the file
//     final String downloadURL = await storageReference.getDownloadURL();

//     return downloadURL;
//   } catch (e) {
//     // Handle any errors that might occur during the process
//     showSnackBar(context, 'Error getting PDF download URL: $e');
//     return null;
//   }
// }


// }
