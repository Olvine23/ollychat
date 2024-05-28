import 'package:flutter/material.dart';
import 'package:olly_chat/screens/discover/components/container_image.dart';
import 'package:olly_chat/screens/discover/widgets/topic_list.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      appBar: AppBar(
        title: Text("Explore By Topics", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [Icon(Icons.search)],
      ),

      body:  GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2, // number of items in each row
    mainAxisSpacing: 8.0, // spacing between rows
    crossAxisSpacing: 8.0, // spacing between columns
  ),
  padding: EdgeInsets.all(8.0), // padding around the grid
  itemCount: 10, // total number of items
  itemBuilder: (context, index) {
    return ContainerImage();
  },
)
    );
  }
}