import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';
import 'main.dart';
import 'camera.dart';
import 'mensagem.dart';
import 'profile.dart';

class Search extends StatefulWidget {
  Search({Key? key, required this.dados}) : super(key: key);

  var dados;

  @override
  State<Search> createState() => _Search(dados: dados);
}

class _Search extends State<Search> {
  _Search({required this.dados}) : super();

  var dados;
  TextEditingController pesquisaController = TextEditingController();
  String mensagemResposta = '';
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

  void pesquisar() async {
    try {
      var url = Uri.parse('http://wadsonpontes.com/pesquisa');
      var res = await http.post(url, body: {'email': dados['email'], 'roubo': json.encode(dados['roubo']), 'pesquisa': pesquisaController.text});

      if (res.statusCode == 200) {
        var r = jsonDecode(res.body) as Map;

        if (r['status'] == 'success') {
          setState(() {
            dados = r;
          });

          if (dados['carro']['id_carro'] > 0) {
            if (dados['roubo']['id_roubo'] > 0) {
              setState(() {
                mensagemResposta = '';
              });

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SelectedCar(dados: dados)));
            }
            else {
              setState(() {
                mensagemResposta = 'Carro não se encontra roubado';
              });
            }
          }
          else {
            setState(() {
              mensagemResposta = 'Carro não encontrado em nosso banco de dados';
            });
          }
        } else {print('Erro nos dados enviados');}
      } else {print('Erro no servidor');}
    } catch (e) {print('Erro na requisicao');}
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
              padding: EdgeInsets.fromLTRB(20, 30, 5, 10),
              child: Row(
                children: [
                  Expanded(
                      child:TextField(
                        controller: pesquisaController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite a placa do carro',
                        ),
                      )
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 40,
                    //color: Theme.of(context).primaryColor,
                    onPressed: pesquisar,
                  ),
                ]
              )),
            Text(
              mensagemResposta,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            )
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

class SelectedCar extends StatefulWidget {
  SelectedCar({Key? key, required this.dados}) : super(key: key);

  var dados;

  @override
  State<SelectedCar> createState() => _SelectedCar(dados: dados);
}

class _SelectedCar extends State<SelectedCar> {
  _SelectedCar({required this.dados}) : super();

  var dados;
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      camera = cameras.first;
    });

    atualizarDados();
  }

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

  void atualizarDados() async {
    try {
      var url = Uri.parse('http://wadsonpontes.com/buscardados');
      var res = await http.post(url, body: {'email': dados['email'], 'roubo': json.encode(dados['roubo'])});

      if (res.statusCode == 200) {
        var r = jsonDecode(res.body) as Map;

        if (r['status'] == 'success') {
          setState(() {
            dados = r;
          });
        } else {print('Erro nos dados enviados');}
      } else {print('Erro no servidor');}
    } catch (e) {print('Erro na requisicao');}
  }

  Widget? selecionarImagemRoubo() {
    if (dados['roubo']['fotoperfil'] != null &&
        dados['roubo']['fotoperfil'].toUpperCase() != 'NULL') {
      return Image.network(
          'http://wadsonpontes.com/' + dados['roubo']['fotoperfil'],
          fit: BoxFit.cover);
    }
    return Image.asset('assets/images/emptyProfileFigure.png',
        fit: BoxFit.cover);
  }

  void entrarEmContato() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Mensagem(dados: dados)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Roubo',
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
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: selecionarImagemRoubo()),
                      title: Text('Placa: ' + dados['roubo']['placa']),
                      subtitle: Text(
                        dados['roubo']['modelo'] + ' - ' + dados['roubo']['ano'],
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Image.network(
                        'http://wadsonpontes.com/' + dados['roubo']['imagem']),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Text(
                          'Data: ' +
                              dados['roubo']['data'] +
                              ' ' +
                              dados['roubo']['hora'],
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          textAlign: TextAlign.left,
                        ),
                      )
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Text(
                        'Local: ' +
                            dados['roubo']['endereco'] +
                            '. ' +
                            dados['roubo']['bairro'] +
                            ', ' +
                            dados['roubo']['cidade'] +
                            ' - ' +
                            dados['roubo']['estado'] +
                            ', ' +
                            dados['roubo']['cep'] +
                            ' - ' +
                            dados['roubo']['complemento'] +
                            '.',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: 76,
                                child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                    child: ElevatedButton(
                                        onPressed: entrarEmContato,
                                        style: ButtonStyle(
                                            backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white), // background
                                            foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white), // foreground
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(5.0),
                                                    side: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 162, 89, 255))))),
                                        child: Text(
                                            'ENTRAR EM CONTATO COM PROPRIETÁRIO',
                                            style: TextStyle(
                                              color:
                                              Color.fromARGB(255, 162, 89, 255),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                            ))))))
                      ],
                    ),
                  ],
                )),
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