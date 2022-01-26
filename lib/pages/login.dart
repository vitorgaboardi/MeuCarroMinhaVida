import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';
import 'main.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  String erroDaApi = '';
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  void resetarCampos() {
    emailController.clear();
    senhaController.clear();
  }

  void entrar() async {
    setState(() {
      erroDaApi = '';
    });

    if (formGlobalKey.currentState!.validate()) {
      var email = emailController.text;
      var senha = senhaController.text;

      try {
        var url = Uri.parse('http://wadsonpontes.com/login');
        var res = await http.post(url, body: {'email': email, 'senha': senha});

        if (res.statusCode == 200) {
          var r = jsonDecode(res.body) as Map;

          if (r['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sucesso!')),
            );

            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => MainPage(dados:r)));
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
          child: Form(
            key: formGlobalKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 255,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                      counterText: '',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextField(
                    obscureText: true,
                    controller: senhaController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 100,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(20, 35, 10, 10),
                                child: ElevatedButton(
                                    onPressed: voltar,
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.white), // background
                                        foregroundColor: MaterialStateProperty.all(Colors.white), // foreground
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Color.fromARGB(255, 162, 89, 255)
                                                )
                                            )
                                        )
                                    ),
                                    child: Text('VOLTAR',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 162, 89, 255),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        )
                                    )
                                )
                            )
                        )
                    ),
                    Expanded(
                        child: SizedBox(
                            height: 100,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(10, 35, 20, 10),
                                child: ElevatedButton(
                                  onPressed: entrar,
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white), // background
                                      foregroundColor: MaterialStateProperty.all(Colors.white), // foreground
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              side: BorderSide(
                                                  color: Color.fromARGB(255, 162, 89, 255)
                                              )
                                          )
                                      )
                                  ),
                                  child: Text('ENTRAR',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 162, 89, 255),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      )
                                  ),
                                )
                            )
                        )
                    )
                  ]
                ),
                Text(erroDaApi,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            )
          )
        )
    );
  }
}
