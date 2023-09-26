import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recicla_app/pages/login_page.dart';

class AuthService {
  static void confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Logout'),
          content: Text('Tem certeza de que deseja sair?'),
          actions: <Widget>[
            TextButton(
              child: Text('cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('sair'),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(); // Fecha o popup
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  ); // Navega para a tela de login
                } catch (e) {
                  print('Erro ao fazer logout: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void mostrarInformacoesUsuario(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String nomeDoUsuario = user?.displayName ?? 'Nome não disponível';
    String emailDoUsuario = user?.email ?? 'Email não disponível';

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Usuário: $nomeDoUsuario'),
                Text('Email: $emailDoUsuario'),
              ],
            ),
          ),
        );
      },
    );
  }
}
