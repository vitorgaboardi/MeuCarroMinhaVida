import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'main.dart';
import 'camera.dart';
import 'profile.dart';

class Search extends StatefulWidget {
  const Search({
    Key? key,
    required this.dados
  }) : super(key: key);

  final dados;

  @override
  State<Search> createState() => _Search(dados:dados);
}

class _Search extends State<Search> {
  _Search({
    required this.dados
  }) : super();

  final dados;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  int _selectedIndex = 1;

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
            MaterialPageRoute(builder: (BuildContext context) => MainPage(dados:dados)));
      } else if (index == 1) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Search(dados:dados)));
      } else if (index == 2) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Camera(camera:camera, dados:dados)));
      } else if (index == 4) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Profile(dados:dados)));
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pesquisa',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Digite a placa do carro',
            ),
          ),
        ),
      ])),
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
