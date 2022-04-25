import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class capturePage extends StatefulWidget {
  capturePageState createState() => capturePageState();
}

// ignore: camel_case_types
class capturePageState extends State<capturePage> {
//run the app
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    runApp(
      MaterialApp(
        theme: ThemeData.dark(),
        home: TakePictureScreen(
          camera: firstCamera,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    main();
    return Scaffold();
  }
}

//call the camera Handler state
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

//handler for controlling the picture capture
class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // build the camera for the user to see
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take the Picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Picture being displayed')),
      // The image is stored as a file on the device. Using the `Image.network`
      // constructor with the given path to display the image.
      // (change this to image.file for phone connection rather than image.network for computer google chrome emulator testing)
      body: Image.network(imagePath),
    );
  }
}
