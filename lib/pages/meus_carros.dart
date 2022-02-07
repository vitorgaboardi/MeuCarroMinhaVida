import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import 'main.dart';
import 'profile.dart';
import 'registro_roubo.dart';

class MeusCarros extends StatefulWidget {
  MeusCarros({Key? key, required this.dados}) : super(key: key);

  var dados;

  @override
  State<StatefulWidget> createState() => MeusCarrosState(dados: dados);
}

class MeusCarrosState extends State<MeusCarros> {
  MeusCarrosState({required this.dados}) : super();

  var dados;

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

  void atualizarDadosMeusCarros() async {
    try {
      var url = Uri.parse('http://wadsonpontes.com/meuscarros');
      var res = await http.post(url, body: {'email': dados['email']});

      if (res.statusCode == 200) {
        var r = jsonDecode(res.body) as Map;

        if (r['status'] == 'success') {
          setState(() {
            dados = r;
          });
        } else {}
      } else {}
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    atualizarDadosMeusCarros();
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
          for (var i = 0; i < int.parse(dados['qtd_carros']); i++)
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
                              'Placa: ' + dados['carros'][i]['placa'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                            child: Text(
                              'Modelo: ' + dados['carros'][i]['modelo'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
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
                              'Ano: ' + dados['carros'][i]['ano'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                            child: Text(
                              'Cor: ' + dados['carros'][i]['cor'],
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
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
                                                                255, 162, 89, 255))))),
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
