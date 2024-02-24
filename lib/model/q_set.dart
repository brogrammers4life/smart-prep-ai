


class Question {
  String question;
  String answer;
  String? type;
  double sem_score = 0.0;
  double litScore = 0.0;

  Question(this.question, this.answer, {this.type});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'type': type,
      'sem_score': sem_score,
      'lit_score': litScore,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      json['question'] ?? "",
      json['answer'] ?? "",
      type: json['type'],
    )
      ..sem_score = json['sem_score'] ?? 0.0
      ..litScore = json['lit_score'] ?? 0.0;
  }
}
