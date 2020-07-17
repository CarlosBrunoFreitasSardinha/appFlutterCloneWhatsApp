import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappwhatsappcb/model/usuario.dart';
class Conversa {

  String _idRemetente;
  Usuario _idDestinatario;
  String _nome;
  String _mensagem;
  String _caminhoFoto;
  String _tipoMensagem;//texto ou imagem


  Conversa();

  salvar() async {
    Firestore db = Firestore.instance;
    await db.collection("conversas")
        .document( this.idRemetente )
        .collection( "ultima_conversa" )
        .document( this.idDestinatario.uidUser)
        .setData( this.toMap() );

  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idRemetente"     : this.idRemetente,
      "idDestinatario"  : this.idDestinatario.toMap(),
      "nome"            : this.nome,
      "mensagem"        : this.mensagem,
      "caminhoFoto"     : this.caminhoFoto,
      "tipoMensagem"    : this.tipoMensagem,
    };

    return map;

  }


  String get idRemetente => _idRemetente;

  set idRemetente(String value) {
    _idRemetente = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get mensagem => _mensagem;

  String get caminhoFoto => _caminhoFoto;

  set caminhoFoto(String value) {
    _caminhoFoto = value;
  }

  set mensagem(String value) {
    _mensagem = value;
  }

  Usuario get idDestinatario => _idDestinatario;

  set idDestinatario(Usuario value) {
    _idDestinatario = value;
  }

  String get tipoMensagem => _tipoMensagem;

  set tipoMensagem(String value) {
    _tipoMensagem = value;
  }


}