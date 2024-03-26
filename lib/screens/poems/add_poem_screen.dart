import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class AddPoemScreen extends StatefulWidget {
  final MyUser myUser;
  const AddPoemScreen(this.myUser,{super.key});

  @override
  State<AddPoemScreen> createState() => _AddPoemScreenState();
}

class _AddPoemScreenState extends State<AddPoemScreen> {
late Post post;
  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }

  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  String description = 'Article goes here ';
  List<String> topics = ["Love", "Art", "Sadness"];
  String selectedItem = "Love";
  @override
  Widget build(BuildContext context) {
    log(post.toString());

    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
         if(state is CreatePostSuccess){
          Navigator.pop(context);
         }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Create",
            style:
                Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white),
              child: const Text("Save"),
            ),
            const SizedBox(
              width: 4,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    width: 1.0,
                    color: AppColors.primaryColor,
                  )),
              onPressed: () {
                setState(() {
                  post.title = titleController.text;
                  post.thumbnail = "image";
                
                });
                context.read<CreatePostBloc>().add(CreatePost(post));
              },
              child: const Text("Publish"),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.greenWhite,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_rounded,
                        size: 80,
                      ),
                      Text("Add article cover image"),
                    ],
                  )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Title",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 20),
                    )),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: titleController,
                  hintText: 'Title',
                  obscureText: false,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Tell your story ...",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 20),
                    )),
                const SizedBox(
                  height: 10,
                ),
                MarkdownTextInput(
                  controller: bodyController,
                  (String value) => setState(() => description = value),
                  description,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Select Topics",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontSize: 20),
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(width: 0.5, color: Colors.grey))),
                      value: selectedItem,
                      items: topics.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedItem = newValue!;
                        });
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
