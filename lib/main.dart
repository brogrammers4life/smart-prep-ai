import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oralprep/provider/ocr_test_provider.dart';
import 'package:oralprep/provider/test_provider.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/ui/auth/animation.dart';
import 'package:oralprep/ui/home/home.dart';
import 'package:oralprep/ui/home/radar_chart/radar_chart.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider<TestProvider>(
          create: (context) => TestProvider(),
        ),
         ChangeNotifierProvider<OcrTestProvider>(
          create: (context) => OcrTestProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'SmartPrep.ai',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: AppColors.primary,
          primaryColorLight: AppColors.lightPrimary,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          backgroundColor: AppColors.lightbg,
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.lightPrimary,
          ),
          textTheme: GoogleFonts.poppinsTextTheme().copyWith(
            headline1: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Adjust color as needed
            ),
            // Add more text styles as needed
          ),
          
        ),
        home: SafeArea(
          child: IntroPage1(),
          // child: RadarChartExample(),
        ),
      ),
    );
  }
}

class AppColors {
  static Color primary = Color(0xff5E1896);
  static Color lightPrimary = Color(0xffBA61FF);
  static Color backgroundColor = Color(0xff212121);
  static Color lightbg = Color(0Xff363636);
}
