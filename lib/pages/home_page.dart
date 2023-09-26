import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recicla_app/Controllers/coletasController.dart';
import 'package:recicla_app/services/auth_service.dart';

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
            tooltip: "localização atual",
            onPressed: () {
              atualizarPosicao();
            },
          ),
          IconButton(
              icon: Icon(Icons.logout_rounded),
              tooltip: "logout",
              onPressed: () {
                AuthService.confirmarLogout(context);
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
                  AuthService.mostrarInformacoesUsuario(context);
                }),
          ],
        ),
      ),
    );
  }
}
