import 'package:flutter/material.dart';
import 'package:recicla_app/Controllers/pontos.dart';
import 'package:recicla_app/Controllers/pontos_repository.dart';
import 'package:recicla_app/pages/addPost_page.dart';
import 'package:recicla_app/pages/maps_page.dart';
import 'package:recicla_app/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pontos> pontos = PontosRepository().pontos;
  final ScrollController _scrollController = ScrollController();

  void _navigateToMap(Pontos ponto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Pontos de reciclagem",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.greenAccent,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
              icon: Icon(Icons.logout_rounded),
              tooltip: "logout",
              onPressed: () {
                AuthService.confirmarLogout(context);
              })
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: pontos.length,
        itemBuilder: (context, index) {
          Pontos ponto = pontos[index];
          return GestureDetector(
            onTap: () {
              _navigateToMap(ponto);
            },
            child: Card(
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(ponto.foto),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ponto.nome,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Text(ponto.endereco),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.greenAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.home_rounded),
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }),
            IconButton(
                icon: Icon(Icons.add_photo_alternate_rounded),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPostPage()));
                }),
            IconButton(
                icon: Icon(Icons.map_rounded),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MapsPage()));
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
