import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:olly_chat/screens/discover/components/container_image.dart';
import 'package:olly_chat/screens/discover/screens/categories.dart';
import 'package:olly_chat/screens/discover/screens/categories_posts_screen.dart';
 

class TopicList extends StatelessWidget {
  TopicList({super.key});

  final List<Category> categories = [
    Category(name: 'Love', imagePath: 'https://images.unsplash.com/photo-1544911845-1f34a3eb46b1?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzR8fGxvdmV8ZW58MHx8MHx8fDA%3D'),
    Category(name: 'Art', imagePath: 'https://images.unsplash.com/photo-1547891654-e66ed7ebb968?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YXJ0fGVufDB8fDB8fHww'),
    Category(name: 'Health', imagePath: 'https://images.unsplash.com/photo-1549890762-0a3f8933bc76?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fGhlYWx0aHxlbnwwfHwwfHx8MA%3D%3D'),
    Category(name: 'Emotional', imagePath: 'https://images.unsplash.com/photo-1496188757881-c6753f20c306?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjR8fGVtb3Rpb25hbHxlbnwwfHwwfHx8MA%3D%3D'),
    Category(name: 'Entertainment', imagePath: 'https://images.unsplash.com/photo-1415886541506-6efc5e4b1786?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
    Category(name: 'Sports', imagePath: 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHNwb3J0c3xlbnwwfHwwfHx8MA%3D%3D'),
    Category(name: 'Education', imagePath: 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGVkdWNhdGlvbnxlbnwwfHwwfHx8MA%3D%3D'),
    Category(name: 'Travel', imagePath: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjJ8fHRyYXZlbHxlbnwwfHwwfHx8MA%3D%3D'),
    Category(name: 'Food', imagePath: 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzF8fGZvb2R8ZW58MHx8MHx8fDA%3D'),
    Category(name: 'Lifestyle', imagePath: 'https://images.unsplash.com/photo-1501504905252-473c47e087f8?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 240,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: true,
          height: MediaQuery.of(context).size.height / 2 - 240,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          viewportFraction: 0.6,  // Show 2 cards at a time
        ),
        itemCount: categories.length,
        itemBuilder: (context, index, realIndex) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPostsScreen(
                      category: categories[index].name,
                    ),
                  ),
                );
              },
              child: ContainerImage(
                categ: categories[index].name,
                image: categories[index].imagePath!,
              ),
            ),
          );
        },
      ),
    );
  }
}
