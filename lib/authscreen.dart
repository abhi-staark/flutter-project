import 'package:flutter/material.dart';
import 'package:app2/authform.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentitation'),
        backgroundColor: Colors.pink,
      ),
      body: AuthForm(),
      //backgroundColor: Colors.black,
    );
  }
}
