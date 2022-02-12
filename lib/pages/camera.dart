import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'pesquisa.dart';
import 'profile.dart';

class Camera extends StatefulWidget {
  Camera({Key? key, required this.dados}) : super(key: key);
  var dados;

  @override
  State<Camera> createState() => _Camera(dados: dados);
}

class _Camera extends State<Camera> {
  _Camera({required this.dados}) : super();

  var dados;
  var imagePath;
  File image = new File('');
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(dados: dados)));
      } else if (index == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Search(dados: dados)));
      } else if (index == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Camera(dados: dados)));
      } else if (index == 4) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Profile(dados: dados)));
      }
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.imagePath = image.path;
        this.image = imageTemporary;
        Navigator.pop(context);
      });
    } on PlatformException catch (e) {
      print('Falha ao escolher imagem: $e');
    }
  }

  Widget _showButtonSubmit() {
    if (imagePath == '' || imagePath == null) {
      return Container();
    }
    return FloatingActionButton(
        onPressed: () {
          print(imagePath);
          getPlate();
        },
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        child: const Icon(Icons.check));
  }

  void getPlate() async {
    var url = Uri.parse("http://alpr.imd.ufrn.br/lpr/frame/");
    var request = new http.MultipartRequest('POST', url);

    request.headers.addAll(
        {"Authorization": 'Api-Key 3evA1njZ.72wf1El72h74k2vGi1g6u6JkdgqKgiWb'});
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200)
      print("Uploaded!");
    else
      print(response.statusCode);
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext bc) {
            return Container(
                child: Wrap(
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Câmera'),
                    onTap: () => pickImage(ImageSource.camera),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.collections),
                    title: Text('Galeria'),
                    onTap: () => pickImage(ImageSource.gallery),
                  ),
                ),
                Card(
                    child: ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Cancelar'),
                  onTap: () => Navigator.pop(context),
                )),
              ],
            ));
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Camera',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        centerTitle: true,
      ),
      body: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image:
                  DecorationImage(fit: BoxFit.fill, image: FileImage(image)))),
      floatingActionButton: _showButtonSubmit(),
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
    );
  }
}
