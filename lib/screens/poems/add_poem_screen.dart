import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:google_gemini/google_gemini.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:olly_chat/main.dart';
import 'package:olly_chat/screens/poems/snippies/screenshotsnip.dart';
import 'package:olly_chat/screens/poems/snippies/snippy.dart';
import 'package:olly_chat/screens/poems/widgets/unsplash_widget.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:path_provider/path_provider.dart';
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
  bool _isPrivate = false;

  late Post post;
  late String imageString = '';

  String text = '';
  final QuillController _controller = QuillController.basic();

  @override
  void initState() {
    post = Post.empty;
    post.myUser = widget.myUser;
    super.initState();
  }


  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 100,
                );
                if (image != null) {
                  CroppedFile? croppedFile = await ImageCropper().cropImage(
                    sourcePath: image.path,
                    uiSettings: [
                      AndroidUiSettings(
                        toolbarTitle: 'Cropper',
                        toolbarColor: Theme.of(context).colorScheme.primary,
                        toolbarWidgetColor: Colors.white,
                        initAspectRatio: CropAspectRatioPreset.original,
                        lockAspectRatio: false,
                      ),
                     IOSUiSettings(title: 'Cropper'),
                    ],
                  );
                  if (croppedFile != null) {
                    setState(() {
                      imageFile = File(croppedFile.path);
                      imageString = croppedFile.path;
                    });
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text("Search from Unsplash"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnsplashImagePicker(
                        onImageSelected: (url) async {
                          final file = await _downloadImage(url);
                          setState(() {
                            imageFile = file;
                            imageString = file.path;
                          });
                          Navigator.pop(context);
                        },
                      ),
                  ),
                );
                
                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   builder: (_) {
                //     return SizedBox(
                //       height: MediaQuery.of(context).size.height * 0.85,
                //       child: UnsplashImagePicker(
                //         onImageSelected: (url) async {
                //           final file = await _downloadImage(url);
                //           setState(() {
                //             imageFile = file;
                //             imageString = file.path;
                //           });
                //           Navigator.pop(context);
                //         },
                //       ),
                //     );
                //   },
                // );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<File> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    return await file.writeAsBytes(bytes);
  }
  final titleController = TextEditingController();

  final bodyController = TextEditingController();
  String description = 'Article goes here ';
  List<String> topics = [
   "Healing",
  "Heartbreak",
  "Hope",
  "Growth",
  "Letting Go",
  "Gratitude",
  "Grief",
  "Self-Discovery",
  "Forgiveness",
  "Joy",
  "Loneliness",
  "Fear",
  'Other (Add new)'
  ];

  String selectedGenre = "Joy";

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
                          selectedGenre = newGenre.trim();
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

  String selectedItem = "Joy";
  final gemmy = GoogleGemini(apiKey: apiKey!);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print(bodyController.text);

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
          actions: [
            // IconButton(onPressed: () {}, icon:  Icon(Icons.save,color: AppColors.secondaryColor,)),
            TextButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                  imageFile = File(imageString);
                  post.title = titleController.text;
                  post.genre = selectedItem;
                  post.body =
                      jsonEncode(_controller.document.toDelta().toJson());
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
                          post.isPrivate = _isPrivate;
                          post.body = jsonEncode(
                              _controller.document.toDelta().toJson());
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
          title: const Text(
            'Write Now',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: loading
            ? Center(child: Lottie.asset('assets/lotti/creating.json'))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 8),
                        GestureDetector(
                           onTap: () => _showImagePickerOptions(context),
                          // onTap: () async {
                          //   final ImagePicker picker = ImagePicker();
                          //   final XFile? image = await picker.pickImage(
                          //       source: ImageSource.gallery, imageQuality: 100);

                          //   if (image != null) {
                          //     CroppedFile? croppedFile =
                          //         await ImageCropper().cropImage(
                          //             sourcePath: image.path,
                          //             //     aspectRatioPresets: [
                          //             //   CropAspectRatioPreset.square
                          //             // ],
                          //             uiSettings: [
                          //           AndroidUiSettings(
                          //               toolbarTitle: 'Cropper',
                          //               toolbarColor: Theme.of(context)
                          //                   .colorScheme
                          //                   .primary,
                          //               toolbarWidgetColor: Colors.white,
                          //               initAspectRatio:
                          //                   CropAspectRatioPreset.original,
                          //               lockAspectRatio: false),
                          //           IOSUiSettings(
                          //             title: 'Cropper',
                          //           ),
                          //         ]);

                          //     if (croppedFile != null) {
                          //       print(imageString);
                          //       //            final ref = FirebaseStorage.instance.ref().child('thumbnail').child('${post.id}.jpg');
                          //       //  await ref.putFile(imageFile!);
                          //       //  imageUrl = await ref.getDownloadURL();

                          //       setState(() {
                          //         imageString = croppedFile.path;
                          //         imageFile = File(croppedFile.path);
                          //         // context.read<CreatePostBloc>().add(CreatePost(post, imageString));
                          //       });
                          //     }
                          //   }
                          // },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 200,
                              color: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey[200],
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
                                                color: isDark
                                                    ? Colors.white60
                                                    : Colors.black87,
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

                        /// GENRE DROPDOWN
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

                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Tell your story ...",
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
                        QuillToolbar.simple(
                          configurations: QuillSimpleToolbarConfigurations(
                            controller: _controller,
                            // toolbarIconSize: 24,
                            multiRowsDisplay: false,
                            showFontFamily: false,
                            showFontSize: false,
                            showBoldButton: true,
                            showItalicButton: true,
                            showUnderLineButton: false,
                            showStrikeThrough: false,
                            showAlignmentButtons: true,
                            showListNumbers: false,
                            showListBullets: false,
                            showListCheck: false,
                            showCodeBlock: false,
                            showQuote: false,
                            showIndent: false,
                            showLink: false,
                            showUndo: false,
                            showRedo: false,
                            showDirection: false,
                            showClearFormat: false,
                            showColorButton: false,
                            showBackgroundColorButton: false,
                            showHeaderStyle: false,
                            showJustifyAlignment: false,
                            showLeftAlignment: true,
                            showCenterAlignment: true,
                            showRightAlignment: true,
                            sharedConfigurations:
                                const QuillSharedConfigurations(
                              locale: Locale('en'),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.grey.shade500
                                : Colors.grey.shade100,
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 400, // adjust as needed
                          child: QuillEditor.basic(
                            configurations: QuillEditorConfigurations(
                              placeholder: 'Write your article here...',

                              controller: _controller,

                              // readOnly: false,
                              sharedConfigurations:
                                  const QuillSharedConfigurations(
                                locale: Locale('en'),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 4.h,
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
        Text(_isPrivate ? "Yes, make it public" : "No, keep it private",    style: TextStyle(
    color: _isPrivate ? Colors.green : Colors.red,
    fontWeight: FontWeight.bold,
  ),),
        Switch(
          value: _isPrivate,
          onChanged: (val) {
            setState(() {
              _isPrivate= val;
            });
          },
        ),
      ],
    ),
  ],
),

                      ],
                    ),
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
