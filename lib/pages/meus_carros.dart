import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import 'main.dart';
import 'profile.dart';
import 'registro_roubo.dart';

class MeusCarros extends StatefulWidget {
  const MeusCarros({Key? key, required this.dados}) : super(key: key);

  final dados;

  @override
  State<StatefulWidget> createState() => MeusCarrosState(dados: dados);
}

class MeusCarrosState extends State<MeusCarros> {
  MeusCarrosState({required this.dados}) : super();

  final dados;

  void voltar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Profile(dados: dados)));
  }

  void _cadastroRoubo() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RegistroRoubo(dados: dados)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Meus Carros',
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
                  Image.asset('assets/images/car3.png'),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Text(
                            'Placa: NNX-2934',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Text(
                            'Modelo: Celta',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Text(
                            'Ano: 2012',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Text(
                            'Cor: Preto',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: SizedBox(
                              height: 66,
                              child: Stack(
                                alignment: Alignment.center,
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 5, 20, 10),
                                      child: ElevatedButton(
                                          onPressed: _cadastroRoubo,
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              foregroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      side: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              162,
                                                              89,
                                                              255))))),
                                          child: Text('CADASTRAR ROUBO',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 162, 89, 255),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              )))),
                                ],
                              )))
                    ],
                  ),
                ],
              )),
        ])));
  }
}
