import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:olly_chat/screens/home/components/image_container.dart';
import 'package:olly_chat/screens/poems/widgets/image_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScreenShotSnip extends StatefulWidget {

  final String image;
  final String articlesnip;


  const ScreenShotSnip({super.key, required this.image, required this.articlesnip});

  @override
  State<ScreenShotSnip> createState() => _ScreenShotSnipState();
}

class _ScreenShotSnipState extends State<ScreenShotSnip> {
  ScreenshotController screenshotController = ScreenshotController();

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');
    final name = 'screenshot_$time';

    final result = await ImageGallerySaver.saveImage(bytes, name: name);

    return result['filepath'];
  }

  Future<String> saveAndShare(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final image = await File('${dir.path}/flutter.png').create();
     image.writeAsBytesSync(bytes);

    // ignore: deprecated_member_use
    var retrr = await Share.shareFiles([image.path]);

    return retrr as String;
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Article Snippy"),
          actions: [
            IconButton(onPressed: () async{
              final imageTwo = await screenshotController.captureFromWidget(snap(widget: widget));

              saveAndShare(imageTwo);

              saveImage(imageTwo);

            


            }, icon:Icon(Icons.camera))
          ],
        ),
        body:   snap(widget: widget)
      ),
    );
  }
}

class snap extends StatelessWidget {
  const snap({
    super.key,
    required this.widget,
  });

  final ScreenShotSnip widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(widget.image, ), fit: BoxFit.cover)
        
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
               gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.topCenter,
              colors: [
                Colors.transparent,
                Colors.black,
              ],
            ),
            ),
            ),
            Positioned(
              top: 16,
              
              right: 5,
              child: Text(widget.articlesnip,
               style: GoogleFonts.caveat(
                color: Colors.white,
                fontSize: 20
               ))),
               Positioned(
               right: -40
               ,
                child: Image.asset('assets/images/nobg.png'))
        ],
      ),
    );
  }
}

class two extends StatelessWidget {
  const two({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ImageContainer(
        imageUrl:
            'https://images.unsplash.com/photo-1714423718253-b1bd2d95ddd9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
  }
}

 
class cool extends StatelessWidget {
  const cool({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: 100,
      width: 300,
      color: Colors.green.shade100,
      child: Center(child: const Text("Hi")),
    ));
  }
}
