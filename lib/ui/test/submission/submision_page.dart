import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oralprep/model/q_set.dart';
import 'package:oralprep/provider/test_provider.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/ui/test/submission/performace_card_chart_widget.dart';
import 'package:provider/provider.dart';

class SubmissionPage extends StatefulWidget {
  // late List<Question> questions;
  SubmissionPage( {Key? key}) : super(key: key);

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
//   void addDataToFirebase() async {
//     final up = Provider.of<UserProvider>(context);
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(up.user.email)
//         .collection("tests")
//         .doc(Random().nextInt(50).toString())
//         .set({"qna": widget.questions});
//   }


  @override
  Widget build(BuildContext context) {
    final tp = Provider.of<TestProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Result page"),
      ),       
      body: Container(
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              width: double.infinity,
              child: Text(
                "Score Analysis",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            PerformanceCardChartWidget(
                text: 'Sementic Score Analysis',
                sem_data: [90, 40, 20, 0, 0, 0],
                lit_data: [18, 10, 0, 0, 0, 0],),
            // PerformanceCardChartWidget(
            //   text: 'Literal Score Analysis',
            //   data: [18, 10, 20, 76, 43, 10],
            // ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              width: double.infinity,
              child: Text(
                "Evaluation per Question",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

           Container(
            height: 500,
            child:  ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: tp.questions.length,
              itemBuilder: (context, index) {
              return ListTile(
                title: Text(tp.questions[index].question, style: TextStyle(color: Colors.white70),),
                subtitle: Text("Score : ${tp.questions[index].sem_score*100}%",style: TextStyle(color: Colors.white54 ),),
                trailing: Icon(Icons.keyboard_arrow_right_outlined, size: 30,),
              );
            },),),

             Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              width: double.infinity,
              child: Text(
                "Begin Next Test",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: (){}, child: Text("Go Home")),),
                  Expanded(child: ElevatedButton(onPressed: (){}, child: Text("Next Test")),)
                ],
              ),
            ),
            ListView.builder(itemBuilder: (context, index) {
              return ListTile(
                title: Text(""),
              );
            },)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

      }, child: Icon(Icons.done,),),
    
    );
  }

}