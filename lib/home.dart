import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterappwhatsappcb/model/usuarioFireBase.dart';
import 'package:flutterappwhatsappcb/views/viewContatos.dart';
import 'package:flutterappwhatsappcb/views/viewConversas.dart';

import 'RouteGenerator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;
  String _emailUsuario="";
  List<String> _itensMenu=["Configurações", "test", "Sair"];
  
  Future _verificarUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    if (usuarioLogado == null) {
      Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
    }

    setState(() {
      _emailUsuario = usuarioLogado.email;
    });
  }

  _deslogar()async{
    UserFirebase.deslogar();
    Navigator.pushReplacementNamed(context, RouteGenerator.ROTA_LOGIN);
  }

  _escolhaMenuItem(String itemEscolhido){
    switch(itemEscolhido){
      case "Configurações":
        Navigator.pushNamed(context, RouteGenerator.ROTA_CONFIG);
        break;
      case "Sair":
        _deslogar();
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verificarUsuarioLogado();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WhatsApp"),
        bottom: TabBar(
          indicatorWeight: 7,
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "Conversas",),
              Tab(text: "Contatos",),
            ]
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return _itensMenu.map((String item) {
                return PopupMenuItem<String>(
                 value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
          children: <Widget>[
            abaConversas(),
            abaContatos(),
          ],
      )
    );
  }
}
