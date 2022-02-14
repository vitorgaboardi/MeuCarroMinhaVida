import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'profile.dart';
import 'registro_roubo.dart';

class Info extends StatefulWidget {
  Info({Key? key, required this.dados}) : super(key: key);

  var dados;

  @override
  State<StatefulWidget> createState() => InfoState(dados: dados);
}

class InfoState extends State<Info> {
  InfoState({required this.dados}) : super();

  var dados;

  void voltar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Profile(dados: dados)));
  }

  void atualizarDados() async {
    try {
      var url = Uri.parse('http://wadsonpontes.com/buscardados');
      var res = await http.post(url, body: {
        'email': dados['email'],
        'roubo': json.encode(dados['roubo'])
      });

      if (res.statusCode == 200) {
        var r = jsonDecode(res.body) as Map;

        if (r['status'] == 'success') {
          setState(() {
            dados = r;
          });
        } else {
          print('Erro nos dados enviados');
        }
      } else {
        print('Erro no servidor');
      }
    } catch (e) {
      print('Erro na requisicao');
    }
  }

  @override
  void initState() {
    super.initState();

    atualizarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Informações',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
          ),
          backgroundColor: Color.fromARGB(255, 162, 89, 255),
          centerTitle: true,
        ),
        body: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                leading: Text('e-mail'),
                title: Text(dados['email']),
              ),
              ListTile(
                leading: Text('nome'),
                title: Text(dados['nome']),
              ),
              ListTile(
                leading: Text('cidade'),
                title: Text(dados['cidade']),
              ),
              ListTile(
                leading: Text('estado'),
                title: Text(dados['estado']),
              ),
              ListTile(
                leading: Text('CEP'),
                title: Text(dados['cep']),
                onTap:
                    null, // pode-se fazer algo para modificar o cep conforme o usuário inserir informações novas.
              ),
            ],
          ).toList(),
        ));
  }
}
