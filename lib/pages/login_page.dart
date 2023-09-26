import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recicla_app/pages/home_page.dart';
import 'package:recicla_app/pages/register_page.dart';
import 'package:recicla_app/reusable_widgets/reusable_widget.dart';
import 'package:recicla_app/utils/colors_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                SizedBox(
                  height: 50,
                ),
                reusableTextField("email", Icons.alternate_email_rounded, false,
                    _emailTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("senha", Icons.password_rounded, true,
                    _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                loginRegisterButton(context, true, () async {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } on FirebaseAuthException catch (e) {
                    String errorMessage;
                    if (e.code == 'user-not-found') {
                      errorMessage = 'Usuário não encontrado.';
                    } else if (e.code == 'wrong-password') {
                      errorMessage = 'Senha incorreta.';
                    } else {
                      errorMessage =
                          "Ocorreu um erro inesperado. Por favor, tente novamente. Email ou senha inválidos";
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(errorMessage)));
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }, _isLoading),
                loginOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row loginOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Não tem conta?",
          style: TextStyle(color: Colors.black),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterPage()));
          },
          child: const Text(
            " Registre-se",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
