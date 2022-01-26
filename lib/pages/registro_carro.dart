import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import 'main.dart';
import 'profile.dart';

class RegistroCarro extends StatefulWidget {
  const RegistroCarro({
    Key? key,
    required this.dados
  }) : super(key: key);

  final dados;

  @override
  State<StatefulWidget> createState() => RegistroCarroState(dados:dados);
}

class RegistroCarroState extends State<RegistroCarro> {
  RegistroCarroState({
    required this.dados
  }) : super();

  final dados;
  String erroDaApi = '';
  TextEditingController placaController = TextEditingController();
  TextEditingController modeloController = TextEditingController();
  TextEditingController corController = TextEditingController();
  TextEditingController anoController = TextEditingController();

  void resetarCampos() {
    placaController.clear();
    modeloController.clear();
    corController.clear();
    anoController.clear();
  }

  void cadastrar() async {
    setState(() {
      erroDaApi = '';
    });

    if (true /* formGlobalKey.currentState!.validate() */) {
      var placa = placaController.text;
      var modelo = modeloController.text;
      var cor = corController.text;
      var ano = anoController.text;

      try {
        var url = Uri.parse('http://wadsonpontes.com/cadastrocarro');
        var res = await http.post(url, body: {
          'email': dados['email'],
          'senha': dados['senha'],
          'placa': placa,
          'modelo': modelo,
          'cor': cor,
          'ano': ano
        });

        if (res.statusCode == 200) {
          var r = jsonDecode(res.body) as Map;

          if (r['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sucesso!')),
            );

            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => Profile(dados:dados)));
          }
          else {
            setState(() {
              erroDaApi = r['error'];
            });
          }
        }
        else {
          setState(() {
            erroDaApi = 'Erro de comunicação com o servidor';
          });
        }
      }
      catch (e) {
        setState(() {
          erroDaApi = 'Ocorreu um erro inesperado';
        });
      }
    }
  }

  void voltar() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Profile(dados:dados)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cadastrar Carro',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
          ),
          backgroundColor: Color.fromARGB(255, 162, 89, 255),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: TextField(
                controller: placaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Placa',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: modeloController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Modelo',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: corController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cor',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                controller: anoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ano',
                ),
              ),
            ),
            Row(children: [
              Expanded(
                  child: SizedBox(
                      height: 100,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 35, 10, 10),
                          child: ElevatedButton(
                              onPressed: voltar,
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
                              child: Text('VOLTAR',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 162, 89, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  )))))),
              Expanded(
                  child: SizedBox(
                      height: 100,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 35, 20, 10),
                          child: ElevatedButton(
                            onPressed: cadastrar,
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
                            child: Text('CADASTRAR',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 162, 89, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                )),
                          ))))
            ]),
            Text(erroDaApi,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        )));
  }
}
