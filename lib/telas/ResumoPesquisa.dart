import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Pesquisa.dart';

class ResumoPesquisa extends StatefulWidget {
  final DocumentSnapshot doc;

  const ResumoPesquisa({this.doc});

  @override
  _ResumoPesquisaState createState() => _ResumoPesquisaState();
}

class _ResumoPesquisaState extends State<ResumoPesquisa> {

  TextEditingController _senhaController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc.data["nome"]),
      ),
      body: Container(
        //color: Colors.grey[400],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  elevation: 10,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(widget.doc.data["nome"], style: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor),),
                          SizedBox(height: 10,),
                          Image.asset('images/expofred.png'),
                          SizedBox(height: 10,),
                          Text("Autor: " + widget.doc.data["organizacao"], style: TextStyle(fontSize: 20),),
                          SizedBox(height: 10,),
                          Text("Detalhes: " + widget.doc.data["descricao"], style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
                          SizedBox(height: 25,),
                          Container(
                              child: RaisedButton(
                                child: Text("Preencher agora", style: TextStyle(color: Colors.white),),
                                color: Theme.of(context).primaryColor,
                                onPressed: (){
                                  if(widget.doc.data["senha"] != null){
                                    showDialog(
                                        context: context,
                                      builder: (BuildContext context){
                                          return AlertDialog(
                                            title: Text("Digite a senha para preencher a pesquisa"),
                                            content: TextField(
                                              controller: _senhaController,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                hoverColor: Colors.teal,
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                    borderSide: BorderSide(
                                                        color: Colors.teal
                                                    )
                                                ),
                                                hintText: "Senha",
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                  onPressed: (){
                                                    if(_senhaController.text == widget.doc.data["senha"]){
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                                          Pesquisa(idPesquisa: widget.doc.documentID, nomePesquisa: widget.doc.data["nome"],)));
                                                    }
                                                    else {

                                                    }
                                                  },
                                                  child: Text("Ok"))
                                            ],
                                          );
                                      }
                                    );
                                  } else
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                      Pesquisa(idPesquisa: widget.doc.documentID, nomePesquisa: widget.doc.data["nome"],)));
                                },
                              ),
                              width: double.infinity,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
