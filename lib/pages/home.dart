import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import 'cadastro.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  void irParaCadastro() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => Cadastro()));
  }

  void irParaEntrar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
              children: [
                Container(
                    color: Color.fromARGB(255, 162, 89, 255),
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(20, 100, 20, 80),
                    child: Text(
                      'Meu carro, minha vida',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 80),
                    )),
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                          height: 86,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 35, 10, 0),
                              child: ElevatedButton(
                                  onPressed: irParaEntrar,
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white), // background
                                      foregroundColor: MaterialStateProperty.all(Colors.white), // foreground
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              side: BorderSide(color: Color.fromARGB(255, 162, 89, 255))
                                          )
                                      )
                                  ),
                                  child: Text(
                                      'ENTRAR',
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
                          height: 86,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10, 35, 20, 0),
                              child: ElevatedButton(
                                  onPressed: irParaCadastro,
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.white), // background
                                      foregroundColor: MaterialStateProperty.all(Colors.white), // foreground
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5.0),
                                              side: BorderSide(color: Color.fromARGB(255, 162, 89, 255))
                                          )
                                      )
                                  ),
                                  child: Text('REGISTRAR',
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
                )
              ],
            )));
  }
}