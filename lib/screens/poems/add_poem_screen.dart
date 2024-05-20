import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:olly_chat/main.dart';
import 'package:olly_chat/screens/poems/snippies/screenshotsnip.dart';
import 'package:olly_chat/screens/poems/snippies/snippy.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class AddPoemScreen extends StatefulWidget {
  final MyUser myUser;
  const AddPoemScreen(this.myUser, {super.key});

  @override
  State<AddPoemScreen> createState() => _AddPoemScreenState();
}

class _AddPoemScreenState extends State<AddPoemScreen> {
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
  HtmlEditorController controller = HtmlEditorController();
  final bodyController = TextEditingController();
  String description = 'Article goes here ';
  List<String> topics = ["Love", "Art", "Sadness"];
  String selectedItem = "Love";
  final gemmy = GoogleGemini(apiKey: apiKey!);
  @override
  Widget build(BuildContext context) {
    log(post.toString());

    return BlocListener<CreatePostBloc, CreatePostState>(
      listener: (context, state) {
        if (state is CreatePostSuccess) {
          setState(() {
            loading = false;
          });
          context.read<GetPostBloc>().add(GetPosts());
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
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await gemmy
                    .generateFromTextAndImages(
                        image: imageFile!,
                        query:
                            "Compose an interesting poem from the image which has the name ${titleController.text}. Let the poem deliver heartfelt emotions")
                    .then((value) {
                  setState(() {
                    loading = true;
                  });
                  post.body = value.text;
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });

                  showBottomSheet(
                      context: context,
                      builder: (context) {
                        return Text(error.toString());
                      });
                });
                setState(() {
                  loading = true;
                  imageFile = File(imageString);

                  post.title = titleController.text;
                  post.genre = selectedItem;
                  // post.thumbnail = imageString;
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
            ? Center(child: Lottie.asset('assets/lotti/creating.json'))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14.0),
                  child: Column(
                    children: [
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
                              //            final ref = FirebaseStorage.instance.ref().child('thumbnail').child('${post.id}.jpg');
                              //  await ref.putFile(imageFile!);
                              //  imageUrl = await ref.getDownloadURL();

                              setState(() {
                                imageString = croppedFile.path;
                                imageFile = File(croppedFile.path);
                                // context.read<CreatePostBloc>().add(CreatePost(post, imageString));
                              });
                            }
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              // color: AppColors.greenWhite,
                              borderRadius: BorderRadius.circular(20)),
                          child: imageFile == null
                              ? const Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_rounded,
                                      size: 80,
                                    ),
                                    Text("Add article cover image"),
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
                      HtmlEditor(
                          htmlEditorOptions: HtmlEditorOptions(
                            hint: "Your text here...",
                            spellCheck: true,
                            autoAdjustHeight: true,
                            adjustHeightForKeyboard: true

                            //initalText: "text content initial, if any",
                          ),
                          htmlToolbarOptions: HtmlToolbarOptions(
                            toolbarPosition: ToolbarPosition.belowEditor
                          ),
                          otherOptions: OtherOptions(height: 200),
                          controller: controller),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(onPressed: ()
                      
                      async {

                        setState(() async {

                          text = await controller.getText();
                           


                        
                          

                        });
                        

                      print(await controller.getText());

                      }, child: Text("print text")),

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
                                    borderSide: BorderSide(
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
}

extension Pop on BuildContext {
  void pop() {
    Navigator.of(this).pop();
  }
}
