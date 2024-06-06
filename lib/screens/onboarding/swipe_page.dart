import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:olly_chat/screens/onboarding/onboarding.dart';

class SwipePage extends StatelessWidget {
   SwipePage({super.key});

  final pages = [

    const OnboardingScreen(image: 'assets/images/idea.png', headText: 'Welcome to VoiceHub', slogan: '', backgroundColor: '', textColor: Colors.white, color: Colors.black,),
     const OnboardingScreen(image: 'assets/images/bro.png', headText: '', slogan: '', backgroundColor: '', textColor:Colors.black, color:Colors.white,),
     const OnboardingScreen(image: 'assets/images/lady.png', headText: '', slogan: '', backgroundColor: '', textColor:Colors.white,color: Colors.blueAccent,),
 

  ];

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      fullTransitionValue: 300,
     
        enableLoop: true,
        positionSlideIcon: 0.5,
        waveType: WaveType.circularReveal,
        onPageChangeCallback: (page) => print("Page $page selected"),
        slideIconWidget: const Icon(Icons.arrow_back_ios),
      pages: pages);
  }
}