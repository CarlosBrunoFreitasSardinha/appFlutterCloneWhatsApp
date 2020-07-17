import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  TextEditingController _controllerNome = TextEditingController();
  String _idUsuarioLogado, _urlImagemRecuperada;
  String imagem = "https://firebasestorage.googleapis.com/v0/b/cbfswhatsclone.appspot.com/o/perfil%2Fperfil1.jpg?alt=media&token=d93e748d-3895-4511-a832-e45c81a92cb8";
  bool _upload = false;
  File _image;
  final picker = ImagePicker();

  Future getImage(bool i) async {
    PickedFile _imageFile;
    final pickedFile = await picker.getImage(source: i ? ImageSource.camera: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      _upload = true;
      if(_image != null) _uploadImagem();
    });
  }

  Future _uploadImagem(){
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("perfil")
        .child(_idUsuarioLogado+"pp.jpg");
    arquivo.putFile(_image);
    StorageUploadTask task = arquivo.putFile(_image);
    task.events.listen((event) {
      if (task.isInProgress){
        print("progresso");
        setState(() {
          _upload = true;
        });
      }
      else if (task.isSuccessful){
        print("Sucesso");
        setState(() {
          _upload = false;
        });
      }
    });
    task.onComplete.then((StorageTaskSnapshot snapshot) async{
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();
    setState(() {
      _urlImagemRecuperada = url;
    });
    _atualizarUrlImagemFirestore(url);
  }

  Future _atualizarUrlImagemFirestore(String url){
    Map<String, dynamic> dadosAtualizar ={
      "urlImagemPerfil": url
    };

    Firestore bd = Firestore.instance;
    bd.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);
  }

  Future _atualizarNomeFirestore(){
    Map<String, dynamic> dadosAtualizar ={
      "nome": _controllerNome.text
    };

    Firestore bd = Firestore.instance;
    bd.collection("usuarios")
        .document(_idUsuarioLogado)
        .updateData(dadosAtualizar);
  }

  Future _recuperarImagem(String urlImg) async {
    switch(urlImg){
      case "camera":
        getImage(true);
        break;
      case "galeria":
        getImage(false);
        break;
    }
  }

  _recuperaDadosUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUsuarioLogado = usuarioLogado.uid;

    Firestore bd = Firestore.instance;
    DocumentSnapshot snapshot = await bd.collection("usuarios")
        .document(_idUsuarioLogado).get();

    Map<String, dynamic> dados = snapshot.data;
    setState(() {
      _controllerNome.text = dados["nome"];
      _urlImagemRecuperada = dados["urlImagemPerfil"] != null ? dados["urlImagemPerfil"] : null;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperaDadosUsuario();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações"),),
      
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _upload
                    ? CircularProgressIndicator()
                    : CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey,
                        backgroundImage: _urlImagemRecuperada != null
                            ? NetworkImage(_urlImagemRecuperada)
                            : null,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(onPressed: (){
                      _recuperarImagem("camera");
                      },
                        child: Text("Câmera")),
                    FlatButton(onPressed: (){
                      _recuperarImagem("galeria");
                      },
                        child: Text("Galeria")),
                  ],
                ),

                //nome
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.green,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _atualizarNomeFirestore();
                      }),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
