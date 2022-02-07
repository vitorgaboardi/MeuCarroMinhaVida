import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csc_picker/csc_picker.dart';

import 'meus_carros.dart';

class RegistroRoubo extends StatefulWidget {
  const RegistroRoubo({Key? key, required this.dados}) : super(key: key);

  final dados;

  @override
  State<StatefulWidget> createState() => RegistroRouboState(dados: dados);
}

class RegistroRouboState extends State<RegistroRoubo> {
  RegistroRouboState({required this.dados}) : super();

  final dados;
  String erroDaApi = '';

  String? countryValue = 'Brazil';
  String? stateValue = '';
  String? cityValue = '';
  TextEditingController enderecoController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? horario;
  TextEditingController complementoController = TextEditingController();
  TextEditingController recompensaController = TextEditingController();

  void resetarCampos() {
    enderecoController.clear();
    bairroController.clear();
    complementoController.clear();
    recompensaController.clear();
  }

  /*
  void cadastrar() async {
    setState(() {
      erroDaApi = '';
    });

    if (true /* formGlobalKey.currentState!.validate() */) {
      var endereco = enderecoController.text;
      var bairro = bairroController.text;
      var cidade = cidadeController.text;
      var estado = estadoController.text;

      try {
        var url = Uri.parse('http://wadsonpontes.com/cadastroroubo');
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

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Profile(dados: dados)));
          } else {
            setState(() {
              erroDaApi = r['error'];
            });
          }
        } else {
          setState(() {
            erroDaApi = 'Erro de comunicação com o servidor';
          });
        }
      } catch (e) {
        setState(() {
          erroDaApi = 'Ocorreu um erro inesperado';
        });
      }
    }
  }
  */

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        horario = newTime;
      });
    }
  }

  void voltar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MeusCarros(dados: dados)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cadastrar Roubo',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30),
          ),
          backgroundColor: Color.fromARGB(255, 162, 89, 255),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    ///Adding CSC Picker Widget in app
                    CSCPicker(
                      defaultCountry: DefaultCountry.Brazil,
                      disableCountry: true,
                      showStates: true,
                      showCities: true,
                      flagState: CountryFlag.DISABLE,
                      layout: Layout.vertical,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade500, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.grey.shade500, width: 1)),

                      ///placeholders for dropdown search field
                      //countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "Estado",
                      citySearchPlaceholder: "Cidade",

                      ///labels for dropdown
                      //countryDropdownLabel: "*Country",
                      stateDropdownLabel: "Estado",
                      cityDropdownLabel: "Cidade",

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                          print(value);
                        });
                      },

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              height: 60,
              child: TextField(
                controller: enderecoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Endereco',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              height: 50,
              child: TextField(
                controller: bairroController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bairro',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              height: 50,
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021),
                              lastDate: DateTime(2024))
                          .then((date) => {
                                setState(() {
                                  selectedDate = date;
                                })
                              });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white), // background
                        foregroundColor: MaterialStateProperty.all(
                            Colors.white), // foreground
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.grey.shade500)))),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          selectedDate == null
                              ? 'Data'
                              : "${selectedDate!.day.toString().padLeft(2, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.year.toString()}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          )),
                    ),
                  )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              height: 50,
              child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectTime,
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white), // background
                        foregroundColor: MaterialStateProperty.all(
                            Colors.white), // foreground
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.grey.shade500)))),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          horario == null
                              ? 'Horario'
                              : "${horario!.hour.toString().padLeft(2, '0')}:${horario!.minute.toString().padLeft(2, '0')}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          )),
                    ),
                  )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              height: 50,
              child: TextField(
                controller: complementoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Complemento',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              height: 50,
              child: TextField(
                controller: recompensaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Recompensa',
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Row(children: [
              Expanded(
                  child: SizedBox(
                      height: 86,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
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
                          padding: EdgeInsets.fromLTRB(10, 20, 20, 10),
                          child: ElevatedButton(
                            onPressed: null,
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
            Text(
              erroDaApi,
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
