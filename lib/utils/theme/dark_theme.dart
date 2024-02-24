import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ThemeData darkTheme = ThemeData(
//   textTheme: const  TextTheme(
//     displayLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white70),
//     displayMedium: TextStyle(
//                                 fontSize: 22,

//                                 fontWeight: FontWeight.w600,
//                               ),
//     displaySmall: TextStyle(
//                                 fontSize: 14,

//                                 fontWeight: FontWeight.w300,
//                               ),

//   ),
//   colorScheme:  ColorScheme(
//     onPrimary: Color(0xff153d76),
//     onSecondary: Colors.orangeAccent,
//     brightness: Brightness.dark,
//     secondary: Colors.orange,
//     primary: Color(0xff2e81f7),

//   ),

//   brightness: Brightness.dark,
//   primaryColorDark: Color(0xff153d76),

//   scaffoldBackgroundColor: Colors.grey[800],
//   cardColor: Colors.grey[300],

// );

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.blue,
  hintColor: Colors.orange,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.dark,

  textTheme: GoogleFonts.poppinsTextTheme(
    TextTheme(
      displayLarge:
          TextStyle(color: Colors.white), // Set the text color to white
      displayMedium: TextStyle(
          color: Colors
              .white), // Set the text color to white for another variant if you are using it
      // Add other text styles as needed
    ),
  ),

  // Add any other theme properties specific to the dark theme here
);
