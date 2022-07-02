import 'package:flutter/material.dart';

class ListAvaliacao extends StatefulWidget {
  final num numero;

  const ListAvaliacao({this.numero});

  @override
  _ListAvaliacaoState createState() => _ListAvaliacaoState();
}

class _ListAvaliacaoState extends State<ListAvaliacao> {

  String valorAntigo;
  String valorNovo;
  Color color;

  void trocaCor(Color novaCor, num valor){
      if(color == Colors.black){
        setState(() {
          color = novaCor;
        });
      } else {
        setState(() {
          color = Colors.black;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          trocaCor(Colors.green, widget.numero);
        },
        child: Container(
          //color: color,
          margin: EdgeInsets.only(right: 5),
          child: Center(
            child: Text(
              widget.numero.toString(),
              style: TextStyle(color: color),
            ),
          ),
          //color: clicou == numero ? Colors.green : Colors.white,
          width: 30,
          height: 30,
          decoration: BoxDecoration(border: Border.all()),
        ),
      ),
    );
  }
}
