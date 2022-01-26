import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'main.dart';
import 'pesquisa.dart';
import 'camera.dart';
import 'registro_carro.dart';
import 'meus_carros.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.dados}) : super(key: key);

  final dados;

  @override
  State<Profile> createState() => _Profile(dados: dados);
}

class _Profile extends State<Profile> {
  _Profile({required this.dados}) : super();

  final dados;
  String nomeUsuario = '';
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  int _selectedIndex = 4;

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

  void _meusCarros() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MeusCarros(dados: dados)));
  }

  void _cadastrarCarro() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RegistroCarro(dados: dados)));
  }

  void _home() {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      camera = cameras.first;
    });

    setState(() {
      nomeUsuario = dados['nome'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
        ),
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(height: 10),
        Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 130.0,
                height: 130.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://yt3.ggpht.com/ytc/AKedOLTgBzfv-ZnI70opiHwDPwuIue70fFRe3QZDGZ42hg=s900-c-k-c0x00ffffff-no-rj")))),
            SizedBox(height: 10),
            Text(nomeUsuario.toUpperCase(),
                style: TextStyle(
                  color: Color.fromARGB(255, 162, 89, 255),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ))
          ],
        )),
        Row(
          children: [
            Expanded(
                child: SizedBox(
                    height: 86,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
                        child: ElevatedButton(
                            onPressed: _meusCarros,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // background
                                foregroundColor: MaterialStateProperty.all(
                                    Colors.white), // foreground
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 162, 89, 255))))),
                            child: Text('MEUS CARROS',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 162, 89, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ))))))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: SizedBox(
                    height: 86,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
                        child: ElevatedButton(
                            onPressed: _cadastrarCarro,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // background
                                foregroundColor: MaterialStateProperty.all(
                                    Colors.white), // foreground
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 162, 89, 255))))),
                            child: Text('REGISTRAR NOVO CARRO',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 162, 89, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ))))))
          ],
        ),
        Row(
          children: [
            Expanded(
                child: SizedBox(
                    height: 86,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
                        child: ElevatedButton(
                            onPressed: _home,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.white), // background
                                foregroundColor: MaterialStateProperty.all(
                                    Colors.white), // foreground
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 162, 89, 255))))),
                            child: Text('LOGOUT',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 162, 89, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ))))))
          ],
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
