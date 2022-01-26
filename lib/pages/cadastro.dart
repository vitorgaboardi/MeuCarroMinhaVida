import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cadastro2.dart';

class Cadastro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CadastroState();
}

class CadastroState extends State<Cadastro> {
  String erroDaApi = '';
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController senha2Controller = TextEditingController();

  void resetarCampos() {
    emailController.clear();
    senhaController.clear();
    senha2Controller.clear();
  }

  void cadastrar() async {
    setState(() {
      erroDaApi = '';
    });

    if (formGlobalKey.currentState!.validate()) {
      var email = emailController.text;
      var senha = senhaController.text;

      try {
        var url = Uri.parse('http://wadsonpontes.com/cadastro');
        var res = await http.post(url, body: {'email': email, 'senha': senha});

        if (res.statusCode == 200) {
          var r = jsonDecode(res.body) as Map;

          if (r['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sucesso!')),
            );

            Navigator.push(
                context, MaterialPageRoute(builder: (BuildContext context) =>
                Cadastro2(email: email, senha: senha)));
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
    Navigator.pop(context);
  }

  bool eEmailValido(email) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
  }

  bool eSenhaValida(senha) {
    final passwordRegExp = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegExp.hasMatch(senha);
  }

  bool eSenhasCorrespondem(senha) {
    if (senhaController.text != senha2Controller.text) {
      return false;
    }
    return true;
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
            child: Form(
                key: formGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 10),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 255,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                          counterText: '',
                        ),
                        validator: (email) {
                          if (eEmailValido(email))
                            return null;
                          else
                            return 'Digite um endereço de e-mail válido';
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: senhaController,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                        ),
                        validator: (email) {
                          if (eSenhaValida(email))
                            return null;
                          else
                            return 'Senha deve conter 8 dígitos (A-Z a-z 0-9 !#@*&)';
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: senha2Controller,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirmar Senha',
                        ),
                        validator: (email) {
                          if (eSenhasCorrespondem(email))
                            return null;
                          else
                            return 'As senhas não correspondem';
                        },
                      ),
                    ),
                    Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  height: 100,
                                  child: Container(
                                      padding: EdgeInsets.fromLTRB(20, 35, 20, 10),
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
                                        child: Text('PRÓXIMO',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 162, 89, 255),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            )),
                                      )
                                  )
                              )
                          ),
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
