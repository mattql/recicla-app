import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:recicla_app/Controllers/coletasController.dart';
import 'package:recicla_app/Controllers/pontos.dart';
import 'package:recicla_app/Controllers/pontos_repository.dart';
import 'package:recicla_app/pages/addPost_page.dart';
import 'package:recicla_app/pages/home_page.dart';
import 'package:recicla_app/services/auth_service.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  ColetasController coletasController = ColetasController();
  GoogleMapController? mapController;
  List<Pontos> listaPontos = PontosRepository().pontos;

  void moverParaLocalizacao(double latitude, double longitude) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(latitude, longitude),
        18,
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

  void onMarkerTapped(Pontos ponto) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(ponto.foto),
                Text(
                  '${ponto.nome}',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                Text('${ponto.endereco}'),
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
      appBar: AppBar(
        title: Text(
          "Localização dos pontos",
          style: TextStyle(color: Colors.black87, fontSize: 18),
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
                target: LatLng(-14.235004, -51.92528),
                zoom: 40,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                  atualizarPosicao();
                });
              },
              markers: Set<Marker>.from(
                listaPontos.map((ponto) {
                  return Marker(
                      markerId: MarkerId(ponto.nome),
                      position: LatLng(ponto.latitude, ponto.longitude),
                      infoWindow: InfoWindow(
                        title: ponto.nome,
                        snippet: ponto.endereco,
                      ),
                      onTap: () {
                        onMarkerTapped(ponto);
                      });
                }),
              ));
        }),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.greenAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.home_rounded),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                }),
            IconButton(
                icon: Icon(Icons.add_photo_alternate_rounded),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPostPage()));
                }),
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
