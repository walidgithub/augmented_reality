import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import 'camera_file.dart';
import 'loading_dialog.dart';

List<CameraDescription> allCameras = [];
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    allCameras = await availableCameras();
  } on CameraException catch (errorMessage) {
    print(errorMessage.description);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
          ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = ScreenshotController();
  bool isScreenShotRunning = false;


  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = 'screenshot_$time';
    final result = await ImageGallerySaver.saveImage(bytes, name: name);
    hideLoading();
    return result['filePath'];
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: Scaffold(
        body: Stack(
          children: [
            imageWidget(context, isScreenShotRunning),
            !isScreenShotRunning ? Positioned(
                bottom: 50,
                left: 10,
                right: 10,
                child: Bounceable(
                  onTap: () async {
                    showLoading();
                    setState(() {
                      isScreenShotRunning = true;
                    });
                    final image =
                        await controller.capture();
                    if (image == null) return;
                    await saveImage(image);
                  },
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 5),
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                )) : Container()
          ],
        ),
      ),
    );
  }
}


