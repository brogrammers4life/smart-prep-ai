import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:oralprep/main.dart';
import 'package:oralprep/provider/test_provider.dart';
import 'package:oralprep/repository/similarity_utils.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:path/path.dart' as path;

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with TickerProviderStateMixin {
  late DraggableScrollableController _dragController =
      DraggableScrollableController();
  late AnimationController _minController;
  bool isRunning = false;
  int elapsedTimeInSeconds = 0;
  String _speech_text = " ";

  bool _islistening = false;

  double _sheet_height = 0.08;

  //sem_score
  double _sementic_similarity = 0.0;
  double _literal_simiirity = 0.0;

  SpeechToText speechToText = SpeechToText();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _minController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    startStopwatch();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _minController.dispose();

    super.dispose();
  }

  String removeLastWord(String input) {
    // Split the input string into words
    List<String> words = input.split(' ');

    // Check if there are at least two words in the string
    if (words.length >= 2) {
      // Remove the last word by joining the first (length-1) words
      return words.sublist(0, words.length - 1).join(' ');
    } else {
      // If there is only one word or the string is empty, return an empty string
      return '';
    }
  }

  void startStopwatch() {
    setState(() {
      if (isRunning) {
        isRunning = false;
      } else {
        isRunning = true;
        startTimer();
      }
    });
  }

  void resetStopwatch() {
    setState(() {
      isRunning = false;
      elapsedTimeInSeconds = 0;
    });
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer timer) {
      if (!isRunning) {
        timer.cancel();
      } else {
        setState(() {
          elapsedTimeInSeconds++;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        actions: [
          Container(
            padding: EdgeInsets.all(12),
            child: Consumer<TestProvider>(builder: (_, testProvider, __) {
              return Text(
                "${testProvider.current_q_index + 1}/${testProvider.total_q_no}",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              );
            }),
          ),
        ],
        automaticallyImplyLeading: false,
        title: Consumer<TestProvider>(
          builder: (context, value, child) => Text(
            value.file== null ? "Oral test":
            "${path.basenameWithoutExtension(value.file!.path)} (${value.start}:${value.end}) ",
            style: TextStyle(color: Colors.white, ),
          ),
        ),
      ),
      body: Container(
        color: AppColors.backgroundColor,
        width: double.infinity,
        child: Stack(
          children: [
            // main screen
            ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                //question
                Container(
                    margin: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<TestProvider>(
                          builder: (_, testProvider, __) {
                            return SizedBox(
                              width: 250,
                              child: Text(
                                "Q${testProvider.current_q_index + 1} ${testProvider.currentquestion.question}",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16),
                                    softWrap: true,
                                
                              ),
                            );
                          },
                        ),

                        //add a timer 00:00 min
                        //stop watch
                        Text(
                          formatTime(elapsedTimeInSeconds),
                          style: TextStyle(fontSize: 20, color: Colors.white54),
                        ),
                      ],
                    )),
                //card
                Container(
                  height: 700,
                  child: Card(
                    color: AppColors.lightbg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 16, left: 16),
                          child: Text(
                            "Your Answer:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4, left: 16, right: 16),
                          child: Text(
                            _speech_text,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),

            //mic button
            Container(
              padding: EdgeInsets.all(40),
              alignment: Alignment.bottomCenter,
              height: 1000,
              width: double.infinity,
              child: GestureDetector(
                onTapDown: (details) async {
                  if (!_islistening) {
                    var available = await speechToText.initialize();
                    if (available) {
                      setState(() {
                        _islistening = true;
                        speechToText.listen(onResult: (result) {
                          setState(() {
                            _speech_text = result.recognizedWords;
                          });
                        });
                      });
                    }
                  }
                },
                onTapUp: (details) {
                  setState(() {
                    _islistening = false;
                  });
                  speechToText.stop();
                },
                child: AvatarGlow(
                    animate: _islistening,
                    duration: Duration(milliseconds: 2000),
                    glowColor: Colors.purpleAccent,
                    repeat: true,
                    repeatPauseDuration: Duration(milliseconds: 100),
                    showTwoGlows: true,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 35,
                      child: Icon(
                        _islistening ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                      ),
                    ),
                    endRadius: 75.0),
              ),
            ),

            //bottom sheet
            DraggableScrollableSheet(
              initialChildSize: _sheet_height,
              controller: _dragController,
              minChildSize: 0.08,
              snapSizes: [0.08, 0.72],
              snap: true,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  height: 500,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))),
                  // height: double.infinity,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      //buttons
                      Stack(
                        children: [
                          Container(
                            height: screenheight * 0.076,
                            color: AppColors.backgroundColor,
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 35,
                                    width: 45,
                                    child: Icon(
                                      Icons.keyboard_arrow_up_sharp,
                                      size: 30,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightbg,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(
                                            20), // Adjust the radius as needed
                                        bottomRight: Radius.circular(
                                            20), // Adjust the radius as needed
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                          Container(
                            height: screenheight * 0.076,
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Row(children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _speech_text = "";
                                      });
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _speech_text =
                                            removeLastWord(_speech_text);
                                      });
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Consumer<TestProvider>(
                                builder: (context, testProvider, child) {
                                  return ElevatedButton(
                                      onPressed: () async {
                                        _sheet_height = 0.7;
                                        setState(() {
                                          resetStopwatch();
                                        });
                                        setState(() {});
                                        _sementic_similarity = await testProvider.getSemanticSimilarity(_speech_text);
                                         _literal_simiirity = await testProvider.getLiteralSimilarity(_speech_text);
                                         testProvider.questions[testProvider.current_q_index].sem_score = _sementic_similarity;
                                         testProvider.questions[testProvider.current_q_index].litScore = _literal_simiirity;
                                        // _sementic_similarity =
                                        //     await SimilarityUtils().getSS(
                                        //         _speech_text,
                                        //         testProvider
                                        //             .currentquestion.answer);
                                        // _literal_simiirity = testProvider
                                        //     .calculateLiteralSimilarity(
                                        //         _speech_text);
                                        setState(() {
                                         
                                        });
                                      },
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18),
                                      ));
                                },
                              )
                            ]),
                          ),
                        ],
                      ),

                      //row of progress bar and next button
                      Container(
                        padding: EdgeInsets.only(left: 14, right: 14, top: 8),
                        height: 130,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //sem_scores
                              Column(
                                children: [
                                  //semantic similarity
                                  Consumer<TestProvider>(
                                      builder: (_, testProvider, __) {
                                    return CircularPercentIndicator(
                                      radius: 40,
                                      percent: _sementic_similarity,
                                      backgroundWidth: 8,
                                      lineWidth: 8,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.purple[900],
                                      center: Text(
                                          "${(_sementic_similarity * 100).toStringAsFixed(2)}%"),
                                    );
                                  }),
                                  Text(
                                    'Sementic',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Similarity',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              //literal similarity
                              Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 40,
                                    percent: _literal_simiirity,
                                    backgroundWidth: 8,
                                    lineWidth: 8,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.purple[900],
                                    center: Text(
                                        "${(_literal_simiirity * 100).toStringAsFixed(2)}%"),
                                  ),
                                  Text(
                                    'Literal',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    'Similarity',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<TestProvider>(
                                    builder: (_, testProvider, __) {
                                      return ElevatedButton(
                                          onPressed: () {
                                            testProvider.nextquestion(context);
                                            _speech_text = "";
                                            _literal_simiirity = 0.0;
                                            _sementic_similarity = 0.0;
                                            startStopwatch();
                                          },
                                          child: Text(
                                            "Next Question",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ));
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Text("Remark: "),
                                      _sementic_similarity > 0.5
                                          ? Text(
                                              "Good",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.greenAccent),
                                            )
                                          : Text(
                                              "poor",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red),
                                            )
                                    ],
                                  )
                                ],
                              ),
                            ]),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
                        child: Text(
                          "Correct Answer",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.green,
                          ),
                        ),
                      ),

                      //Answer
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        width: double.infinity,
                        child: Consumer<TestProvider>(
                          builder: (_, testProvider, __) {
                            return Text(testProvider.currentquestion.answer);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
