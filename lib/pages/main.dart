import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'pesquisa.dart';
import 'camera.dart';
import 'profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.dados}) : super(key: key);

  final dados;

  @override
  State<MainPage> createState() => _MainPage(dados: dados);
}

class _MainPage extends State<MainPage> {
  _MainPage({required this.dados}) : super();

  final dados;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  int _selectedIndex = 0;

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
                builder: (BuildContext context) =>
                    Camera(camera: camera, dados: dados)));
      } else if (index == 4) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Profile(dados: dados)));
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
          'Home',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        Card(
            clipBehavior: Clip.hardEdge,
            color: Colors.purple[50],
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: const Text('Placa: POX4G21'),
                  subtitle: Text(
                    'Gol Prata - 2020',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Image.asset('assets/images/car1.png'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    'Data do Furto: 30/11/2021 - 12:29',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Text(
                    'Local do Furto: Av. Ayrton Senna, 3022. Neopolis, Natal-RN, 59080-100 - Em frente a farmacia Pague Menos.',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            )),
        Card(
            clipBehavior: Clip.hardEdge,
            color: Colors.purple[50],
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: const Text('Placa: NNU0B98'),
                  subtitle: Text(
                    'Montana Prata - 2020',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Image.asset('assets/images/car2.png'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Text(
                    'Data do Furto: 29/11/2021 - 03:29',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Text(
                    'Local do Furto: Av. Xavier da Silveira, 55. Nova Descoberta, Natal-RN, 59015-430 - Em frente a Picanha Churrascaria.',
                    style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ))
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
