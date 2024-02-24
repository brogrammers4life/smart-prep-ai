import 'dart:async';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:oralprep/provider/user_provider.dart';
import 'dart:convert';

import 'package:oralprep/utils/response.dart';

class SimilarityUtils {
  Future<double> getSemanticSimilarity(
      String your_answer, String given_answer) async {
    List<double> output = await query({
      'inputs': {
        'source_sentence': your_answer,
        'sentences': [
          given_answer,
        ],
      },
    });

    return output[0];
  }

  Future<List<double>> query(Map<String, dynamic> payload) async {
    final apiUrl =
        'https://api-inference.huggingface.co/models/sentence-transformers/all-MiniLM-L6-v2';
    final headers = {
      'Authorization': 'Bearer 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',
      'Content-Type': 'application/json'
    };

    //for now we don't have similarity response state management then for failed response we will send the -1.0 as similarity score

    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: jsonEncode(payload));

    if (response.statusCode < 400) {
      print(response.body);
      return jsonDecode(response.body) as List<double>;
    }
    else{
      List<double> failed_response = [-1.0];
      return failed_response;
    }
  }


  Future<double> getSS(String your_answer, String correct_answer)async{
    String apiUrl =
        'https://api-inference.huggingface.co/models/sentence-transformers/all-MiniLM-L6-v2';
    Map<String, String> headers = {
      'Authorization': 'Bearer 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',
      'Content-Type': 'application/json'
    };

    Map<String, dynamic> body = {
      "inputs" : {
        "source_sentence" : your_answer, 
        "sentences" : [
          correct_answer
        ]
      }
    };

    String body_String = jsonEncode(body);

    final response = await  http.post(Uri.parse(apiUrl), headers: headers, body: body_String);
    if (response.statusCode == 200) {
      double score = jsonDecode(response.body)[0];
      return score;
    }

    return Random().nextDouble();
  }
}
