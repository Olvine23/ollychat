import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/screens/onboarding/widgets/commontext.dart';
import 'package:olly_chat/screens/welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String image;
  final String headText;
  final Color color;
  final Color textColor;
  final String slogan;
  final String backgroundColor;
   
  const OnboardingScreen({super.key, required this.image, required this.headText, required this.slogan, required this.backgroundColor, required this.textColor, required this.color});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset('assets/images/nobg.png', height: 100),
            ),
            Positioned(
              top: 35,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return WelcomeScreen();
                  }));
                },
                child: const Align(
                  alignment: Alignment.topRight,
                  child: CommonText(text: "Skip"),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(widget.image),
            ),
            Positioned(
              bottom: 160,
              left: 15,
              right: 15, // Add right to allow for padding/margin on the right
              child: Text(
                "Welcome to VoiceHub",
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: 22.dp, fontWeight: FontWeight.bold),
                overflow: TextOverflow.visible, // Handle overflow
              ),
            ),
            Positioned(
              bottom: 100,
              left: 15,
              right: 15, // Add right to allow for padding/margin on the right
              child: Text(
                "Unleash your thoughts and craft them to a reality",
                style: TextStyle(fontSize: 16, color: widget.textColor),
                overflow: TextOverflow.visible, // Handle overflow
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
