import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oralprep/ui/Profile/profile.dart';
import 'package:oralprep/ui/chat_bot/chat_bot_screen.dart';
import 'package:oralprep/ui/home/userprofile_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
       
                Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
              
        }, icon: Icon(Icons.person),),
          title: Center(
            child: Text(
              "SmartPrep.ai",
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.purple
              ),
            ),
          ),
          actions: [
            // IconButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
            //   },
            //   icon: Icon(Icons.person),
            // ),
             IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: ((context) => ChatBotScreen())));
              },
              icon: Icon(Icons.chat),
            ),
          ]),
     
      body: UserProfileCard(),
    );
  }
}
