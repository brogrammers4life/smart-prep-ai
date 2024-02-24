import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oralprep/model/NotesResponse.dart';
import 'package:oralprep/model/q_set.dart';
import 'package:oralprep/model/test_model.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/repository/similarity_utils.dart';
import 'package:oralprep/utils/apis.dart';
import 'package:oralprep/utils/response.dart';
import 'package:oralprep/utils/status/response.dart' as r;
import 'package:oralprep/utils/status/response.dart';
import 'package:oralprep/utils/upload_file.dart';
import 'package:oralprep/utils/utils.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../repository/choose_pdf_util.dart';
import '../ui/test/submission/submision_page.dart';
import 'package:http/http.dart' as http;

class TestProvider extends ChangeNotifier {
  late r.Response state = Loading() as r.Response;
  File? file;
  late int _start;
  late int _end;
  late int _no_que;
  late int current_q_index;
  late int total_q_no;

  late List<Question> _questions = [];

  List<Question> get questions => _questions;
  set questions(List<Question> newQuestions) {
    _questions = newQuestions;
  }

  late Question currentquestion;

  int get start => _start;

  set start(int value) {
    _start = value;
  }

  int get end => _end;

  set end(int value) {
    _end = value;
  }

  int get no_que => _no_que;

  set no_que(int value) {
    _no_que = value;
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> _uploadImage(BuildContext context) async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        print("image clicked");
        // Get the image file
        final imageFile = File(pickedFile.path);

        // Upload image to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference =
            FirebaseStorage.instance.ref().child('images/$fileName.jpg');
        UploadTask uploadTask = reference.putFile(imageFile);

        // Get the download URL
        try {
          String downloadURL = await (await uploadTask).ref.getDownloadURL();
          // Print the download URL
          return downloadURL;
        } catch (error) {
          print("Error getting download URL: $error");
          showSnackBar(context, "Error uploading image");
          return null;
        }
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

  // void setupTestFromPdfFromModel(File file, int start, int end, no_que) async {
  //   this.state = Loading();
  //   //get the pdf link
  //   String pdf_url = await uploadFileAndGetDownloadURL(file, "/textbooks");
  //   print(pdf_url);
  //   this.file = file;
  //   this._start = start;
  //   this._end = end;
  //   this._no_que = no_que;
  //   String url =
  //       'https://d179-2405-204-22a9-f775-c5cd-f47a-7166-eb4c.ngrok-free.app/model/api/generate_questions?start=$start&end=$end';
  //   Map<String, dynamic> body = {"pdf_url": pdf_url};
  //   final response =
  //       await http.post(Uri.parse(url),headers: <String, String>{
  //     'Content-Type': 'application/json',
  //   }, body: jsonEncode(body));
  //   print(response.statusCode);
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> qa_response = jsonDecode(response.body);

  //     List<dynamic> qaData = qa_response['qa_data'];
  //     List<Question> questions = qaData.map((qa) {
  //       Question q = Question(qa['question'], qa['answer']);
  //       return q;
  //     }).toList();

  //     if (_questions.length == 0) {
  //       this.state = Failure();
  //       notifyListeners();
  //     }

  //     this._questions = questions;
  //     currentquestion = _questions[0];
  //     current_q_index = 0;
  //     total_q_no = _questions.length;
  //     this.state = Success();
  //     notifyListeners();
  //   }
  //   this.state = Failure();
  // }

  void setupTextfromNotesfromModel(BuildContext context) async {
    this.state = Loading();
    String? image_url = await _uploadImage(context);

    this._no_que = 5;

    String url = "${Api.BASE_URL}/model/api/generate_question_answers_demo";
    Map<String, dynamic> body = {"image_url": image_url};
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      List<NotesResponse> testResponse = (jsonDecode(response.body) as List)
          .map((json) => NotesResponse.fromJson(json))
          .toList();
      if (testResponse.length == 0) {
        this.state = Failure();
      }
      for (var i = 0; i < testResponse.length && i < no_que; i++) {
        Question q = Question(
            testResponse[i].question ?? "", testResponse![i].answer ?? "");
        _questions.add(q);
      }

      currentquestion = _questions[0];
      current_q_index = 0;
      total_q_no = _questions.length;
      this.state = Success();
      notifyListeners();
      return;
    }
    this.state = Failure();
  }

  void setupTestFromPdfFromModel(
      File file, int start, int end, int no_que) async {
    this.state = Loading();
    //get the pdf link
    String pdf_url = await uploadFileAndGetDownloadURL(file, "/textbooks");
    print(pdf_url);
    this.file = file;
    this._start = start;
    this._end = end;
    this._no_que = no_que;
    String url = "${Api.BASE_URL}/model/api/generate_questions_using_regex";
    Map<String, dynamic> body = {
      "pdf_url": pdf_url,
      "start": start,
      "end": end
    };
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      TestResponse testResponse =
          TestResponse.fromJson(jsonDecode(response.body));

      if (testResponse.qaData!.length == 0) {
        this.state = Failure();
      }
      for (var i = 0; i < testResponse.qaData!.length && i < no_que; i++) {
        Question q = Question(testResponse.qaData![i].question ?? "",
            testResponse.qaData![i].answer ?? "");
        _questions.add(q);
      }

      currentquestion = _questions[0];
      current_q_index = 0;
      total_q_no = _questions.length;
      this.state = Success();
      notifyListeners();
      return;
    }
    this.state = Failure();
  }

  void setupTestFromUrl(String url, int start, int end, int no_que) async {
    this.state = Loading();
    //get the pdf link
    String pdf_url =
        "https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/Digests%2Fhistory_10.pdf?alt=media&token=aacefd38-b4bc-44a9-92cd-b627b35ffe7e";
    this.file = file;
    this._start = start;
    this._end = end;
    this._no_que = no_que;
    String url = "${Api.BASE_URL}/model/api/generate_questions_using_regex";
    Map<String, dynamic> body = {
      "pdf_url":
          "https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/Digests%2Fhistory_10.pdf?alt=media&token=aacefd38-b4bc-44a9-92cd-b627b35ffe7e",
      "start": start.toString(),
      "end": end.toString()
    };
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      TestResponse testResponse =
          TestResponse.fromJson(jsonDecode(response.body));

      if (testResponse.qaData!.length == 0) {
        this.state = Failure();
      }
      for (var i = 0; i < testResponse.qaData!.length && i < no_que; i++) {
        Question q = Question(testResponse.qaData![i].question ?? "",
            testResponse.qaData![i].answer ?? "");
        _questions.add(q);
      }

      currentquestion = _questions[0];
      current_q_index = 0;
      total_q_no = _questions.length;
      this.state = Success();
      notifyListeners();
      return;
    }
    this.state = Failure();
  }

  void setupTestFromUrl2(String url, int start, int end, int no_que) async {
    this.state = Loading();
    //get the pdf link
    String pdf_url =
        "https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/Digests%2Fhistory_10.pdf?alt=media&token=aacefd38-b4bc-44a9-92cd-b627b35ffe7e";
    this.file = file;
    this._start = start;
    this._end = end;
    this._no_que = no_que;
    String url = "${Api.BASE_URL}/model/api/generate_questions_using_regex";
    Map<String, dynamic> body = {
      "pdf_url":
         url.toString(),
      "start": start.toString(),
      "end": end.toString()
    };
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      TestResponse testResponse =
          TestResponse.fromJson(jsonDecode(response.body));

      if (testResponse.qaData!.length == 0) {
        this.state = Failure();
      }
      for (var i = 0; i < testResponse.qaData!.length && i < no_que; i++) {
        Question q = Question(testResponse.qaData![i].question ?? "",
            testResponse.qaData![i].answer ?? "");
        _questions.add(q);
      }

      currentquestion = _questions[0];
      current_q_index = 0;
      total_q_no = _questions.length;
      this.state = Success();
      notifyListeners();
      return;
    }
    this.state = Failure();
  }

// setup test
  void setupTestFromPdf(File file, int start, int end, int no_que) async {
    this.state = Loading();
    this.file = file;
    this._start = start;
    this._end = end;
    this._no_que = no_que;
    //get the list of question
    this._questions =
        await FileUtils.extractQuestionAnswers(file, start, end, no_que);
    await Future.delayed(Duration(seconds: 3));
    if (_questions.length == 0) {
      this.state = Failure();
      notifyListeners();
    } else {
      this.state = Success();
      currentquestion = _questions[0];
      current_q_index = 0;
      total_q_no = _questions.length;
      notifyListeners();
    }
  }

//nextquestion
  void nextquestion(BuildContext context) async {
    if (current_q_index + 1 >= total_q_no) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SubmissionPage()));
    } else {
      current_q_index++;
      currentquestion = this._questions[current_q_index];
      notifyListeners();
    }
  }

  Future<double> getSemanticSimilarity(String your_answer) async {
    String url = "${Api.BASE_URL}/model/api/semantic_score";
    Map<String, dynamic> body = {
      "og_ans": _questions[current_q_index].answer,
      "user_ans": your_answer
    };
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      dynamic semanticOutput = jsonDecode(response.body);
      double semanticScore = semanticOutput["semantic_score"] ?? 0.0;
      print("Semantic Score: $semanticScore");

      notifyListeners();
      return semanticScore;
    } else {
      return 0.0;
    }
  }

  Future<double> getLiteralSimilarity(String your_answer) async {
    String url = "${Api.BASE_URL}/model/api/literal_score";
    Map<String, dynamic> body = {
      "og_ans": _questions[current_q_index].answer,
      "user_ans": your_answer
    };
    final response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      dynamic semanticOutput = jsonDecode(response.body);
      double semanticScore = semanticOutput["literal_score"] ?? 0.0;
      print("literal Score: $semanticScore");

      notifyListeners();
      return semanticScore;
    } else {
      return 0.0;
    }
  }

//get semantic similarity
  // Future<double> getSemanticSimilarity(String your_answer) async {
  //   // currentquestion.sem_score = await SimilarityUtils().getSemanticSimilarity(your_answer, currentquestion.answer);
  //   this.currentquestion.sem_score = scaleValue(await SimilarityUtils()
  //       .getSemanticSimilarity(your_answer, currentquestion.answer));
  //   print(this.currentquestion.sem_score);
  //   return this.currentquestion.sem_score;
  // }

//matching word / totol words
  double calculateLiteralSimilarity(String str1) {
    // Split the input strings into words
    List<String> words1 = str1.split(' ');
    List<String> words2 = currentquestion.answer.split(' ');

    // Calculate the total number of words in each string
    int totalWords1 = words1.length;
    int totalWords2 = words2.length;

    // Initialize a variable to count matching words
    int matchingWords = 0;

    // Loop through each word in the shorter string
    for (String word1 in words1) {
      // Check if the word exists in the longer string (case-sensitive)
      if (words2.contains(word1)) {
        matchingWords++;
      }
    }

    // Calculate the ratio of matching words relative to the longer text
    double similarity =
        matchingWords / (totalWords1 > totalWords2 ? totalWords1 : totalWords2);

    return similarity;
  }

  double scaleValue(double value) {
    // Shift the value from the range [-1, 1] to [0, 2]
    double shiftedValue = value + 1.0;

    // Scale the shifted value from the range [0, 2] to [0, 1]
    double scaledValue = shiftedValue / 2.0;

    return scaledValue;
  }
}
