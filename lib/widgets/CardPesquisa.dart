import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expofred_2022/telas/ResumoPesquisa.dart';
import 'package:flutter/material.dart';

class CardPesquisa extends StatefulWidget {
  final DocumentSnapshot doc;
  final String titulo;
  final String subtitulo;

  const CardPesquisa({this.doc, this.titulo, this.subtitulo});
  @override
  _CardPesquisaState createState() => _CardPesquisaState();
}

class _CardPesquisaState extends State<CardPesquisa> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
        color: Colors.teal,
        margin: EdgeInsets.only(bottom: 15),
        child: ListTile(
          title: Text(widget.titulo, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          subtitle: Text("Organizador: " + widget.subtitulo, style: TextStyle(color: Colors.white),),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white,),
          leading: Icon(Icons.assignment, color: Colors.white,),
          onTap: (){
            if(widget.doc.data["disponivel"] == "sim") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ResumoPesquisa(doc: widget.doc,)));
            }
          },
        )
    );
  }
}
