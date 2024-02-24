import 'dart:ffi';
import 'dart:math';

import 'package:oralprep/model/q_set.dart';

class UserModel{
  String name;
  String age;
  String grade; 
  String board;
  Map<String, double> weak_topic  = {};
  Map<String, double> strong_topic  = {};
  String current_teacher  = "";
  bool isPremium = false;
  String  marksheet_url = "";
  List<Test>? test;
  int coins = 0;

  UserModel({required this.name, required this.age, required this.grade, required this.board } ){

  }

  Map<String, dynamic> toMap() {
  return {
    'name': name,
    'age': age,
    'grade': grade,
    'board': board,
    'weak_topic': weak_topic,
    'strong_topic': strong_topic,
    'current_teacher': current_teacher,
    'isPremium': isPremium,
    'marksheet_url': marksheet_url,
    'test': test?.map((t) => t.toMap()).toList(),
  };
}

factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    name: json['name'],
    age: json['age'],
    grade: json['grade'],
    board: json['board'],
  )
    ..weak_topic = Map<String, double>.from(json['weak_topic'] ?? {})
    ..strong_topic = Map<String, double>.from(json['strong_topic'] ?? {})
    ..current_teacher = json['current_teacher'] ?? ""
    ..isPremium = json['isPremium'] ?? false
    ..marksheet_url = json['marksheet_url'] ?? ""
    ..test = (json['test'] as List<dynamic>?)
        ?.map((testJson) => Test.fromJson(testJson))
        .toList();
}

  


}


class Test{
  late String date;
  late String id;
  List<Question> questions = [];

Test(){
  this.date = DateTime.now().toString();
  this.id = Random().nextInt(10) as String;
}
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'id': id,
      'questions': questions.map((question) => question.toMap()).toList(),
    };
  }

 factory Test.fromJson(Map<String, dynamic> json) {
    final test = Test()
      ..date = json['date'] ?? ""
      ..id = json['id'] ?? ""
      ..questions = (json['questions'] as List<dynamic>?)
          ?.map((questionJson) => Question.fromJson(questionJson))
          .toList() ?? [];

    return test;
  }


}