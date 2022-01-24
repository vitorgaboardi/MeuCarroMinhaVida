import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'main.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  void resetarCampos() {
    emailController.clear();
    senhaController.clear();
  }

  void cadastrar() async {
    //var url = Uri.parse('https://wadsonpontes.com/cadastro');
    //var response = await http.post(url,
    //  body: {'email': emailController.text, 'senha': senhaController.text});

    //print(response.body);

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainPage()));
  }

  void voltar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
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
                            child: Text('ENTRAR',
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
