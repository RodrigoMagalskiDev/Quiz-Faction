import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/usuario_model.dart';
import 'telas/Home.dart';
import 'telas/Login.dart';

void main(){
  runApp(MaterialApp(
    home: TelaInicio(),
    title: "Expofred 2022",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.teal,
      secondaryHeaderColor: Colors.tealAccent
    ),
  ));
}

class TelaInicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UsuarioModel>(
      model: UsuarioModel(),
      child: ScopedModelDescendant<UsuarioModel>(
        // ignore: missing_return
        builder: (context, child, model){
          if(model.isLoggedIn()){
           return MaterialApp(
              home: Home(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: Colors.teal,
                  secondaryHeaderColor: Colors.tealAccent
              ),
            );
          } else return Login();
        },
      ),
    );
  }
}

