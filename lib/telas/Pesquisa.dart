import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expofred_2022/class/classPergunta.dart';
import 'package:expofred_2022/class/db.dart';
import 'package:expofred_2022/widgets/TituloPergunta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pesquisa extends StatefulWidget {
  final String idPesquisa;
  final String nomePesquisa;

  const Pesquisa({this.idPesquisa, this.nomePesquisa});
  @override
  _PesquisaState createState() => _PesquisaState();
}

class _PesquisaState extends State<Pesquisa> {

  final dbHelper = DatabaseHelper.instance;
  String teste = "";
  int ContPerguntas = 0;
  int cont = 0;
  List<String> listaResposta = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''];
  String idUser;
  String uf = "";

  void _dialog(String title, int action){
    showDialog(
        context: context,
        builder: (context)
        {
          return AlertDialog(
            title: Text(title),
            actions: [
              if(action == 1) FlatButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Ok")),
              if(action == 2) FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Não")
              ),
              if(action == 2) FlatButton(
                onPressed: () {
                  setState(() {
                    cont = ContPerguntas;
                    onWill();
                  });
                  Navigator.of(context).pop();
                },
                child: Text("Sim"),
              ),
            ],
          );
        });
  }

  void _confirma(String title, List<String> resposta){
    showDialog(
        context: context,
        builder: (context)
        {
          return AlertDialog(
            title: Text(title),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Não")
              ),
              FlatButton(
                onPressed: () {
                  _inserir(resposta);
                  Navigator.of(context).pop();
//                  showInSnackBar("Pesquisa finalizada com sucesso!");
                },
                child: Text("Sim"),
              ),
            ],
          );
        });

    // List<String> list;
    // list[i] =
  }

  Future<bool> onWill() async {
    if(cont != ContPerguntas){
      _dialog("Voce ainda não finalizou esta pesquisa. Deseja sair mesmo assim?", 2);
    }
    if(cont == ContPerguntas){
      Navigator.of(context).pop();
    }
  }

  Future<List<Pergunta>> recupera() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("pesquisas").document(widget.idPesquisa).collection("perguntas").getDocuments();

    List<Pergunta> lista = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      Pergunta p = Pergunta();
      p.titulo = dados["titulo"];
      p.tipo = dados["tipo"];
      p.id = item.documentID;
      p.respondeu = "";
      lista.add(p);
    }
    return lista;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) async {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(duration: Duration(seconds: 3), content: new Text(value), backgroundColor: Colors.teal,));
    await Future.delayed(const Duration(seconds: 3), (){onWill();});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWill,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(widget.nomePesquisa),
            actions: [
              // IconButton(icon: Icon(Icons.save), onPressed: () {}),
              // IconButton(icon: Icon(Icons.cancel), onPressed: () {})
//
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10.0),
//                   child: Text(
//                     "$hoursStr:$minutesStr:$secondsStr",
//                     style: TextStyle(
//                       fontSize: 18.0,
//                     ),
//                   ),
//                 ),
//               ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FutureBuilder<List<Pergunta>>(
                    future: recupera(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData) return Container();
                      ContPerguntas = snapshot.data.length;
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          itemBuilder: (_, indice){

                            List<Pergunta> listaItens = snapshot.data;
                            Pergunta pergunta = listaItens[indice];

                            for(int i=0; i<snapshot.data.length; i++){
                              this.listaResposta[indice] = pergunta.resposta;
                            }

                            return Column(
                              children: [
                                if(indice == 3 &&  widget.nomePesquisa == "Questionário Frequentadores") Container(
                              margin: EdgeInsets.only(bottom: 5),
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text("Considerando os itens a seguir, atribua uma nota entre 0 e 10 referente ao seu grau de satisfação,"
                                    "sendo 10 para Completamente Satisfeito (CS) e 0 para Completamente Insatisfeito (CI).",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)),
                              ),
                            ),
                                TituloPergunta(
                                  text: pergunta.titulo,
                                  idPesquisa: widget.idPesquisa,
                                  idPergunta: pergunta.id,
                                  tipoPergunta: pergunta.tipo,

                                  onchangedCheckBox: (value){
                                    if(pergunta.respondeu == ""){
                                      cont++;
                                      pergunta.respondeu = "Sim";
                                      this.listaResposta[indice] = value;
                                      print(listaResposta[indice]);
                                    }
                                    else if(pergunta.respondeu == "Sim" && value.length > 0){
                                      this.listaResposta[indice] = value;
                                      print(listaResposta[indice]);
                                    }
                                    if(pergunta.respondeu == "Sim" && value.length <= 0){
                                      cont--;
                                      pergunta.respondeu = "";
                                      this.listaResposta[indice] = "";
                                      print(listaResposta[indice]);
                                    }
                                  },

                                  onchangedRadio: (value){
                                    if(pergunta.respondeu == ""){
                                      cont++;
                                      pergunta.respondeu = "Sim";
                                      this.listaResposta[indice] = value;
                                      print(pergunta.respondeu);
                                    }
                                    else this.listaResposta[indice] = value;
                                  },

                                  onFieldSubmitted: (text){
                                    if(text.length > 0){
                                      if(pergunta.respondeu == ""){
                                        cont++;
                                        pergunta.respondeu = "Sim";
                                        this.listaResposta[indice] = text;

                                      }
                                      ///salva no banco
                                    }
                                    if(text.length <= 0){
                                      if(pergunta.respondeu != ""){
                                        pergunta.respondeu = "";
                                        this.listaResposta[indice] = "";
                                        cont--;
                                      }
                                    }
                                  },

                                  onchangedListBox: (text){
                                    if(pergunta.respondeu == ""){
                                      cont++;
                                      pergunta.respondeu = "Sim";
                                      this.listaResposta[indice] = text;
                                    }
                                    else this.listaResposta[indice] = text;
                                  },

                                  onChangedEstado: (value){
                                    if(pergunta.respondeu == ""){
                                      this.listaResposta[indice] = value;
                                      print(pergunta.respondeu);
                                      print(cont);
                                      print(this.listaResposta);
                                    } else {
                                      cont--;
                                      pergunta.respondeu = "";
                                      this.listaResposta[indice] = value;
                                      print(this.listaResposta);
                                    }
                                  },

                                  onChangedCidade: (value){
                                    if(value.length > 0){
                                      if(pergunta.respondeu == ""){
                                        cont++;
                                        pergunta.respondeu = "Sim";
                                        this.listaResposta[indice+1] = value;
                                        print(pergunta.respondeu);
                                        print(this.listaResposta);
                                      }
                                    }
                                    else {
                                      pergunta.respondeu = "";
                                      this.listaResposta[indice+1] = "";
                                      cont--;
                                      print(this.listaResposta);
                                    }
                                    print(cont);
                                  },

                                ),
                                SizedBox(height: 5,),
                              ],
                            );
                          });
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      child: Text("Finalizar pesquisa", style: TextStyle(color: Colors.white, fontSize: 20),),
                      color: Colors.teal,
                      onPressed: (){
                        print(this.listaResposta);
                        if(cont != ContPerguntas){
                          _dialog("Voce ainda não finalizou esta pesquisa. Revise os campos e tente novamente", 1);
                        }
                        if(cont == ContPerguntas){
                          //String resultado = json.encode(listaResposta);
                          _confirma("Tem certeza que deseja finalizar?", listaResposta);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  void _inserir(List<String> resposta) async {
    // linha para incluir
    Map<String, dynamic> row = {
      DatabaseHelper.columnResposta1 : resposta[0].toString(),
      DatabaseHelper.columnResposta2 : resposta[1].toString(),
      DatabaseHelper.columnResposta3 : resposta[2].toString(),
      DatabaseHelper.columnResposta4 : resposta[3].toString(),
      DatabaseHelper.columnResposta5 : resposta[4].toString(),
      DatabaseHelper.columnResposta6 : resposta[5].toString(),
      DatabaseHelper.columnResposta7 : resposta[6].toString(),
      DatabaseHelper.columnResposta8 : resposta[7].toString(),
      DatabaseHelper.columnResposta9 : resposta[8].toString(),
      DatabaseHelper.columnResposta_10 : resposta[9].toString(),
      DatabaseHelper.columnResposta_11 : resposta[10].toString(),
      DatabaseHelper.columnResposta_12 : resposta[11].toString(),
      DatabaseHelper.columnResposta_13 : resposta[12].toString(),
      DatabaseHelper.columnResposta_14 : resposta[13].toString(),
      DatabaseHelper.columnResposta_15 : resposta[14].toString(),
      DatabaseHelper.columnResposta_16 : resposta[15].toString(),
      DatabaseHelper.columnResposta_17 : resposta[16].toString(),
      DatabaseHelper.columnResposta_18 : resposta[17].toString(),
      DatabaseHelper.columnResposta_19 : resposta[18].toString(),
      DatabaseHelper.columnResposta_20 : resposta[19].toString(),
      DatabaseHelper.columnResposta_21 : resposta[20].toString(),
      DatabaseHelper.columnResposta_22 : resposta[21].toString(),
      DatabaseHelper.columnResposta_23 : resposta[22].toString(),
      DatabaseHelper.columnResposta_24 : resposta[23].toString(),
      DatabaseHelper.columnResposta_25 : resposta[24].toString(),
      DatabaseHelper.columnEnviou : 'nao',
      DatabaseHelper.columnUsuario: idUser.toString(),
      DatabaseHelper.columnTempo: '$hoursStr:$minutesStr:$secondsStr',
      DatabaseHelper.columnnomePesquisa: widget.nomePesquisa.toString()
    };

    bool sucesso = await inserir(row);

    _scaffoldKey.currentState.removeCurrentSnackBar();

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        sucesso ? "Questionário salvo com sucesso!" : "Erro ao salvar o questionário!",
        style: TextStyle(color: Colors.white),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.black,
    ));

    if(sucesso == true){
      Future.delayed(Duration(seconds: 2), ()=> onWill());
    } else {}
  }

  Future<bool> inserir(row) async {

    try {
      dbHelper.insert(row);
      return true;
    } catch (e){
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    inputData();
     timerStream = stopWatchStream();
     timerSubscription = timerStream.listen((int newTick) {
         hoursStr = ((newTick / (60 * 60)) % 60)
             .floor()
             .toString()
             .padLeft(2, '0');
         minutesStr = ((newTick / 60) % 60)
             .floor()
             .toString()
             .padLeft(2, '0');
         secondsStr =
             (newTick % 60).floor().toString().padLeft(2, '0');
       });
  }

  Future<void> inputData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    setState(() {
      idUser = user.uid;
    });
  }

  bool flag = true;
   Stream<int> timerStream;
   StreamSubscription<int> timerSubscription;
   String hoursStr = '00';
   String minutesStr = '00';
   String secondsStr = '00';

   Stream<int> stopWatchStream() {
     StreamController<int> streamController;
     Timer timer;
     Duration timerInterval = Duration(seconds: 1);
     int counter = 0;

     void stopTimer() {
       if (timer != null) {
         timer.cancel();
         timer = null;
         counter = 0;
         streamController.close();
       }
     }

     void tick(_) {
       counter++;
       streamController.add(counter);
       if (!flag) {
         stopTimer();
       }
     }

     void startTimer() {
       timer = Timer.periodic(timerInterval, tick);
     }

     streamController = StreamController<int>(
       onListen: startTimer,
       onCancel: stopTimer,
       onResume: startTimer,
       onPause: stopTimer,
     );

     return streamController.stream;
   }

}
