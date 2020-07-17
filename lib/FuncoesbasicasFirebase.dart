import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComandosBasicosFirebase extends StatefulWidget {
  @override
  _ComandosBasicosFirebaseState createState() =>
      _ComandosBasicosFirebaseState();
}

class _ComandosBasicosFirebaseState extends State<ComandosBasicosFirebase> {
//  WidgetsFlutterBinding.ensureInitialized();
  Firestore bd = Firestore.instance;

  _salvarComChaveManual() {
    bd
        .collection("usuarios")
        .document("003")
        .setData({"nome": "Android"});
  }

  Future<String> _salvarComChaveAutoGerada() async {
    DocumentReference ref = await bd
        .collection("usuario")
        .add({"login": "Carlos", "senha": "castiel"}) as DocumentReference;
    return ("item salvo: " + ref.documentID);
  }

//ATUALIZAR
  _atualuizarCampo(String identificadorItem) {
    if (identificadorItem == "") identificadorItem = "ZIwHv3MW7dhryz3iOg5u";

    bd.collection("Noticias").document(identificadorItem).setData({
      "titulo": "Coxinha e Doquinha alterado",
      "descricao": "texto de exemplo..."
    });
  }

//Remover
  _remover(String identificadorItem) {
    if (identificadorItem == "") identificadorItem = "ZIwHv3MW7dhryz3iOg5u";

    bd.collection("usuario").document(identificadorItem).delete();
  }

//RECUPERAR DE UNICO ITEM
  _selectFromWhereId(String identificadorItem) async {
    if (identificadorItem == "") identificadorItem = "ZIwHv3MW7dhryz3iOg5u";
    DocumentSnapshot snapshot =
        await bd.collection("usuario").document(identificadorItem).get();
    var dados = snapshot.data;
    print("Dados\n nome: " + dados["login"] + "\n senha: " + dados["senha"]);
  }

//RECUPERAR VARIOS ITENS
  _selectFromTb() async {
    QuerySnapshot querySnapshot = await bd
        .collection("usuario")
//    .where("login", isEqualTo: "doquinha")
        .where("login", isGreaterThanOrEqualTo: "co")
    //seleciona as palavras que são maiores ou iguais a "co"
        .where("login", isLessThanOrEqualTo: "co"+"\uf8ff")
    //generaliza o resultado mostrando todos que começam com dete
        .orderBy("login", descending: true)
        .orderBy("senha", descending: false)
        .limit(10)
        .getDocuments();

    querySnapshot.documents.forEach((DocumentSnapshot f) {
      var dados = f.data;
      print("snapshot : " + dados.toString());
    });
  }

  //RECUPERAR VARIOS ITENS
  _selectFromTbListen() async {
    QuerySnapshot querySnapshot =
        (await bd.collection("usuario").snapshots().listen((snapshot) {
      snapshot.documents.forEach((f) {
        var dados = f.data;
        print("DADOS: " + dados.toString());
      });
    })) as QuerySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    _salvarComChaveManual();
    return Center();
  }
}
