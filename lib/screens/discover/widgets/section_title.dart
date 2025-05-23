import 'package:flutter/material.dart';
import 'package:olly_chat/screens/discover/screens/category_list.dart';
import 'package:olly_chat/screens/discover/widgets/all_posts.dart';
import 'package:olly_chat/theme/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
    final ScrollController? scrollController;
  const SectionTitle({super.key, required this.title, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18
          )),
          GestureDetector(
            onTap: (){

         title == "What’s Your Mood Today?" ? Navigator.push(context, MaterialPageRoute(builder: (context){
          return CategoryListScreen();
         }))  :  null;

            },
            child: title == "What’s Your Mood Today?" ?  Icon(Icons.arrow_forward, color: AppColors.secondaryColor, size: 30): Container(),
          ),
        ],
      ),
    );
  }
}
