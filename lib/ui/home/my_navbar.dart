import 'package:custom_line_indicator_bottom_navbar/custom_line_indicator_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oralprep/ui/Profile/profile.dart';
import 'package:oralprep/ui/auth/user_information_screen.dart';
import 'package:oralprep/ui/chat_bot/chat_bot_screen.dart';
import 'package:oralprep/ui/home/home.dart';




class MyNavbar extends StatefulWidget {
  const MyNavbar({super.key});

  @override
  State<MyNavbar> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int _selectedIndex = 0;
  //default index
  final List<Widget> _widgetOptions =  [
     HomeScreen(),
     UserInfromationScreen(),
     HomeScreen(),
     ChatBotScreen(),
     Placeholder(),
    // AllTestScreen(),
  
    


  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme  = Theme.of(context);
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
        body: SafeArea(child: _widgetOptions[_selectedIndex]),
        bottomNavigationBar: CustomLineIndicatorBottomNavbar(
          selectedColor: theme.primaryColor,
          unSelectedColor: Colors.black54,
          backgroundColor: Colors.black12.withOpacity(0.05),
          currentIndex: _selectedIndex,
          unselectedIconSize: 25,
          selectedIconSize: 30,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          enableLineIndicator: true,
          lineIndicatorWidth: 3,
          indicatorType: IndicatorType.Top,
          // gradient: LinearGradient(
          //   colors: [Colors.pink, Colors.yellow],
          // ),
          customBottomBarItems: [
            CustomBottomBarItems(
              label: 'Home',
              icon: Icons.home_rounded,
            ),
            CustomBottomBarItems(
              label: 'Library',
              icon: Icons.file_copy_rounded,
            ),
            CustomBottomBarItems(
              label: 'Notes',
              icon: Icons.feed,
            ),
            CustomBottomBarItems(
              label: 'Payment',
              icon: Icons.payment,
            ),
            CustomBottomBarItems(
              label: 'Account',
              icon: Icons.person,
            ),
          ],
        ));
  }
}
