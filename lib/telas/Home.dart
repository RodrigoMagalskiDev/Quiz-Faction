import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expofred_2022/class/db.dart';
import 'package:expofred_2022/model/usuario_model.dart';
import 'package:expofred_2022/widgets/CardPesquisa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'Sobre.dart';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final dbHelper = DatabaseHelper.instance;
  FirebaseUser firebaseUser;
  Firestore db = Firestore.instance;
  int quantidadeRegistros = 0;
  String idUser;
  String texto;
  String nomeUser;
  String email;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  void respostas() async {
    final cont = await dbHelper.queryRowCount(idUser);
    final List<dynamic> resultado = await dbHelper.result();
    setState(() {
      texto = resultado.toString();
      quantidadeRegistros = cont;
      respostas();
    });
  }

  Future<bool> save(cont, List<dynamic> resultado) async {

    try {
      final result = await InternetAddress.lookup('example.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("ok");
      }
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () => Future.value(false),
              child:AlertDialog(
                  title: new Text("Exportando respostas para o servidor..."),
                  content: Text("AGUARDE!")
              )
          );
        },
      );
      try {
        for(int i=0; i<quantidadeRegistros; i++){
          await db.collection("respostas").add({
            "resposta": resultado[i]
          });
        }
        Navigator.of(context).pop();
        return true;
      } catch (e){
        Navigator.of(context).pop();
        return false;
      }
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Falha na conexão com a internet!'),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok')),
              ],
            );
          });
    }

  }

  void exporta() async {
    final cont = await dbHelper.idPesquisa();
    final List<dynamic> resultado = await dbHelper.result();
    bool sucesso = await save(cont, resultado);

    _scaffoldKey.currentState.removeCurrentSnackBar();

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        sucesso ? "Exportado com sucesso!" : "Erro ao exportar!",
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.teal,
    ));

    if(sucesso == true){
      dbHelper.update(idUser);
      respostas();
    }
  }

  Future<void> inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
      idUser = user.uid;
      email = user.email;
      nomeUser = user.displayName.toString();
  }

  @override
  void initState() {
    super.initState();
    inputData();
    respostas();
  }

  @override
  Widget build(BuildContext context) {
    UsuarioModel user = UsuarioModel();
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text(email.toString()),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.teal, size: 45,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: GestureDetector(
                child: Container(
                  height: 60.0,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        size: 32.0,
                      ),
                      SizedBox(width: 32.0,),
                      Text(
                        "Sobre o app",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Sobre()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 32.0),
              child: GestureDetector(
                child: Container(
                  height: 60.0,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.subdirectory_arrow_right,
                        size: 32.0,
                      ),
                      SizedBox(width: 32.0,),
                      Text(
                        "Sair",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  user.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> TelaInicio()));
                },
              ),
            )
          ],
        )
      ),
      key: _scaffoldKey,
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            backgroundColor: Colors.teal,
            title: Text("Expofred 2022"),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.backup),
                  onPressed: () async {
                    if(quantidadeRegistros <= 0){
                      _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Voce não possui pesquisas respondidas em aberto!', style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.teal[400],
                          ));
                    }
                    else exporta();
              }),
            ],
          ),
          body:
            Container(
                //color: Colors.grey[200],
                child: FutureBuilder<QuerySnapshot>(
                  future:
                      Firestore.instance.collection("pesquisas").where("disponivel", isEqualTo: "sim").getDocuments(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SingleChildScrollView();
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child:
                          Column(
                            children: [
                              if(quantidadeRegistros > 0) Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text("Voce possui $quantidadeRegistros pesquisa(s) respondida(s) para exportar para o servidor!",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                              ),
                              Column(
                                children: snapshot.data.documents.map((doc) {
                                  return CardPesquisa(
                                    titulo: doc.data["nome"],
                                    subtitulo: doc.data["organizacao"],
                                    doc: doc,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              )
          );
  }
}
