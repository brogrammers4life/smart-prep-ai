import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oralprep/provider/user_provider.dart';
import 'package:oralprep/utils/colors.dart';
import 'package:oralprep/utils/lava/lava_clock.dart';
import 'package:provider/provider.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  State<IntroPage1> createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: LavaAnimation(
              color: AppColors.primary,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          "SmartPrep.ai",
                          style: GoogleFonts.lato(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Your Personalized Path to Smarter, Successful Study.",
                          style: TextStyle(fontSize: 20, color: Colors.white54),
                        ),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              dense: true,
                              title: Text(
                                "Your personal tutor for effective learning",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white54),
                              ),
                            ),
                            ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              dense: true,
                              title: Text(
                                "Adaptive learning that gets you test-ready",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: Colors.white54),
                              ),
                            ),
                            ListTile(
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              dense: true,
                              title: Text(
                                  "Making self-paced learning enjoyable and effective",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white54,
                                      )),
                            )
                          ],
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black54,
        child: Padding(
          padding:  EdgeInsets.fromLTRB( 16,  0, 16, 24),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(18)),
            onPressed: () {
              userProvider.signInWithGoogle(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/google.png", height: 30),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Google Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
