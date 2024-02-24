import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:oralprep/provider/test_provider.dart';
import 'package:oralprep/utils/colors.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          height: height,
          child: Column(
            children: [
              Consumer<TestProvider>(
                builder: (_, TestProvider, __) {
                  return Lottie.network(
                    "https://assets2.lottiefiles.com/packages/lf20_RCg95xabXd.json",
                    // controller: _animationController,
                    height: 600,
                    
                    width: double.infinity,
                    // onLoaded: (composition) {
                    //   // Configure the AnimationController with the duration of the
                    //   // Lottie file and start the animation.
                    //   _animationController
                    //     ..duration = composition.duration
                    //     ..forward();
                    // },
                  );
                },
              ),

              Container(
                width: double.infinity,
                child: Text(
                  "Hold On",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.lightPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              //Text
              Container(
                width: double.infinity,
                child: Text(
                  "we're Preparing Your test...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white54
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
