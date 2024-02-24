class TestResponse {
  List<QaData>? qaData;

  TestResponse({this.qaData});

  TestResponse.fromJson(Map<String, dynamic> json) {
    if (json['qa_data'] != null) {
      qaData = <QaData>[];
      json['qa_data'].forEach((v) {
        qaData!.add(new QaData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.qaData != null) {
      data['qa_data'] = this.qaData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QaData {
  String? answer;
  String? question;

  QaData({this.answer, this.question});

  QaData.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['question'] = this.question;
    return data;
  }
} 
