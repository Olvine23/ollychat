import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:olly_chat/screens/home/components/image_container.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScreenShotSnip extends StatefulWidget {
  const ScreenShotSnip({super.key});

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
        appBar: AppBar(),
        body: Column(
          children: [
            const cool(),
            two(),
            ElevatedButton(
                onPressed: () async {
                  final image = await screenshotController.capture();

                  if (image == null) {
                    return;
                  }
                  await saveImage(image);
                  await saveAndShare(image);
                },
                child: const Text("Take screenshot")),
            ElevatedButton(
                onPressed: () async {
                  final image =
                      await screenshotController.captureFromWidget(const two());

                  saveAndShare(image);
                },
                child: const Text("Capture Widget")),
                 ElevatedButton(
                onPressed: () async {
                  final image =
                      await screenshotController.captureFromWidget(const cool());

                  saveAndShare(image);
                },
                child: const Text("Capture Widget One "))
          ],
        ),
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
