import 'dart:math';

import 'package:app_lista_presentes/autenticacao/home.dart';
import 'package:app_lista_presentes/autenticacao/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_lista_presentes/autenticacao/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:app_lista_presentes/criarPresentes/giftform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/cupertino.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MeusPresentes());
// }

// class MeusPresentes extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: GiftForm(),
//     );
//   }
// }

class GiftForm extends StatefulWidget {
  @override
  _GiftFormState createState() => _GiftFormState();
}

class _GiftFormState extends State<GiftForm> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _textPresentsController = TextEditingController();
  TextEditingController _textImageController = TextEditingController();

  List<String> listNames = [];

  @override
  void initState() {
    // refresh();
    //atualização automatica
    db.collection("listPresents").snapshots().listen((snapshot) {
      setState(() {
        listNames = [];
        snapshot.docs.forEach((document) {
          listNames.add(document.get("name"));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      appBar: AppBar(
        title: const Text("Adicionar presentes 🎁"),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(context,
      //         MaterialPageRoute(builder: (context) => const storagePage()));
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Vamos pedir um presentes?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: _textPresentsController,
              decoration: const InputDecoration(labelText: "Nome do Presente"),
            ),
            TextField(
              controller: _textImageController,
              decoration: const InputDecoration(labelText: "URl da imagem"),
            ),
            const Text(
              "ou",
              style: TextStyle(
                fontSize: 20,
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.white,
            //     foregroundColor: Colors.black87,
            //     shadowColor: Colors.grey,
            //     shape: StadiumBorder(),
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            //     textStyle: const TextStyle(
            //         color: Colors.black87,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 16),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const storagePage()));
            //   },
            //   child: const Text("Adicionar IMG"),
            // ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                shadowColor: Colors.grey,
                shape: StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                textStyle: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () {
                sendData();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: const Text("Cadastar"),
            ),
            (listNames.length == 0)
                ? const Text(
                    "Nenhum presente no momento",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  )
                : Column(
                    children: [
                      for (String s in listNames) Text(s),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  // void refresh() async {
  //   QuerySnapshot query = await db.collection("listPresents").get();

  //   listNames = [];
  //   query.docs.forEach((document) {
  //     print(document.id); //Mostrar o id que escolhemos
  //     String data = document.get("name");
  //     String data2 = document.get("img");

  //     setState(() {
  //       listNames.add(data);
  //       listNames.add(data2);
  //     });
  //   });
  // }

//enviar para o bd
  void sendData() {
    String id = const Uuid().v1(); //criando id aleatorio
    db.collection("listPresents").doc(id).set({
      "comprado": false,
      "id": id,
      "name": _textPresentsController.text,
      "image": _textImageController.text
    });

    //Visual Feedback
    _textPresentsController.text = "";
    _textImageController.text = "";
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Salvo no Firestore!"),
      ),
    );
  }
}
