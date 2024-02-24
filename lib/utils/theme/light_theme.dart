import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ThemeData lightTheme = ThemeData(
//   textTheme: const TextTheme(
//     displayLarge: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    
//   ),
//   brightness: Brightness.light,
//   primaryColorDark: Color(0xff153d76),
//   scaffoldBackgroundColor: Colors.white,
//   cardColor: Colors.white70,
//   primaryColor: Color(0xff2e81f7),


// );


// Light theme properties
final lightTheme = ThemeData(
  primaryColor: Colors.blue,
  hintColor: Colors.blue,
  
  visualDensity: VisualDensity.adaptivePlatformDensity,
  brightness: Brightness.light, // Set the brightness to light
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18,),
    backgroundColor: Colors.blue,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    const TextTheme(
      displayLarge: TextStyle(color: Colors.black), // Set the text color to black for light theme
      displayMedium: TextStyle(color: Colors.black),
      // Add other text styles as needed
    ),
  ),
  // Add any other light theme properties here
);




class R {
  static Color shimmerCardColor = Color.fromARGB(255, 226, 222, 222);
  static Color tintWhite =  Colors.black12.withOpacity(0.05);
  static Color tintDark =  Colors.black54;
  static Color primaryColor = const  Color(0xfffb9400);
  static Color primaryLightColor = const  Color(0xffffb800);
  static Color primaryDarkColor = const  Color(0xffc77500);

}