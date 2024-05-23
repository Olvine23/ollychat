import 'package:flutter/material.dart';
import 'package:olly_chat/screens/home/widgets/article_card.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 1000,
        itemBuilder: (context, index){
          return  ArticleCard(articleimg: 'https://images.unsplash.com/photo-1715942163404-b44e0808536b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw4fHx8ZW58MHx8fHx8' , author: "Olivne", authorImg: "", daysago: DateTime.now(), title: '', genre: 'xxx');
        }
        
        ),
    );
  }
}