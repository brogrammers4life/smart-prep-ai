import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oralprep/model/book.dart';
import 'package:oralprep/provider/ocr_test_provider.dart';
import 'package:oralprep/provider/test_provider.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/ui/home/radar_chart/radar_chart.dart';
import 'package:oralprep/ui/pdf_test/choose_pdf.dart';
import 'package:oralprep/ui/test/submission/submision_page.dart';
import 'package:oralprep/ui/test/test_screen.dart';
import 'package:oralprep/utils/utils.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:oralprep/utils/colors.dart';
import 'bar_graph/bar_graph.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProfileCard extends StatelessWidget {
  UserProfileCard({Key? key}) : super(key: key);

  List<Book> books = [
    new Book(
        name: "History",
        pdfUrl:
            "https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/Digests%2Fhistory_10.pdf?alt=media&token=aacefd38-b4bc-44a9-92cd-b627b35ffe7e",
        pageNumber: 23,
        start: 12,
        end: 16),
    new Book(
        name: "Geography",
        pdfUrl:
            "https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/Digests%2Fgeography_10.pdf?alt=media&token=6cbff7e1-76a2-43d4-8c5f-2cf487c857f8",
        pageNumber: 15,
        start: 7,
        end: 9),
    new Book(
        name: "Science",
        pdfUrl:
            "https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/Digests%2Fhistory_10.pdf?alt=media&token=aacefd38-b4bc-44a9-92cd-b627b35ffe7e",
        pageNumber: 23,
        start: 8,
        end: 10),
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final TestProvider testProvider = Provider.of<TestProvider>(context);
    final OcrTestProvider ocr_test_provider =
        Provider.of<OcrTestProvider>(context);

    return Consumer<UserProvider>(builder: (_, userProvider, __) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: AppColors.backgroundColor,
        ),
        child: ListView(
          children: [
            Container(
              height: 125,
              width: double.infinity,
              // padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    CircleAvatar(
                        maxRadius: 40,
                        backgroundImage:
                            AssetImage("assets/images/avatar.png")),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userProvider.name,
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          Text(
                            userProvider.tags[0],
                            style:
                                TextStyle(fontSize: 14, color: Colors.white54),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            // width: 90,
                            height: 28,
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.star,
                                //   color: Colors.yellow,
                                // ),
                                Text("🔥 " + userProvider.rating,
                                    style: TextStyle(color: Colors.white54)),
                                SizedBox(
                                  width: 20,
                                ),

                                Text(userProvider.userModel.grade,
                                    style: TextStyle(color: Colors.white54)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                color: AppColors.lightbg,
              ),
            ),

            //title("take oral test")
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "Take Oral Test",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            //grid
            Container(
              height: 170,
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ChoosePdf()));
                    },
                    child: Card(
                      elevation: 8, // Adjust the elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.all(8),
                      color: AppColors.lightbg,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.upload_file_outlined,
                              size: 60,
                              color: Colors.white54,
                            ),
                          ),
                          Text(
                            "Upload Pdf",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await ocr_test_provider.scanImage(context);

                      Future.delayed(Duration(milliseconds: 10000), () {
                        testProvider.questions = [];
                        testProvider.setupTestFromPdf(
                            File("assets/images/ocr_test.pdf"), 0, 1, 5);
                      });

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TestScreen()));

                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => SubmissionPage()));
                    },
                    child: Card(
                      elevation: 8, // Adjust the elevation as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.all(8),
                      color: AppColors.lightbg,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.image_search,
                              size: 60,
                              color: Colors.white54,
                            ),
                          ),
                          Text(
                            "Scan Image",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            //title("EVALUATE THIS WEEK")
            Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Evaluate this Week",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "(Test Score)",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 4,),

                  Center(
                    child: Text("september 12 - september 18",
                        style: TextStyle(color: Colors.grey, fontSize: 15)),
                  )
                ],
              ),
            ),
            //bar graph
            SizedBox(
              height: 14,
            ),
            Container(
                // padding: EdgeInsets.all(8),
                height: 200,
                child: MyBarGraph(weeklySummary: userProvider.weeklySummary)),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "Recently Opened",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(
                height: 290,
                child: ListView.builder(
                  itemCount: books.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            books[index].name,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "${books[index].pageNumber} pages",
                            style: TextStyle(color: Colors.white54),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              testProvider.questions = [];
                              testProvider.setupTestFromUrl(books[index].pdfUrl,
                                  books[index].start, books[index].end, 5);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => TestScreen()));
                            },
                            icon: Icon(Icons.arrow_forward_ios),
                          ),
                          leading: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: AppColors.lightbg,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Image.asset(
                                "assets/icons/file.png",
                                height: 20,
                                color: Colors.grey,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            color: Colors.grey, // Change color as needed
                            height: 1, // Thickness of the divider
                          ),
                        ),
                      ],
                    );
                  },
                )),

                 Container(
              padding: EdgeInsets.all(8),
              child: Text(
                "Subjectwise Analysis",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            RadarChartExample()

          ],
        ),
      );
    });
  }
}
