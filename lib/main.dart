import 'package:flutter/material.dart';
import '/pages/home.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MaterialApp(title: "Meu Carro Minha Vida", home: Home()));
}
