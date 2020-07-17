import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterappwhatsappcb/model/usuario.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserFirebase{
  static Usuario fireLogged = Usuario();

  static recuperaDadosUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    UserFirebase.fireLogged.uidUser = usuarioLogado.uid;

    Firestore bd = Firestore.instance;
    DocumentSnapshot snapshot = await bd.collection("usuarios")
        .document(UserFirebase.fireLogged.uidUser).get();

    Map<String, dynamic> dados = snapshot.data;
    UserFirebase.fireLogged.nome = dados["nome"];
    UserFirebase.fireLogged.email = dados["email"];
    UserFirebase.fireLogged.urlImagemPerfil = dados["urlImagemPerfil"] != null
        ? dados["urlImagemPerfil"]
        : null;
    return fireLogged;
  }
  static deslogar() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  Future getImage(bool i) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: i ? ImageSource.camera: ImageSource.gallery);
    File _image = File(pickedFile.path);
    if(_image != null) _uploadImagem(_image);
  }

  Future _uploadImagem(File _image){
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("perfil")
        .child(UserFirebase.fireLogged.uidUser+"pp.jpg");
    arquivo.putFile(_image);
    StorageUploadTask task = arquivo.putFile(_image);
    task.events.listen((event) {
      if (task.isInProgress){
        print("progresso");
      }
      else if (task.isSuccessful){
        print("Sucesso");
      }
    });
    task.onComplete.then((StorageTaskSnapshot snapshot) async{
      UserFirebase.fireLogged.urlImagemPerfil = await snapshot.ref.getDownloadURL();
      _AtualizarUsuarioFirebase();
    });
  }

  Future _AtualizarUsuarioFirebase() {
    Firestore bd = Firestore.instance;
    bd.collection("usuarios")
        .document(UserFirebase.fireLogged.uidUser)
        .updateData(UserFirebase.fireLogged.toMap());
  }

}