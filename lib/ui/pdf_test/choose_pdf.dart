import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:oralprep/main.dart';
import 'package:oralprep/model/q_set.dart';
import 'package:oralprep/provider/test_provider.dart';
import 'package:oralprep/repository/choose_pdf_util.dart';
import 'package:oralprep/ui/test/loading/rocket_animation.dart';
import 'package:oralprep/ui/test/test_screen.dart';
import 'package:oralprep/utils/response.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class R {
  static Color darkgrey = Color(0xff202427);
  static Color lightgrey = Color(0xff363636);
}

class ChoosePdf extends StatefulWidget {
  const ChoosePdf({Key? key}) : super(key: key);

  @override
  State<ChoosePdf> createState() => _ChoosePdfState();
}

class _ChoosePdfState extends State<ChoosePdf> {
  late ScrollController _scrollController;
  TextEditingController _startcontroller = TextEditingController();
  TextEditingController _endcontroller = TextEditingController();

  int selected_subject = -1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startcontroller.text = "0";
    _endcontroller.text = "0";
  }

  final List<String> subjects = [
    'Science',
    'History',
    'Biology',
    
    'Theory',
    'Others',
    'OpenAI',
  ];

  File? file;
  int startNumber = 0;
  int endNumber = 0;

  String selectedValue = "10";
  List<String> options = ["2", "5", "10", "15", "30"];

  void _pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    } else {}
  }

  void incrementStartNumber() {
    setState(() {
      int number = int.parse(_startcontroller.text) + 1;
      _startcontroller.text = '$number';
      
    });
    
  }

  void decrementStartNumber() {
    setState(() {
      int number = int.parse(_startcontroller.text) - 1;
      _startcontroller.text = '$number';
    });
  }

  void incrementEndNumber() {
    setState(() {
      int number = int.parse(_endcontroller.text) + 1;
      _endcontroller.text = '$number';
    });
  }

  void decrementEndNumber() {
    setState(() {
      int number = int.parse(_endcontroller.text) - 1;
      _endcontroller.text = '$number';
    });
  }

  Widget buildTabBox(String subject, int index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          selected_subject = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: index == selected_subject ? AppColors.primary:  R.lightgrey ),
        child: Text(
          subject,
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Oral Test",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
       ),
      body: Container(
        width: double.infinity,
        child: Card(
          color: R.darkgrey,
          child: ListView(
            children: [
              //upload chapter pdf
              Container(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                width: double.infinity,
                child: Text(
                  "Chapter PDF:",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: R.lightgrey,
                ),
                child: file == null
                    ? GestureDetector(
                        onTap: () => _pickfile(),
                        child: Container(
                          height: 70,
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Icon(
                                    Icons.file_upload_outlined,
                                    size: 30,
                                    color: Colors.white60,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Upload File",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white60),
                                ),
                              ]),
                        ),
                      )
                    : ListTile(
                        leading: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: R.darkgrey,
                                borderRadius: BorderRadius.circular(4)),
                            child: Image.asset(
                              "assets/icons/file.png",
                              height: 20,
                              color: Colors.grey,
                            )),
                        title: Text(
                          file == null
                              ? "NO File"
                              : path.basename(file.toString()),
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          file == null
                              ? "- kB"
                              : FileUtils.getFileSize(file!.path),
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    _pickfile();
                                  },
                                  icon: Image.asset(
                                    "assets/icons/write.png",
                                    color: Colors.grey,
                                    width: 16,
                                  )),
                            ],
                          ),
                        )),
              ),
              //subject
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                width: double.infinity,
                child: Text(
                  "Select Subject:",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              //tabs
              Container(
                height: 63,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    return buildTabBox(subjects[index], index);
                  },
                ),
              ),
              //page range
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                width: double.infinity,
                child: Text(
                  "Page Range:",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              //page range input section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                height: 160,
                child: Column(
                  children: [
                    //starting page
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Start page ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white54),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: decrementStartNumber,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: R.lightgrey,
                                  child: Center(
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: _startcontroller,
                                      style: TextStyle(color: Colors.white70),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: R.lightgrey,
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: incrementStartNumber,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'End page ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white54),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: decrementEndNumber,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  color: R.lightgrey,
                                  child: Center(
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      controller: _endcontroller,
                                      style: TextStyle(color: Colors.white70),
                                      decoration: InputDecoration(
                                          filled: true,
                                          fillColor: R.lightgrey,
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: incrementEndNumber,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //take test
                  ],
                ),
              ),

              //number of question
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                width: double.infinity,
                child: Text(
                  "Select Number of questions:",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: Colors.white),
                ),
                child: DropdownButton<String>(
                  dropdownColor: R.darkgrey,
                  // Set the value to the selected value
                  value: selectedValue,
                  // Generate the items from the list of options
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,

                      child: Container(
                        child: Text(
                          option,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  // borderRadius: BorderRadius.circular(10.0),
                  padding: EdgeInsets.all(9),
                ),
              ),
              //take test
              Container(
                height: 80,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Consumer<TestProvider>(
                  builder: (_, testProvider, __){
                    return ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.primary)),
                    onPressed: () async{

                     
             
                     
                      //  testProvider.setupTestFromPdf(file!, int.parse(_startcontroller.text) , int.parse(_endcontroller.text), int.parse(selectedValue));
                      testProvider.questions = [];
                       testProvider.setupTestFromUrl("https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/Digests%2Fhistory_10.pdf?alt=media&token=aacefd38-b4bc-44a9-92cd-b627b35ffe7e", int.parse(_startcontroller.text) , int.parse(_endcontroller.text), int.parse(selectedValue));

                       
                          Navigator.of( context).push(MaterialPageRoute(builder: (context)=> TestScreen()));

                    
                      
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Take Test",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 30,
                        )
                      ],
                    ));
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
