// import 'package:intl/intl.dart';
// import 'package:html/parser.dart' as parser;

// class DateConvertionUtils {
//   String timeAgo(String dateString) {
//     DateTime currentDate = DateTime.now();
//     DateTime inputDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(dateString);

//     Duration difference = currentDate.difference(inputDate);

//     if (difference.inDays > 0) {
//       return "${difference.inDays} days ago";
//     } else if (difference.inHours > 0) {
//       return "${difference.inHours} hours ago";
//     } else if (difference.inMinutes > 0) {
//       return "${difference.inMinutes} minutes ago";
//     } else {
//       return "Just now";
//     }
//   }

//   int calculateReadTime(String htmlContent) {
//   // Parse the HTML content using the html/parser package
//   var document = parser.parse(htmlContent);

//   // Get the text content from the parsed HTML
//   String textContent = document.body?.text ?? '';

//   // Calculate the number of words in the text content
//   List<String> words = textContent.split(RegExp(r'\s+'));
//   int wordCount = words.length;

//   // Define the average reading speed in words per minute (adjust as needed)
//   double averageReadingSpeed = 200.0;

//   // Calculate the approximate reading time in minutes
//   int readTimeMinutes = (wordCount / averageReadingSpeed).ceil();

//   return readTimeMinutes;
// }
// }
