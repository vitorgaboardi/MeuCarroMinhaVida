import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login.dart';
import 'main.dart';
import 'pesquisa.dart';
import 'camera.dart';
import 'profile.dart';

class Mensagem extends StatefulWidget {
  Mensagem({Key? key, required this.dados}) : super(key: key);

  var dados;

  @override
  State<Mensagem> createState() => MensagemState(dados: dados);
}

class MensagemState extends State<Mensagem> {
  MensagemState({required this.dados}) : super();

  var dados;
  final ScrollController scrollController = ScrollController();
  TextEditingController mensagemController = TextEditingController();
  late List<CameraDescription> cameras;
  late CameraDescription camera;
  int _selectedIndex = 3;

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

  Widget selecionarImagemPerfilRoubo() {
    if (dados['roubo']['fotoperfil'] != null &&
        dados['roubo']['fotoperfil'].toUpperCase() != 'NULL') {
      return Image.network(
          'http://wadsonpontes.com/' + dados['roubo']['fotoperfil'],
          fit: BoxFit.cover,
          width: 50,
          height: 50);
    }
    return Image.asset('assets/images/emptyProfileFigure.png',
        fit: BoxFit.cover,
        width: 50,
        height: 50);
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

          scrollController.jumpTo(scrollController.position.maxScrollExtent);

          Timer(Duration(seconds: 5), atualizarDados);

        } else {print('Erro nos dados enviados');}
      } else {print('Erro no servidor');}
    } catch (e) {print('Erro na requisicao');}
  }

  void enviarMensagem() async {
    var mensagem = mensagemController.text;
    var id_usuario_recebeu = dados['roubo']['id_usuario'];
    var id_ok = false;

    if (id_usuario_recebeu == dados['id_usuario']) {
      if (dados['roubo']['qtd_mensagens'] > 0) {
        for (var i = 0; i < dados['roubo']['qtd_mensagens']; ++i) {
          if (dados['roubo']['mensagens'][i]['id_usuario_enviou'] != dados['id_usuario']) {
            id_usuario_recebeu = dados['roubo']['mensagens'][i]['id_usuario_enviou'];
            id_ok = true;
            break;
          }
          if (dados['roubo']['mensagens'][i]['id_usuario_recebeu'] != dados['id_usuario']) {
            id_usuario_recebeu = dados['roubo']['mensagens'][i]['id_usuario_recebeu'];
            id_ok = true;
            break;
          }
        }
      }
    }
    else {
      id_ok = true;
    }

    if (id_ok == false) {
      id_usuario_recebeu = 0;
    }

    try {
      var url = Uri.parse('http://wadsonpontes.com/mensagem');
      var res = await http.post(url, body: {
        'email': dados['email'],
        'roubo': json.encode(dados['roubo']),
        'mensagem': mensagem,
        'id_roubo': dados['roubo']['id_roubo'],
        'id_usuario_enviou': dados['id_usuario'],
        'id_usuario_recebeu': id_usuario_recebeu
      });

      if (res.statusCode == 200) {
        var r = jsonDecode(res.body) as Map;

        if (r['status'] == 'success') {
          mensagemController.text = '';

          atualizarDados();

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

    if (dados['roubo']['qtd_mensagens'] is String) {
      dados['roubo']['qtd_mensagens'] = int.parse(dados['roubo']['qtd_mensagens']);
    }

    atualizarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: selecionarImagemPerfilRoubo()),
              Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 5)),
              Text(
                dados['roubo']['nome_usuario'],
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20),
              )
            ]),
        backgroundColor: Color.fromARGB(255, 162, 89, 255),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          controller: scrollController,
          child: Column(children: [
                for (var i = 0; i < dados['roubo']['qtd_mensagens']; i++)
                  if (dados['roubo']['mensagens'][i]['id_usuario_enviou'] == dados['id_usuario'])
                    Container(
                      alignment: Alignment.centerRight,
                      child:Container(
                        margin: EdgeInsets.fromLTRB(80, 8, 10, 8),
                        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 162, 89, 255),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Text(
                            dados['roubo']['mensagens'][i]['mensagem'],
                            style: TextStyle(
                                color: Colors.white),
                        ),
                      )
                    )
                  else
                    Container(
                        alignment: Alignment.centerLeft,
                        child:Container(
                          margin: EdgeInsets.fromLTRB(10, 8, 80, 8),
                          padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 196, 159, 244),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Text(
                            dados['roubo']['mensagens'][i]['mensagem'],
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7)),
                          ),
                        )
                    ),
            Container(
              height: 80,
                padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
                child: Row(
                    children: [
                      Expanded(
                          child:TextField(
                            controller: mensagemController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Digite a placa do carro',
                            ),
                          )
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 40,
                        color: Color.fromARGB(255, 162, 89, 255),
                        onPressed: enviarMensagem,
                      ),
                    ]
                )),
                    ]),
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
    );
  }
}
