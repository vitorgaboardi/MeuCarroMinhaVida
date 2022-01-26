import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import 'main.dart';
import 'profile.dart';

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
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Text(
                            'Ano: 2012',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Text(
                            'Cor: Preto',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ]),
                ],
              )),
        ])));
  }
}
