import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_lista_presentes/autenticacao/signin.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:app_lista_presentes/criarPresentes/giftform.dart';
import 'package:app_lista_presentes/autenticacao/user.dart' as user;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Stream<List<user.User>> readUsers() => FirebaseFirestore.instance
    .collection("listPresents")
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => user.User.fromJson(doc.data())).toList());

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.purple.shade100,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //backgroundColor: Colors.purple,
        elevation: 0,
        title: const Text(
          "Lista de presentes 🎁",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.blue.shade800,
          Colors.purple,
          Colors.red.shade400,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: StreamBuilder<List<user.User>>(
          stream: readUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 10, right: 10),
                child: GridView.count(
                    //gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    //maxCrossAxisExtent: 200,
                    crossAxisCount: 2,
                    childAspectRatio: 1.25,
                    crossAxisSpacing: 05,
                    mainAxisSpacing: 20,
                    children: [
                      for (final user in users)
                        Card(
                            color: Colors.purple.shade100,
                            child: Column(
                              children: [
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    color: Colors.transparent,
                                    height: 90,
                                    child: Image.network(
                                      user.image,
                                      fit: BoxFit.fill,
                                    )),
                                CheckboxListTile(
                                  value: user.comprado,
                                  onChanged: (bool? value) {
                                    FirebaseFirestore.instance
                                        .collection("listPresents")
                                        .doc(user.id)
                                        .update({"comprado": value});
                                  },
                                  title: Text(user.name,
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.center),
                                )
                              ],
                            ))
                    ]),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      /*
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.red.shade400,
            Colors.purple,
            Colors.blue.shade800,
          ],begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            ),
          ),
        ),
        */
      /*body: Center(
          child: ElevatedButton(
            child: Text("Sair"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Você saiu da sua conta");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ),*/
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add,
      //       size: 30.0, color: Color.fromARGB(255, 227, 233, 236)),
      //   onPressed: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => GiftForm()));
      //   },
      //   //backgroundColor: Color.fromARGB(255, 71, 32, 197),
      // )
    );
  }
}
