import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class Cadastro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CadastroState();
}

class CadastroState extends State<Cadastro> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController senha2Controller = TextEditingController();

  void resetarCampos() {
    emailController.clear();
    senhaController.clear();
    senha2Controller.clear();
  }

  void cadastrar() async {
    var url = Uri.parse('https://wadsonpontes.com/cadastro');
    var response = await http.post(url,
        body: {'email': emailController.text, 'senha': senhaController.text});

    print(response.body);

    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  void voltar() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Registrar',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
          ),
          backgroundColor: Color.fromARGB(255, 162, 89, 255),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            /*
                Container(
                    color: Color.fromARGB(255, 162, 89, 255),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
                    child: Text(
                      'Registrar',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 30),
                    )),
                    */
            Container(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                obscureText: true,
                controller: senhaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextField(
                obscureText: true,
                controller: senha2Controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmação de Senha',
                ),
              ),
            ),
            Row(children: [
              Expanded(
                  child: SizedBox(
                      height: 86,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 35, 10, 0),
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
                      height: 86,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(10, 35, 20, 0),
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
                            child: Text('REGISTRAR',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 162, 89, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                )),
                          ))))
            ])
          ],
        )));
  }
}
