import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SnippyScreen extends StatefulWidget {
  const SnippyScreen({super.key});

  @override
  State<SnippyScreen> createState() => _SnippyScreenState();
}

class _SnippyScreenState extends State<SnippyScreen> {
  final GlobalKey globalKey = GlobalKey();
  File? qrFilePath;

  Future<ui.Image> captureImage() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.0);

    return image;
  }

  Future<void> saveImageAsJPEG() async {
    final permissionStatus = await Permission.storage.status;

    if (permissionStatus.isGranted) {
      final appDocDirectory = Platform.isAndroid
          ? await getTemporaryDirectory()
          : await getApplicationSupportDirectory();

      qrFilePath = File('${appDocDirectory.path}/qr_olly.png');

      if (mounted) {
        ui.Image image = await captureImage();
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
            print(byteData);
        if (byteData != null) {
          final buffer = byteData.buffer.asUint8List();
          await qrFilePath?.writeAsBytes(buffer);
        } else {
          print('Image bytes is Null or Empty');
        }
      }
    } else {
      /// Permission not present
      /// request permission
      if (permissionStatus.isDenied) {
        await Permission.storage.request();
      } else if (permissionStatus.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: (){
              saveImageAsJPEG();
            },
            child: Text("Tap me")),
        ));
  }
}
