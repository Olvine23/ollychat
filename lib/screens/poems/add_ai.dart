import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:olly_chat/main.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class AddWithAI extends StatefulWidget {
  final MyUser myUser;
  const AddWithAI(this.myUser, {super.key});

  @override
  State<AddWithAI> createState() => _AddWithAIState();
}

class _AddWithAIState extends State<AddWithAI> {
  File? imageFile;
  String? imageUrl;
  bool loading = false;
  late Post post;
  late String imageString = '';
  String text = '';

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
  final gemmy = GoogleGemini(apiKey: apiKey!);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          setState(() {
            loading = false;
          });
          context.read<GetPostBloc>().add(const GetPosts());
          Navigator.pop(context, state.post);
        } else if (state is CreatePostLoading) {
          setState(() {
            loading = true;
          });
        } else if (state is CreatePostFailure) {
          setState(() {
            loading = false;
          });
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
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await gemmy
                    .generateFromTextAndImages(
                        image: imageFile!,
                        query:
                            "Write an interesting and creative poem from the image which has the name ${titleController.text}.")
                    .then((value) {
                  if (value.text.isEmpty) {
                    setState(() {
                      loading = false;
                    });
                    _showCustomDialog(context, "Whoopsie ...try another image");
                  }
                  setState(() {
                    loading = false;
                    text = value.text;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(

                      content: Text('Article generated successfully'),
                    ),
                  );
                  print(text);
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  print(error.toString());
                  _showCustomDialog(context, error.toString());
                });
              },
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
              onPressed: () async {
                setState(() {
                  loading = true;
                  imageFile = File(imageString);
                  post.body = text;
                  post.title = titleController.text;
                  post.genre = selectedItem;
                });
                context
                    .read<CreatePostBloc>()
                    .add(CreatePost(post, imageString));
              },
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : const Text("Publish"),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
          ],
        ),
        body: loading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("We are working on some cool stuff, hold on"),
                  SizedBox(
                    height: 2.h,
                  ),
                  Lottie.asset('assets/lotti/creating.json'),
                ],
              ))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Articles will be generated based on the picked image and title",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: AppColors.primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Select an image",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 100);
                          if (image != null) {
                            CroppedFile? croppedFile = await ImageCropper()
                                .cropImage(
                                    sourcePath: image.path,
                                    aspectRatioPresets: [
                                  CropAspectRatioPreset.square
                                ],
                                    uiSettings: [
                                  AndroidUiSettings(
                                      toolbarTitle: 'Cropper',
                                      toolbarColor:
                                          Theme.of(context).colorScheme.primary,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio:
                                          CropAspectRatioPreset.original,
                                      lockAspectRatio: false),
                                  IOSUiSettings(
                                    title: 'Cropper',
                                  ),
                                ]);
                            if (croppedFile != null) {
                              print(imageString);
                              setState(() {
                                imageString = croppedFile.path;
                                imageFile = File(croppedFile.path);
                              });
                            }
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: imageFile == null
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      size: 80,
                                      color: AppColors.secondaryColor,
                                    ),
                                    Text(
                                      "Tap to add article image",
                                      style: TextStyle(
                                          color: AppColors.secondaryColor),
                                    ),
                                  ],
                                ))
                              : Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                ),
                        ),
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
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.bold),
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
                            "Generated article will appear here",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      MarkdownTextInput(
                        controller: bodyController,
                        (String value) => setState(() => text = value),
                        text,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Select Topics",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButtonFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        width: 0.5, color: Colors.grey))),
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

  void _showCustomDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Whoopsie, our bad 😞",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  "We couldn't use that image. Please pick another ",
                  style: TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
