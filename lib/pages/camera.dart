import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'main.dart';
import 'pesquisa.dart';
import 'camera.dart';
import 'profile.dart';

class Camera extends StatefulWidget {
  const Camera({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  CameraState createState() => CameraState();
}

class CameraState extends State<Camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  int _selectedIndex = 2;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Search',
      style: optionStyle,
    ),
    Text(
      'Index 2: Camera',
      style: optionStyle,
    ),
    Text(
      'Index 3: Message',
      style: optionStyle,
    ),
    Text(
      'Index 4: Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainPage()));
      } else if (index == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Search()));
      } else if (index == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Camera(camera: camera)));
      } else if (index == 4) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Profile()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      camera = cameras.first;
    });

    _controller = CameraController(widget.camera, ResolutionPreset.high);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Take a car Photo',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        centerTitle: true,
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Trying to set camera at full screen:
            var camera = _controller.value;
            final size = MediaQuery.of(context).size;
            var scale = size.aspectRatio * camera.aspectRatio;

            // to prevent scaling down, invert the value
            //if (scale < 1) scale = 1 / scale;

            // If the Future is complete, display the preview.
            return Transform.scale(
                scale: scale * 1.05,
                child: Center(child: CameraPreview(_controller)));
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // This is all you need!
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
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
      appBar: AppBar(
        title: const Text(
          'Imagem',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        centerTitle: true,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
