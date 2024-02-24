


// //get all subjects
//   Future fetchSubjectsfromWP() async {
//     final response = await http.get(Uri.parse(
//         'https://dev-guruji-ias.pantheonsite.io/wp-json/wp/v2/categories?parent=4'));

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       List<Subject> subjects = data
//           .map((category) => Subject(
//                 name: category['name'].toString(),
//                 slug: category['slug'].toString(),
//                 id: category['id'].toString(),
//               ))
//           .toList();
//       print(subjects[0].id);
//       this.subjects = subjects;
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load categories');
//     }
//   }

  // Future<List<Topic>> getListOfTopicFromWP(String subjectId) async {
  //   final response = await http.get(Uri.parse(
  //       'https://dev-guruji-ias.pantheonsite.io/wp-json/wp/v2/categories?parent=$subjectId'));

  //   if (response.statusCode == 200) {
  //     List<dynamic> data = jsonDecode(response.body);
  //     List<Topic> topics = data
  //         .map((category) => Topic(
  //               name: category['name'].toString(),
  //               slug: category['slug'].toString(),
  //               id: category['id'].toString(),
  //             ))
  //         .toList();
  //     print(topics[0].id);
  //     return topics;
  //   } else {
  //     throw Exception('Failed to load categories');
  //   }
  // }