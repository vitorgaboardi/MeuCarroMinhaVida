import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'main.dart';
import 'pesquisa.dart';
import 'camera.dart';
import 'registro_carro.dart';
import 'meus_carros.dart';

class Profile extends StatefulWidget {
  Profile({Key? key, required this.dados}) : super(key: key);
  var dados;

  @override
  State<Profile> createState() => _Profile(dados: dados);
}

class _Profile extends State<Profile> {
  _Profile({required this.dados}) : super();

  var dados;
  String nomeUsuario = '';
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  var imagePath;
  File image = new File('');
  int _selectedIndex = 4;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Inicio',
      style: optionStyle,
    ),
    Text(
      'Index 1: Pesquisar',
      style: optionStyle,
    ),
    Text(
      'Index 2: Camera',
      style: optionStyle,
    ),
    Text(
      'Index 3: Mensagem',
      style: optionStyle,
    ),
    Text(
      'Index 4: Perfil',
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
                builder: (BuildContext context) => Camera(dados: dados)));
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

  void enviarFoto() async {
    try {
      var url = Uri.parse('http://wadsonpontes.com/fotoperfil');

      var request = new http.MultipartRequest("POST", url);
      request.fields['email'] = dados['email'];
      request.fields['senha'] = dados['senha'];
      request.files.add(await http.MultipartFile.fromPath('imagem', imagePath));

      var res = await http.Response.fromStream(await request.send());

      if (res.statusCode == 200) {
        var r = jsonDecode(res.body) as Map;

        if (r['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sucesso!')),
          );

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Profile(dados: dados)));
        } else {
          print('Erro: não foi retornado status de sucesso');
        }
      } else {
        print('Erro: não foi retornado status 200 de sucesso');
      }
    } catch (e) {
      print('Erro: não foi possível enviar a requisição');
    }
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

      enviarFoto();
    } on PlatformException catch (e) {
      print('Falha ao escolher imagem: $e');
    }
  }

  void _imagePress(context) {
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
  }

  ImageProvider selectImage() {
    if (dados['imagem'] != null && dados['imagem'].toUpperCase() != 'NULL') {
      return NetworkImage('http://wadsonpontes.com/' + dados['imagem']);
    } else if (image.path == '') {
      return AssetImage('assets/images/emptyProfileFigure.png');
    }
    return FileImage(image);
  }

  void atualizarDados() async {
    try {
      var url = Uri.parse('http://wadsonpontes.com/meuscarros');
      var res = await http.post(url, body: {'email': dados['email']});

      if (res.statusCode == 200) {
        var r = jsonDecode(res.body) as Map;

        if (r['status'] == 'success') {
          setState(() {
            dados = r;
            nomeUsuario = dados['nome'];
          });
        } else {}
      } else {}
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      camera = cameras.first;
    });

    atualizarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perfil',
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
            InkWell(
                onTap: () {
                  _imagePress(context);
                },
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  Container(
                      width: 130.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill, image: selectImage()))),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Icon(Icons.camera_alt),
                  )
                ])),
            //SizedBox(height: 5),
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
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                    height: 76,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                            child: Text('CADASTRAR NOVO CARRO',
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
                    height: 76,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
