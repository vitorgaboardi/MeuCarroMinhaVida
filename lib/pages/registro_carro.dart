import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import 'profile.dart';

class RegistroCarro extends StatefulWidget {
  const RegistroCarro({Key? key, required this.dados}) : super(key: key);

  final dados;

  @override
  State<StatefulWidget> createState() => RegistroCarroState(dados: dados);
}

class RegistroCarroState extends State<RegistroCarro> {
  RegistroCarroState({required this.dados}) : super();

  final dados;
  String erroDaApi = '';
  TextEditingController placaController = TextEditingController();
  TextEditingController modeloController = TextEditingController();
  TextEditingController corController = TextEditingController();
  TextEditingController anoController = TextEditingController();

  var imagePath;
  File image = new File('');

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

        var request = new http.MultipartRequest("POST", url);
        request.fields['email'] = dados['email'];
        request.fields['senha'] = dados['senha'];
        request.fields['placa'] = placa.toUpperCase();
        request.fields['modelo'] = modelo;
        request.fields['cor'] = cor;
        request.fields['ano'] = ano;
        request.files
            .add(await http.MultipartFile.fromPath('imagem', imagePath));

        var res = await http.Response.fromStream(await request.send());

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

  void voltar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Profile(dados: dados)));
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.imagePath = image.path;
        this.image = imageTemporary;
        Navigator.pop(context);
      });
    } on PlatformException catch (e) {
      print('Falha ao escolher imagem: $e');
    }
  }

  bool placaValida(placa) {
    final placaChar = RegExp(r'[!@#$%^&*(),.-?":{}|<>]');
    print(placa);
    return placaChar.hasMatch(placa);
  }

  Icon _selectIcon() {
    if (image.path == '') return Icon(Icons.camera_alt);
    return Icon(Icons.check_circle_sharp, color: Colors.green);
  }

  void _imagePress(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Wrap(
            children: [
              Card(
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Câmera'),
                  onTap: () => pickImage(ImageSource.camera),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.collections),
                  title: Text('Galeria'),
                  onTap: () => pickImage(ImageSource.gallery),
                ),
              ),
              Card(
                  child: ListTile(
                leading: Icon(Icons.close),
                title: Text('Cancelar'),
                onTap: () => Navigator.pop(context),
              )),
            ],
          ));
        });
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
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: SizedBox(
                        height: 86,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: ElevatedButton(
                                    onPressed: () => _imagePress(context),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        foregroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 162, 89, 255))))),
                                    child: Text('Imagem',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 162, 89, 255),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                        )))),
                            Positioned(
                                right: 25.0, bottom: 10.0, child: _selectIcon())
                          ],
                        )))
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                maxLength: 7,
                controller: placaController,
                decoration: InputDecoration(
                  counterText: '',
                  border: OutlineInputBorder(),
                  labelText: 'Placa',
                ),
                validator: (placa) {
                  if (placaValida(placa))
                    return null;
                  else
                    return 'Placa deve ter apenas letras e números';
                },
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
