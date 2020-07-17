import 'package:flutter/material.dart';
import 'package:flutterappwhatsappcb/home.dart';
import 'package:flutterappwhatsappcb/login/Cadastro.dart';
import 'package:flutterappwhatsappcb/login/login.dart';
import 'package:flutterappwhatsappcb/views/configuracoes.dart';
import 'package:flutterappwhatsappcb/views/teste_imagePikker.dart';
import 'package:flutterappwhatsappcb/views/viewContatos.dart';
import 'package:flutterappwhatsappcb/views/viewConversas.dart';
import 'package:flutterappwhatsappcb/views/viewMensagens.dart';

class RouteGenerator{
  static const String ROTA_HOME = "/home";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_CAD_USER = "/cadastro";
  static const String ROTA_ABA_CONVERSAS = "/abaConversas";
  static const String ROTA_ABA_CONTATOS = "/abaContatos";
  static const String ROTA_CONFIG = "/configuracoes";
  static const String ROTA_MSGS = "/mensagens";


  static Route<dynamic> generateRoute(RouteSettings settings){

    final args = settings.arguments;

    switch(settings.name){
      case "/": return MaterialPageRoute(builder: (_) => Login());
      case ROTA_HOME: return MaterialPageRoute(builder: (_) => Home());
      case ROTA_LOGIN: return MaterialPageRoute(builder: (_) => Login());
      case ROTA_CAD_USER: return MaterialPageRoute(builder: (_) => CadastroUsuario());
      case ROTA_ABA_CONVERSAS: return MaterialPageRoute(builder: (_) => abaConversas());
      case ROTA_ABA_CONTATOS: return MaterialPageRoute(builder: (_) => abaContatos());
      case ROTA_CONFIG: return MaterialPageRoute(builder: (_) => Configuracoes());
      case ROTA_MSGS: return MaterialPageRoute(builder: (_) => Mensagens(args));

      default: _erroRota();
    }
  }

  static Route<dynamic> _erroRota(){
    return MaterialPageRoute(
     builder: (_){
       return Scaffold(
         appBar: AppBar(title: Text("Tela não Encontrada!"),),
         body: Center(child: Text("Tela não Encontrada!"),),
       );
     }
   );
  }

}