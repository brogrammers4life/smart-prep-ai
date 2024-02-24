import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oralprep/model/UserModel.dart';
import 'package:oralprep/ui/auth/user_information_screen.dart';
import 'package:oralprep/ui/home/home.dart';
import 'package:oralprep/ui/home/my_navbar.dart';

import 'package:oralprep/utils/response.dart';
import 'package:oralprep/utils/utils.dart';
import 'package:provider/provider.dart';

final API_KEY = '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';

class UserProvider extends ChangeNotifier {
  late User user;
  String _name = "Abhishek Sinha";
  String _image_url = "asset/images/avatar.png";
  List<String> tags = ["SSC Board"];
  String rating = '4.5';
  String location = 'Mumbai';
  UserModel userModel = UserModel(name: "Abhishek Sinha", age: "19", grade: "Grade 9", board: "SSC Board");

  bool isLoading = false;

  Response login_response = failure();
  List<double> weeklySummary = [
    42.42,
    89.9,
    67.70,
    56.32,
    16.19,
    83.89,
    23.03,
  ];

  String get name => _name;
  String get image_url => _image_url;

  set name(String name) => _name = name;
  set imageurl(String image_url) => _image_url = image_url;

  void signInWithGoogle(BuildContext context) async {
    login_response = loading();
    FirebaseAuth auth = FirebaseAuth.instance;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user!;
        login_response = success();
        print(login_response);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => UserInfromationScreen()));
        
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          login_response = failure();

          // handle the error here
          showSnackBar(context, e.toString());
        } else if (e.code == 'invalid-credential') {
          login_response = failure();

          // handle the error here
          showSnackBar(context, e.toString());
        }
      } catch (e) {
        login_response = failure();
        // handle the error here
        showSnackBar(context, e.toString());
      }
    }

    return;
  }
}
