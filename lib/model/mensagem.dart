import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterappwhatsappcb/model/usuarioFireBase.dart';
import 'package:image_picker/image_picker.dart';

class Mensagem{

  String _idUsuarioEmissor;
  String _idUsuarioReceptor;
  String _mensagem;
  String _urlImagem;
  String _tipo;
  DateTime envio = new DateTime.now();

  Mensagem();

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get idUsuarioReceptor => _idUsuarioReceptor;

  set idUsuarioReceptor(String value) {
    _idUsuarioReceptor = value;
  }

  String get urlImagem => _urlImagem;

  set urlImagem(String value) {
    _urlImagem = value;
  }

  String get mensagem => _mensagem;

  set mensagem(String value) {
    _mensagem = value;
  }

  String get idUsuarioEmissor => _idUsuarioEmissor;

  set idUsuarioEmissor(String value) {
    _idUsuarioEmissor = value;
  }


  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "idEmissor": this.idUsuarioEmissor,
      "idReceptor": this.idUsuarioReceptor,
      "mensagem": this.mensagem,
      "urlImagem": this.urlImagem,
      "tipo": this.tipo,
      "envio": this.envio,

    };
    return map;
  }

  @override
  String toString() {
    return 'Mensagem{_idUsuarioEmissor: $_idUsuarioEmissor, _idUsuarioReceptor: $_idUsuarioReceptor, _mensagem: $_mensagem, _urlImagem: $_urlImagem, _tipo: $_tipo}';
  }
  void salvarMensagem() async {
    Firestore bd = Firestore.instance;

    await bd
        .collection("mensagens")
        .document(this.idUsuarioEmissor)
        .collection(this.idUsuarioReceptor)
        .document(this.envio.toIso8601String()+this.idUsuarioEmissor)
        .setData(this.toMap());

    await bd
        .collection("mensagens")
        .document(this.idUsuarioReceptor)
        .collection(this.idUsuarioEmissor)
        .document(this.envio.toIso8601String()+this.idUsuarioReceptor)
        .setData(this.toMap());
  }

}