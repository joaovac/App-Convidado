import 'package:app_lista_presentes/autenticacao/home.dart';
import 'package:app_lista_presentes/criarPresentes/giftform.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_lista_presentes/autenticacao/signin.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home:  SignInScreen(),
    );
  }
} //Main Convidados