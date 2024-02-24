import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oralprep/main.dart';
import 'package:oralprep/model/UserModel.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/repository/choose_pdf_util.dart';
import 'package:oralprep/ui/auth/custombutton.dart';
import 'package:oralprep/ui/home/home.dart';
import 'package:oralprep/ui/pdf_test/choose_pdf.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class UserInfromationScreen extends StatefulWidget {
  const UserInfromationScreen({super.key});

  @override
  State<UserInfromationScreen> createState() => _UserInfromationScreenState();
}

class _UserInfromationScreenState extends State<UserInfromationScreen> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final bioController = TextEditingController();
   File? file;
  String selectedValue = "Grade 10";
  String boardSelected = "SSC Board";
  List<String> options = [
    "Grade 8",
    "Grade 9",
    "Grade 10",
  ];

  List<String> boardOptions = [
    "SSC Board",
    "CBSE Board",
    "ICSE Board",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProvider up = Provider.of<UserProvider>(context, listen: false);

    nameController.text = up.user.displayName ?? "";
    ageController.text = up.user.email ?? "";
    
  }


  late String _imageUrl;

  Future<void> _uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    final storage = FirebaseStorage.instance;

    try {
      // Pick an image from the device gallery
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageFile = File(image.path);

      // Upload the image to Firebase Storage
      final ref = storage.ref().child('user_images/$userId/${DateTime.now()}.jpg');
      await ref.putFile(imageFile);

      // Get the download URL of the uploaded image
      final imageUrl = await ref.getDownloadURL();

      // Update Firestore with the image URL
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });

      setState(() {
        _imageUrl = imageUrl;
      });
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    bioController.dispose();
  }

    void _pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<UserProvider>(context, listen: true).isLoading;
    return Scaffold(
      appBar: AppBar(title: Text("Enter your information")),
      body: SafeArea(
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.lightPrimary,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 5),
                        child: Column(
                          children: [
                             Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              width: double.infinity,
                              child: Text(
                                "Name: ",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ),
                            // name field
                            textFeld(
                              context: context,
                              hintText: "Name",
                              icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nameController,
                              
                            ),
                             Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              width: double.infinity,
                              child: Text(
                                "Email: ",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ),

                            // email
                            textFeld(
                              context: context,
                              hintText: "Email",
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              maxLines: 1,
                              controller: ageController,
                            ),
                            //number of question
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              width: double.infinity,
                              child: Text(
                                "Select Grade: ",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ),
                            //select GRade
                            Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 24),
                              width: double.infinity,
                             
                              decoration: BoxDecoration(
                                color: AppColors.lightbg,
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.white),
                              ),
                              child: DropdownButton<String>(
                                dropdownColor: AppColors.lightbg,
                                underline: SizedBox(),
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
                                        style: TextStyle(color: Colors.white),
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

                                //number of board
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              width: double.infinity,
                              child: Text(
                                "Select Education Board: ",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 18),
                              ),
                            ),
                            //select GRade
                            Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 24),
                              width: double.infinity,
                             
                              decoration: BoxDecoration(
                                color: AppColors.lightbg,
                                borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.white),
                              ),
                              child: DropdownButton<String>(
                                dropdownColor: AppColors.lightbg,
                                underline: SizedBox(),
                                // Set the value to the selected value
                                value: boardSelected,
                                // Generate the items from the list of options
                                items: boardOptions.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Container(
                                      child: Text(
                                        option,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    boardSelected = newValue!;
                                  });
                                },
                                // borderRadius: BorderRadius.circular(10.0),
                                padding: EdgeInsets.all(9),
                              ),
                            ),
                            // give marksheet 
                              Container(
                padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
                width: double.infinity,
                child: Text(
                  "Latest School Marksheet:",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ),
              Container(
                // margin: EdgeInsets.fromLTRB(24, 16, 24, 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // color: R.lightgrey,
                  color: AppColors.lightbg
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
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Upload Marksheet",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
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
                          style: TextStyle(color: Colors.black),
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Continue",
                          onPressed: ()  {
                            storeData();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => HomeScreen())));

                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget textFeld({
    required BuildContext context,
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: AppColors.primary,
        controller: controller,
       style: TextStyle(color: Colors.white),
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).cardColor,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  BorderSide(
              color: Colors.white,
            ),
          ),
          focusColor: Colors.white,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[700]),
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: theme.brightness == Brightness.dark
              ? AppColors.lightbg
              : Colors.grey[300],
          filled: true,
          
        ),
      ),
    );
  }

  // store user data to database
  void storeData() async {
    final up = Provider.of<UserProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      age: ageController.text.trim(),
      grade: selectedValue,
      board: boardSelected,
    );
    userModel.weak_topic = <String , double>{
      "History" :  0.69,
      "Science" : 0.4,
    }.cast<String, double>();
    userModel.weak_topic = <String , double>{
      "Geography" :  0.90,
      "Maths" : 0.94,
      "Marathi" : 0.87,
    }.cast<String, double>();

   await FirebaseFirestore.instance
    .collection("users")
    .doc(up.user.email)
    .set(userModel.toMap())
    .then((_) {
      print("Success");
    })
    .catchError((error) {
      print("Error: $error");
    });

    up.userModel = userModel;

    // if (nameController.text != "" && ageController.text != "") {
    //   ap.saveUserDataToFirebase(
    //     context: context,
    //     userModel: userModel,

    //     onSuccess: () {
    //       ap.saveUserDataToSP().then(
    //             (value) => ap.setSignIn().then(
    //                   (value) => Navigator.pushAndRemoveUntil(
    //                       context,
    //                       MaterialPageRoute(
    //                         builder: (context) => SelectExamScreen(),
    //                       ),
    //                       (route) => false),
    //                 ),
    //           );
    //     },
    //   );
    // } else {
    //   showSnackBar(context, "Please enter the required fields");
    // }
  }
}

