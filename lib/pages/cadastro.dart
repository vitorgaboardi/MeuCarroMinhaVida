import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home.dart';

class Cadastro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CadastroState();
}

class CadastroState extends State<Cadastro> {
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
    if (emailController.text.length > 2) {

    }

    var url = Uri.parse('https://wadsonpontes.com/cadastro');
    var response = await http.post(url,
        body: {'email': emailController.text, 'senha': senhaController.text});

    print(response.body);

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (BuildContext context) => Cadastro2(email:email, senha:senha)));
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                        validator: (email) {
                          if (eEmailValido(email)) return null;
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                        ),
                        validator: (email) {
                          if (eSenhaValida(email)) return null;
                          else
                            return 'Digite uma senha válida';
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        obscureText: true,
                        controller: senha2Controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirmar Senha',
                        ),
                        validator: (email) {
                          if (eSenhasCorrespondem(email)) return null;
                          else
                            return 'As senhas não correspondem';
                        },
                      ),
                    ),
                    Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  height: 86,
                                  child: Container(
                                      padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (formGlobalKey.currentState!.validate()) {
                                            // use the email provided here
                                          }
                                        },
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
                          )
                        ]
                    )
                  ],
                )
            )
        )
    );
  }
}
