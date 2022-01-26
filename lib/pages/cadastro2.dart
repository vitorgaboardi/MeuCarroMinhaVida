import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'home.dart';

class Cadastro2 extends StatefulWidget {
  const Cadastro2({
    Key? key,
    required this.email,
    required this.senha
  }) : super(key: key);

  final String email;
  final String senha;

  @override
  State<StatefulWidget> createState() => Cadastro2State(email:email, senha:senha);
}

class Cadastro2State extends State<Cadastro2> {
  Cadastro2State({
    required this.email,
    required this.senha
  }) : super();

  String erroDaApi = '';
  final formGlobalKey = GlobalKey<FormState>();
  final String email;
  final String senha;
  TextEditingController nome = TextEditingController();
  TextEditingController cpf = TextEditingController();
  TextEditingController cep = TextEditingController();
  TextEditingController cidade = TextEditingController();
  TextEditingController estado = TextEditingController();

  void cadastrar() async {
    setState(() {
      erroDaApi = '';
    });

    if (formGlobalKey.currentState!.validate()) {
      try {
        var url = Uri.parse('https://wadsonpontes.comss/cadastro2');
        var res = await http.post(url, body: {
          'email': email,
          'senha': senha,
          'nome': nome.text,
          'cpf': cpf.text,
          'cep': cep.text,
          'cidade': cidade.text,
          'estado': estado.text
        });

        if (res.statusCode == 200) {
          var r = jsonDecode(res.body) as Map;

          if (r['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cadastro realizado com sucesso!')),
            );

            Navigator.push(
                context, MaterialPageRoute(builder: (BuildContext context) => Home()));
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

  bool eNomeValido(_nome) {
    if (nome.text.trim().length > 2)
      return true;
    return false;
  }

  bool eCpfValido(_cpf) {
    if (cpf.text.trim().length == 11)
      return true;
    return false;
  }

  bool eCepValido(_cep) {
    if (cep.text.trim().length == 8)
      return true;
    return false;
  }

  bool eCidadeValida(_cidade) {
    if (cidade.text.trim().length > 1)
      return true;
    return false;
  }

  bool eEstadoValido(_estado) {
    if (estado.text.trim().length > 1)
      return true;
    return false;
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
                        controller: nome,
                        keyboardType: TextInputType.text,
                        maxLength: 255,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome',
                          counterText: '',
                        ),
                        validator: (_nome) {
                          if (eNomeValido(_nome))
                            return null;
                          else
                            return 'Nome deve ter no mínimo 3 caracteres';
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        controller: cpf,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CPF',
                          counterText: '',
                        ),
                        validator: (_cpf) {
                          if (eCpfValido(_cpf))
                            return null;
                          else
                            return 'Digite um CPF válido (apenas números)';
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        controller: cep,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CEP',
                          counterText: '',
                        ),
                        validator: (_cep) {
                          if (eCepValido(_cep))
                            return null;
                          else
                            return 'Digite um CEP válido (apenas números)';
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        controller: cidade,
                        keyboardType: TextInputType.text,
                        maxLength: 255,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cidade',
                          counterText: '',
                        ),
                        validator: (_cidade) {
                          if (eCidadeValida(_cidade))
                            return null;
                          else
                            return 'Digite uma cidade válida';
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TextFormField(
                        controller: estado,
                        keyboardType: TextInputType.text,
                        maxLength: 100,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Estado',
                          counterText: '',
                        ),
                        validator: (_estado) {
                          if (eEstadoValido(_estado))
                            return null;
                          else
                            return 'Digite um estado válido';
                        },
                      ),
                    ),
                    Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                                  height: 100,
                                  child: Container(
                                      padding: EdgeInsets.fromLTRB(20, 35, 20, 20),
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
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                )
            )
        )
    );
  }
}
