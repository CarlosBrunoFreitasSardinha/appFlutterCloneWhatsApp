import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterappwhatsappcb/model/Conversa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappwhatsappcb/model/usuario.dart';
import 'package:flutterappwhatsappcb/model/usuarioFireBase.dart';

import '../RouteGenerator.dart';

class abaConversas extends StatefulWidget {
  @override
  _abaConversasState createState() => _abaConversasState();
}

class _abaConversasState extends State<abaConversas> {

  List<Conversa> _listaConversas = List();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore bd = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adicionarListenerConversas();

    Conversa conversa = Conversa();
    conversa.nome = "Ana Clara";
    conversa.mensagem = "Olá tudo bem?";
    conversa.caminhoFoto = "https://firebasestorage.googleapis.com/v0/b/whatsapp-36cd8.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=97a6dbed-2ede-4d14-909f-9fe95df60e30";

    _listaConversas.add(conversa);

  }

  Stream<QuerySnapshot> _adicionarListenerConversas(){

    final stream = bd.collection("conversas")
        .document( UserFirebase.fireLogged.uidUser )
        .collection("ultima_conversa")
        .snapshots();

    stream.listen((dados){
      _controller.add( dados );
    });

  }


  Future<Usuario> _recuperaDadosUid(String uid)  async{
    Firestore bd = Firestore.instance;
    Usuario destinatario = Usuario();
    DocumentSnapshot snapshot =
    await bd.collection("usuarios").document(uid).get();
    var dados = snapshot.data;
    destinatario.uidUser = dados["uidUser"];
    destinatario.nome = dados["nome"];
    destinatario.urlImagemPerfil =
    dados["urlImagemPerfil"] != null ? dados["urlImagemPerfil"] : "";
    return destinatario;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      // ignore: missing_return
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[CircularProgressIndicator()],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;

            if (snapshot.hasError) {
              return Text("Erro ao carregar os dados!");
            } else {

              QuerySnapshot querySnapshot = snapshot.data;

              if( querySnapshot.documents.length == 0 ){
                return Center(
                  child: Text(
                    "Você não tem nenhuma mensagem ainda :( ",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: _listaConversas.length,
                  itemBuilder: (context, indice)  {

                    List<DocumentSnapshot> conversas = querySnapshot.documents.toList();
                    DocumentSnapshot item = conversas[indice];

                    String urlImagem  = item["caminhoFoto"];
                    String tipo       = item["tipoMensagem"];
                    String mensagem   = item["mensagem"];
                    String nome       = item["nome"];

                    Usuario destinatario = Usuario();
                    destinatario.ofMap(item["idDestinatario"] );

                    return ListTile(
                      onTap: (){
                        Navigator.pushNamed(context,
                            RouteGenerator.ROTA_MSGS,
                            arguments: destinatario);
                      },
                      contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: urlImagem!=null
                            ? NetworkImage( urlImagem )
                            : null,
                      ),
                      title: Text(
                        nome,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),
                      ),
                      subtitle: Text(
                          tipo=="texto"
                              ? mensagem
                              : "Imagem...",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14
                          )
                      ),
                    );

                  }
              );

            }
            break;
        }
      },
    );
  }
}