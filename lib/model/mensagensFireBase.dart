import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterappwhatsappcb/model/mensagem.dart';
import 'package:flutterappwhatsappcb/model/usuarioFireBase.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MensagensFirebase{
  static Mensagem mensagem = Mensagem();

  static recuperaDadosMensagem() async{
    return MensagensFirebase.mensagem;
  }

   void salvarMensagem(Mensagem msg) async {
     Firestore bd = Firestore.instance;

    await bd
        .collection("mensagens")
        .document(msg.idUsuarioEmissor)
        .collection(msg.idUsuarioReceptor)
        .document(msg.envio.toIso8601String()+msg.idUsuarioEmissor)
        .setData(msg.toMap());

    await bd
        .collection("mensagens")
        .document(msg.idUsuarioReceptor)
        .collection(msg.idUsuarioEmissor)
        .document(msg.envio.toIso8601String()+msg.idUsuarioReceptor)
        .setData(msg.toMap());
  }


  Future<String> getImage(bool i) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage
      (source: i
        ? ImageSource.camera
        : ImageSource.gallery);
    File _image = File(pickedFile.path);
    if(_image != null) {
      String img = await _uploadImagem(_image);
      print("Img recebida? "+img);
      return img;
    }
  }


  Future<String> _uploadImagem(File _image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference pastaRaiz = storage.ref();
    StorageReference arquivo = pastaRaiz
        .child("mensagens")
        .child(UserFirebase.fireLogged.uidUser)
        .child(DateTime.now().millisecondsSinceEpoch.toString()+".jpg");
    String url = "";
    arquivo.putFile(_image);

    StorageUploadTask task = arquivo.putFile(_image);

    task.events.listen((event) {
      if (task.isInProgress){
      }
      else if (task.isSuccessful){
      }
    });
    task.onComplete.then(
            (StorageTaskSnapshot snapshot) async{
      url = await _recuperarUrlImagem(snapshot) as String;
    });
    print("Ola url do lado de fora = "+url);
    return url;
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async{
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

}