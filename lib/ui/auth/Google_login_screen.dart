
import 'package:flutter/material.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/ui/auth/custombutton.dart';
import 'package:provider/provider.dart';





class GoogleSignInScreen extends StatelessWidget {
  const GoogleSignInScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
     
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            height: 80,
          ),
           Image.network("https://firebasestorage.googleapis.com/v0/b/oralprep-e19b1.appspot.com/o/logo_transparent_bg.png?alt=media&token=0a11171a-72a6-4029-a519-7af11f9402ad", height: 200,),
           SizedBox(
            height: 40,
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(22, 10, 0, 40),
              child: const Text(
                "SmartPrep.ai",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(22, 0, 0, 40),
              child: const Text(
                "Empowering Learners Everywhere with SmartPrep.ai:\n Your Personalized Path to Smarter, Successful Study.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            margin: EdgeInsets.all(16),
            child: CustomButton(onPressed:(){
              userProvider.signInWithGoogle(context);
            }, text: 'GET STARTED', ),
            // child:ElevatedButton(
            //   onPressed: () {
            //     userProvider.signInWithGoogle(context);
                
            //   },
            //   child: Row(

            //     mainAxisAlignment: MainAxisAlignment.center,



            //     children: [

            //       SizedBox(width: 20,),
            //       Text(
            //     'GET STARTED',
            //     style: TextStyle(fontSize: 22),
            //   ),]
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20), // Set the desired radius here
            //     ),
            //   ),
            // ) ,
          ),

        ],
      )),
    );
  }
}
