import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
// import 'package:markdown_editable_textinput/markdown_text_input.dart';
import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:olly_chat/main.dart';
import 'package:olly_chat/services/gemini_service.dart';
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

  final GeminiService geminiService = GeminiService();
  File? imageFile;
  String? imageUrl;
  bool loading = false;
  bool isLoading = false;
  late Post post;
  late String imageString = '';
  String text = '';
  bool _isPublic = true;

  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }
  final moodController = TextEditingController();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  String description = 'Article goes here ';
  List<String> topics = [
    "Love",
    "Art",
    "Sadness",
    'Health',
    'Emotional',
    'Entertainment',
    'Sports',
    'Education',
    'Travel',
    'Food',
    'Lifestyle',
    'Other (Add new)'
  ];
  String selectedItem = "Love";
  void _showAddGenreDialog(BuildContext context) {
    String newGenre = '';
      
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 10,
        insetPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add a New Genre',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => newGenre = value,
                style: TextStyle(
                    color: Colors.black), // Set the input text color here
                decoration: InputDecoration(
                  hintText: 'Enter genre name',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold))),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (newGenre.trim().isNotEmpty) {
                        setState(() {
                          topics.insert(topics.length - 1, newGenre.trim());
                          
                          selectedItem = newGenre.trim();
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  final gemmy = GoogleGemini(apiKey: apiKey!);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              title: const Text(
            'Write Now',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
             actions: [
            // IconButton(onPressed: () {}, icon:  Icon(Icons.save,color: AppColors.secondaryColor,)),
            TextButton(
              onPressed: () async {
                setState(() {
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
                });
                context
                    .read<CreatePostBloc>()
                    .add(CreatePost(post, imageString));
              },
              child: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.white,
                        backgroundColor: AppColors.primaryColor,
                        side: BorderSide(
                          width: 1.0,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                          imageFile = File(imageString);
                          post.title = titleController.text;
                          post.genre = selectedItem;
                           post.body = text;
                         
                        });
                        context
                            .read<CreatePostBloc>()
                            .add(CreatePost(post, imageString));
                      },
                      icon: Icon(Icons.publish),
                      label: const Text(
                        "Publish",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
            ),
          ],
          
        ),        body: loading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Working on it . \n Will  be done in a bit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.secondaryColor),),
                  SizedBox(height: 10.h,),
                  SizedBox(
                    height: 2.h,
                  ),
                  Lottie.asset('assets/lotti/paint.json'),
                ],
              ))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.0.h,),
                        Text(
                          "Articles will be generated based on the inputs provided",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color: isDark ? Colors.white60 :    Colors.black54,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                       Text(
                          "Select a cover image for your piece",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                         const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery, imageQuality: 100);
                            if (image != null) {
                              CroppedFile? croppedFile = await ImageCropper()
                                  .cropImage(
                                      sourcePath: image.path,
                                  //     aspectRatioPresets: [
                                  //   CropAspectRatioPreset.square
                                  // ],
                                      uiSettings: [
                                    AndroidUiSettings(
                                        toolbarTitle: 'Cropper',
                                        toolbarColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 200,
                              color:  isDark ? Colors.grey.shade500 :    Colors.grey[200],
                              child: imageFile == null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image_rounded,
                                            size: 60,
                                            color: AppColors.primaryColor,
                                          ),
                                          SizedBox(height: 8),   
                                          Text(
                                            "Tap to add article image",
                                            style: TextStyle(
                                                color: isDark ? Colors.white60 :   Colors.black87,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Image.file(imageFile!, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                         Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Hey, what’s on your heart today?",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: moodController,
                          hintText: 'Write down what you feel ...',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "What do you want this piece to be called?",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          controller: titleController,
                          hintText: 'Title goes here ...',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                         Text(
                          "Which theme do you want it to fall under?",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                          const SizedBox(height: 8),
                           DropdownButtonFormField<String>(
                          value: selectedItem,
                          onChanged: (value) {
                            if (value != null) {
                              if (value == 'Other (Add new)') {
                                _showAddGenreDialog(context);
                              } else {
                                setState(() {
                                  selectedItem = value;
                                });
                              }
                              // setState(() {
                              //   selectedItem = value;
                              // });
                            }
                          },
                          items: topics.map((topic) {
                            return DropdownMenuItem(
                              value: topic,
                              child: Text(topic),
                            );
                          }).toList(),
                          // decoration: InputDecoration(
                          //   border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12)),
                          //   contentPadding: const EdgeInsets.symmetric(
                          //       vertical: 12, horizontal: 16),
                          // ),
                        ),
                              const SizedBox(
                          height: 20,
                        ),

                        loading
                            ? const Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    loading = true;
                                  });
                                  await geminiService.generatePromptFromText( titleController.text, moodController.text,selectedItem)   
                                      .then((value) {
                                    if (value.isEmpty) {
                                      setState(() {
                                        loading = false;
                                      });

                                      print(value);
                                      _showCustomDialog(context,
                                          "Whoopsie ...try another image");
                                    }
                                    setState(() {
                                      loading = false;
                                      text = value;
                                    });
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   const SnackBar(
                                    //     content: Text('Article generated successfully'),
                                    //   ),
                                    // );
                                    print(text);
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      loading = false;
                                    });
                                    print(error.toString());
                                    _showCustomDialog(
                                        context, error.toString());
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: AppColors.primaryColor,
                                    foregroundColor: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.auto_awesome),
                                    SizedBox(width: 8,),
                                    const Text(
                                      "Generate ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
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
                                     color: isDark ? Colors.white60 :    Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(text),
                        // MarkdownTextInput(
                        //   controller: bodyController,
                        //   (String value) => setState(() => text = value),
                        //   text,
                        // ),
                        SizedBox(
                          height: 4.h
                        ),
                        
                      Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      "Do you want this to be seen by everyone?",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_isPublic ? "Yes, make it public" : "No, keep it private",    style: TextStyle(
    color: _isPublic ? Colors.green : Colors.red,
    fontWeight: FontWeight.bold,
  ),),
        Switch(
          value: _isPublic,
          onChanged: (val) {
            setState(() {
              _isPublic = val;
            });
          },
        ),
      ],
    ),
  ],
),
                      
                      
                       
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       minimumSize: const Size.fromHeight(50),
                        //       backgroundColor: AppColors.primaryColor,
                        //       side: BorderSide(
                        //         width: 1.0,
                        //         color: AppColors.primaryColor,
                        //       )),
                        //   onPressed: () async {
                        //     setState(() {
                        //       loading = true;
                        //       imageFile = File(imageString);
                        //       post.body = text;
                        //       post.title = titleController.text;
                        //       post.genre = selectedItem;
                        //     });
                        //     context
                        //         .read<CreatePostBloc>()
                        //         .add(CreatePost(post, imageString));
                        //   },
                        //   child: loading
                        //       ? const Center(child: CircularProgressIndicator())
                        //       : const Text(
                        //           "Publish",
                        //           style: TextStyle(color: Colors.white),
                        //         ),
                        // ),
                      ],
                    ),
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
