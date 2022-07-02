import 'package:cloud_firestore/cloud_firestore.dart';

class Pergunta{

  String _id;
  String _tipo;
  String _titulo;
  String _respondeu;
  String _resposta;

  Pergunta();

  Pergunta.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id = documentSnapshot["id"];
    this.tipo = documentSnapshot["tipo"];
    this.titulo = documentSnapshot["titulo"];
    this.resposta = documentSnapshot["resposta"];
    this.respondeu = "";

  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "id" : this.id,
      "tipo" : this.tipo,
      "titulo" : this.titulo,
      "respondeu" : this.respondeu,
      "resposta" : this.resposta,
    };

    return map;

  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get resposta => _resposta;

  set resposta(String value) {
    _resposta = value;
  }

  String get titulo => _titulo;

  set titulo(String value) {
    _titulo = value;
  }

  String get respondeu => _respondeu;

  set respondeu(String value) {
    _respondeu = value;
  }


}