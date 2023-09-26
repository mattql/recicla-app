import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recicla_app/pages/home_page.dart';
import 'package:recicla_app/reusable_widgets/reusable_widget.dart';
import 'package:recicla_app/utils/colors_utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Criar Conta",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("7FFFD4"),
          hexStringToColor("F8F8FF"),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                reusableTextField("nome de usuario", Icons.person_2_rounded,
                    false, _usernameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("email", Icons.alternate_email_rounded, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("senha", Icons.password_rounded, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                loginRegisterButton(context, false, () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text,
                    );

                    // Agora que o usuário está registrado, vamos adicionar o nome ao perfil
                    await userCredential.user!.updateProfile(
                        displayName: _usernameTextController.text);

                    // Atualize o nome no Firebase
                    await userCredential.user!.reload();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    if (e.code == 'weak-password') {
                      errorMessage =
                          'A senha precisa ter no mínimo 6 caracteres.';
                    } else if (e.code == 'email-already-in-use') {
                      errorMessage =
                          'Este email já está em uso. Tente outro email.';
                    } else {
                      errorMessage =
                          "Ocorreu um erro inesperado. Por favor, tente novamente. $e.code";
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(errorMessage)));
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }, _isLoading)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
