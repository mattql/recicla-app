import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recicla_app/Controllers/coletasController.dart';
import 'package:recicla_app/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ColetasController coletasController = ColetasController();
  GoogleMapController? mapController;

  void moverParaLocalizacao(double latitude, double longitude) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        18, // Zoom level
      ),
    );
  }

  void atualizarPosicao() async {
    await coletasController.getPosicao();
    if (coletasController.lat != 0.0 && coletasController.long != 0.0) {
      moverParaLocalizacao(coletasController.lat, coletasController.long);
    }
    setState(() {});
  }

  void _confirmarLogout(BuildContext context) {
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

  void _mostrarInformacoesUsuario(BuildContext context) {
    // Obtém a instância do Firebase Auth
    FirebaseAuth auth = FirebaseAuth.instance;

    // Obtém o usuário atualmente autenticado
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
                Text('usuario: $nomeDoUsuario'),
                Text('email: $emailDoUsuario'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Recicla",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.greenAccent,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.gps_fixed_rounded),
            tooltip: "pegar localização atual",
            onPressed: () {
              atualizarPosicao();
            },
          ),
          IconButton(
              icon: Icon(Icons.logout_rounded),
              tooltip: "logout",
              onPressed: () {
                _confirmarLogout(context);
              })
        ],
      ),
      body: ChangeNotifierProvider<ColetasController>.value(
        value: coletasController,
        child: Builder(builder: (context) {
          final local = context.watch<ColetasController>();

          print(local.long);

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-14.235004, -51.92528), // Brasil
              zoom: 4,
            ),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
                atualizarPosicao(); // atualiza o mapa para posiçao da localização
              });
            },
          );
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.greenAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home_rounded), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.account_circle_rounded),
                onPressed: () {
                  _mostrarInformacoesUsuario(context);
                }),
          ],
        ),
      ),
    );
  }
}
