import 'package:flutter/material.dart';
import 'package:oralprep/provider/test_provider.dart';
import 'package:oralprep/ui/test/loading/rocket_animation.dart';
import 'package:oralprep/ui/test/question_screen.dart';
import 'package:oralprep/utils/status/response.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TestProvider>(
      builder: (_, testProvider, __) {
        switch (testProvider.state.runtimeType) {
          case Loading:
            return LoadingScreen();
          case Success:
            return QuestionScreen();
          case Failure:
            return Scaffold(body: Center(child: Text("Opps!! an error occured")),);
            
          default:
            return Scaffold(body: Center(child: Text("Opps!! an error occured")),);
        }
      },
    );
  }
}
