import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappwhatsappcb/model/usuario.dart';

class Usuario {
  String _uidUser;
  String _nome;
  String _email;
  String _senha;
  String _urlImagemPerfil;

  Usuario();


  String get urlImagemPerfil => _urlImagemPerfil;

  set urlImagemPerfil(String value) {
    _urlImagemPerfil = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get uidUser => _uidUser;

  set uidUser(String value) {
    _uidUser = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {

      "uidUser": this.uidUser,
      "nome": this.nome,
      "email": this.email,
      "urlImagemPerfil": this.urlImagemPerfil,
    };
    return map;
  }

  ofMap(Map<String, dynamic> theMap){
    this.uidUser = theMap["uidUser"];
    this.nome = theMap["nome"];
    this.urlImagemPerfil = theMap["urlImagemPerfil"];
  }

  @override
  String toString() {
    return 'Usuario{_nome: $_nome, _email: $_email, _senha: $_senha, _urlImagemPerfil: $_urlImagemPerfil, _uidUser: $_uidUser}';
  }
}
