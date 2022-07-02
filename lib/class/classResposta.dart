import 'package:cloud_firestore/cloud_firestore.dart';

class Resposta{

  List _valor;
  String _respondeu;
  String _resposta;

  Resposta();

  Resposta.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.valor = documentSnapshot["valor"];
    this.respondeu = "";
    this.resposta = "";

  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "valor" : this.valor,
      "respondeu" : this.respondeu,
      "resposta" : this.resposta,
    };

    return map;

  }

  List get valor => _valor;

  set valor(List value) {
    _valor = value;
  }

  String get respondeu => _respondeu;

  set respondeu(String value) {
    _respondeu = value;
  }

  String get resposta => _resposta;

  set resposta(String value) {
    _resposta = value;
  }


}