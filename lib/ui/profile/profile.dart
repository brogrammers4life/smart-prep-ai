import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/ui/Profile/heat_map.dart';
import 'package:oralprep/ui/auth/Google_login_screen.dart';
import 'package:provider/provider.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
  final up = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed out");
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => GoogleSignInScreen()));
              });
            },
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(200, 100),
                    bottomRight: Radius.elliptical(200, 100),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: 120,
              ),
              Positioned(
                bottom: -50,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                  radius: 70,
                ),
              ),
            ],
          ),
          SizedBox(height: (10 + 50)),
          // name
          Text(
            up.user.displayName.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.grey
            ),
          ),

          // email id
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email_outlined,
                size: 20,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                up.user.email.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          MyHeatMap(),

          SizedBox(height: 16),
        ],
      ),
    );
  }
}
