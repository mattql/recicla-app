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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ColetasController>(
        create: (context) => ColetasController(),
        child: Builder(builder: (context) {
          final local = context.watch<ColetasController>();

          print(local.long);

          return GoogleMap(initialCameraPosition: CameraPosition(
              target: LatLng(local.lat,local.long),
              zoom: 18,
            ),
            myLocationEnabled: true,
          );
        }),
      ),
    );
  }
}
