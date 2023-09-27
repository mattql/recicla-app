import 'package:flutter/material.dart';
import 'package:recicla_app/Controllers/pontos_repository.dart';
import 'package:recicla_app/pages/home_page.dart';
import 'package:recicla_app/reusable_widgets/reusable_widget.dart';
import 'package:recicla_app/services/auth_service.dart';
import 'package:recicla_app/utils/colors_utils.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController _nomeTextController = TextEditingController();
  String? _caminhoDaImagem;

  void _cadastrarNovoPonto() {
    String nome = _nomeTextController.text;
    if (nome.isNotEmpty && _caminhoDaImagem != null) {
      PontosRepository().adicionarPonto(nome, _caminhoDaImagem!);
      _nomeTextController.clear();
      setState(() {
        _caminhoDaImagem = null;
      });
    }
  }

  Future<void> _pegarImagem() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _caminhoDaImagem = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Adicionar ponto",
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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("7FFFD4"),
          hexStringToColor("F8F8FF"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Cadastro de ponto de reciclagem",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: reusableTextField("Nome", Icons.add_location_rounded,
                  false, _nomeTextController),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              icon: Icon(Icons.add_a_photo),
              label: Text('imagem'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.greenAccent,
              ),
              onPressed: () async {
                _pegarImagem();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('localização'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.greenAccent,
              ),
              onPressed: () {
                _cadastrarNovoPonto();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.add_circle),
              label: Text('cadastrar novo ponto'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.greenAccent,
              ),
              onPressed: () {},
            ),
          ],
        ),
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
