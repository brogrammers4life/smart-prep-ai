class NotesResponse {
  String? answer;
  String? difficulty;
  String? question;

  NotesResponse({this.answer, this.difficulty, this.question});

  NotesResponse.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    difficulty = json['difficulty'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['difficulty'] = this.difficulty;
    data['question'] = this.question;
    return data;
  }
}