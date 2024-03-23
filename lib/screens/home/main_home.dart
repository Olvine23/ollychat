import 'package:flutter/material.dart';
import 'package:olly_chat/screens/home/components/greetings.dart';
import 'package:olly_chat/screens/home/components/recent_articles.dart';
import 'package:olly_chat/screens/home/components/row_title.dart';
import 'package:olly_chat/screens/home/components/top_section.dart';
import 'package:olly_chat/theme/colors.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             const Padding(
                padding: EdgeInsets.only(right: 20.0, ),
                child: TopSection(),
              ),
             const  Greetings(name: "Olvine"),
               Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const  RowTitle(text: 'Recent Articles',),
                InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.secondaryColor,
                      size: 30,
                    )),
              ],
            ),
          ),
          Articles()
        
            ],
          ),
        ),
      ),
    );
    
  }
}