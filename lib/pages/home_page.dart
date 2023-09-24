import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      body: Center(
        child: ElevatedButton(
          child: Text("logout"),
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("logout");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            });
          },
        ),
      ),
    );
  }
}
