import 'package:flutter/material.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre o app"),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text("O Quiz Faction é um aplicativo que promove pesquisas de satisfação dos mais variados ramos."
                            " O seu objetivo é possibilitar aos usuários o preenchimento de formulários"
                            " permitindo aos responsáveis pela pesquisa, coletar dados e tirar conclusões a respeito do publico-alvo."
                            " As pesquisas possuem perguntas envolvendo características e pontos específicos de um produto, serviço"
                            " ou evento, questionando o usuário para que a partir das respostas obtidas em cada questionário,"
                            " seja posível buscar melhorias neste meio."
                            ""
                            "\n\nSeu uso é gratuito, sem limitações e com a possibilidade de preencher "
                            "formulários de forma offline!",
                          style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
                      ],
                    ),
                  )
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 25.0),
                  child: Text("Desenvolvido por: Rodrigo Magalski Rubin"),
                ),
              )
            ],
          ))
    );
  }
}
