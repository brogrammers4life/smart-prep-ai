import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:oralprep/model/q_set.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileUtils {
  static String chapter = 'SAMPLE CONTENT100    100Std. X: History and Political Science7. Historical Tourism Ans:  i. Historical tourism refers to a kind of tourism, where the tour or tour group focusses on the history; history of some place, people, things or events. It helps people satisfy their interest in history.  ii. In India, tours are arranged to different historical places and important historical sites such as forts in Rajasthan, ashrams  o f  M a h a t m a  Gandhi and Acharya Vinoba Bhave, important places related to the Indian War of Independence (1857), etc.  iii. Gopal Neelkanth Dandekar, a renowned   Marathi writer, used to arrange hiking tours to forts in Maharashtra, to explore the sights closely linked to Chhatrapati Shivaji Maharaj and his achievements.  8. Geographic Tourism Ans:  i. Geographic tourism involves visiting places to observe the special geographical features of a region.  ii. In order to satisfy this curiosity, tourists visit various natural & animal sanctuaries, beaches and unique geographical wonders like the Crater lake at Lonar & Ranjan Khalge  (naturally carved out cavities in rocks) at Nighoj in Maharashtra.   9. Health Tourism Ans: i. Health Tourism involves travelling for the purpose of receiving medical treatment or improving health or fitness.  ii. In India, the health services and facilities available are cheaper compared to other countries. Even the standard of these facilities is good, therefore, people from western countries undertake this type of tourism.  iii. Besides, tourists from c ountries with cold climate visit India to get ample sunlight.  iv. Learning Yoga  and undertaking ayurvedic therapies are some other reasons for this type of tourism.  *10. Agro-Tourism Ans: i. Tourism wherein tourists take part in farm or village activities like animal and crop care, cooking and cleaning, handicrafts and entertainment is called as ‘Agro-tourism.  ii. Today Agro-tourism, also known as Agri-tourism, is rapidly developing. It is specially meant for the urban population who have very little exposure to rural life and agriculture.  iii. Indian farmers, nowadays, visit distant regions like the agricultural research centres, agricultural-universities and countries like Israel where experimentation in advanced technology of agriculture is carried out.  11. Sports Tourism Ans:  i. Sports Tourism, developed in the 20th century, refers to travel which involves attending a sporting event.  ii. Various sports events are organised at the international level, national level and state level.  iii. Olympics, Wimble don, World Chess Championship matches and International Cricket Tournaments etc., are some examples of sports events organised at the international level; event like Himalayan Car Rally is organised at the national level and the Maharashtra Kesari Wrestling competitions, etc; are organised at the state level.   12. Tourism based on Special Events Ans:  i. Travelling to and staying in places outside the usual environment for a specific purpose and for a fixed period of time is known as ‘tourism’.  ii. People who love to travel, look for special reasons to go on a tour and in the 21st century, it has become common to organise such events.  iii. Film festivals, various types of seminars and conferences, international book exhibitions, library festivals, etc., are examples of special events. People from different regions come to attend these events.  iv. For instance, every year many literature enthusiasts from Maharashtra come to attend the Akhil Bhartiya Marathi Sammelan [Pan India Literary Convention] which is held annually in different places of India.  13. Religious Tourism  Ans: i. People belonging to various caste, religion, creed, etc., visit religious places to worship the different gods and goddesses, saints or to see the art, culture, traditions and architecture.   ii. Nowadays, people of various religious communities are spread globally. However, they remain united because of their mythological traditions and the places associated with those traditions.   iii. This creates a desire to travel to those places and it gives rise to religious tourism.  SAMPLE CONTENT101     Chapter 8: Tourism and History iv. Religious tourism fosters peace, unity and socio-cultural harmony among people.  v. In order to provide good amenities on the pilgrim routes like Chardham Yatras and Bara Jyotirlingas, Ahilyabai Holkar undertook the constructions by using her personal funds.   14. Village of Books Ans:  i. Bhilar is a village near Mahabaleshwar. It was long known for its natural beauty and strawberry cultivation. But now it is declared as India’s first ‘Village of Books’.  ii. Every household in Bhilar has a library of its own. This scheme was implemented by the Maharashtra State G o v e r n m e n t  w i t h  a  v i e w  t o  a c c e l e r a t e  the ‘Reading Culture’ movement and for making the reade r-tourists enjoy the beauty of Marathi literature enriched by the works of old & new authors and saints.    iii. The books include various types of texts in Marathi like biographies, autobiographies, fiction, poetry, literature on sports, literature for kids, literature by women, etc.     1. What promotes Tourism? Ans: Following things promote tourism:  i. In order to get a delightful and  awe-inspiring experience, tourists from all over the world visit places like the snow-capped peaks, beaches, pristine jungles, etc.   ii. The desire of the tourists to visit national and international monuments, places of historical importance & natural beauty';

  //file size
  static String getFileSize(String filePath) {
    File file = File(filePath);
    int fileSizeInBytes = file.statSync().size;

    double fileSizeInKB = fileSizeInBytes / 1024; // Convert bytes to kilobytes
    double fileSizeInMB = fileSizeInKB / 1024; // Convert kilobytes to megabytes

    print('File Size:');

    if (fileSizeInMB >= 1) {
      return '${fileSizeInMB.toStringAsFixed(2)} MB';
    } else {
      return '${fileSizeInKB.toStringAsFixed(2)} KB';
    }
  }

  //extract text from pdf
  static Future<String> extractPdfText(File file, int start, int end) async {
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData(file));

    //Create the new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

//Extract all the text from the first page to third page of the PDF document.
    String text =
        extractor.extractText(startPageIndex: start, endPageIndex: end);
    //return the clean string
    return text.replaceAll('/n', '');
  }

  // converting file to bytes
  static Future<List<int>> _readDocumentData(File file) async {
    final bytes = await file.readAsBytes();
    return bytes;
  }

  //extract question from the text
  static Future<List<Question>> extractQuestionAnswers(
      File file, int start, int end, int no_que) async {
    List<Question> questions = [];
    int q_count = 0;
    //clean text
    String text = await extractPdfText(file, start, end);
    print("text " + text);
    //pattern
     RegExp pattern = RegExp(r'(\d+)\.\s+(.*?)\s+Ans:(.*?)(?=\d+\.|\Z)');

  // Testing if the pattern matches the text
  // if (pattern.hasMatch(text)) {
  //   print('Pattern found!');
  // } else {
  //   print('Pattern not found.');
  // }

  // Extracting matches from the text
  Iterable<Match> matches = pattern.allMatches(chapter);
  print(matches.length);

    print(matches.length);
    for (final match in matches) {

      //question
      final String? q = match.group(2);
      //answer
      final String? a = match.group(3);
      Question question = Question(q!, a!);
      questions.add(question);

      q_count++;
      if ((q_count >= no_que)) break;
    }

    

    return questions;
  }
}
