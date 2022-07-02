import 'package:expofred_2022/model/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Home.dart';

class CriarConta extends StatefulWidget {
  @override
  _CriarContaState createState() => _CriarContaState();
}

class _CriarContaState extends State<CriarConta> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffolKey = GlobalKey<ScaffoldState>();
  bool _BotaoDesabilitado = false;
  bool senhaVisivel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolKey,
        appBar: AppBar(
          title: Text("Criar conta"),
          centerTitle: true,
          elevation: 0,
        ),
        body: ScopedModel<UsuarioModel>(
          model: UsuarioModel(),
          child: ScopedModelDescendant<UsuarioModel>(
      // ignore: missing_return
      builder: (context, child, model) {
          return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          validator: (text) {
                            if (text.isEmpty) return "Nome inválido";
                          },
                          controller: _nomeController,
                          decoration: InputDecoration(
                            hoverColor: Colors.teal,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText: "Nome",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15, right: 15, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          validator: (text) {
                            if (text.isEmpty || !text.contains("@") || !text.contains(".com")) return "Email inválido";
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                            hoverColor: Colors.teal,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText: "Email",
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          validator: (text) {
                            if (text.isEmpty || text.toString().length <= 5) return "Senha inválida";
                          },
                          controller: _senhaController,
                          obscureText: senhaVisivel,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                senhaVisivel
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  senhaVisivel
                                      ? senhaVisivel = false
                                      : senhaVisivel = true;
                                });
                              },
                            ),
                            hoverColor: Colors.teal,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(color: Colors.teal)),
                            hintText: "Senha",
                            prefixIcon: Icon(Icons.vpn_key),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                      child: InkWell(
                        onTap:  (){
                          if(_formKey.currentState.validate()){
                            Map<String, dynamic> userData = {
                              "nome": _nomeController.text,
                              "email": _emailController.text,
                            };

                            model.sigUp(
                                userData: userData,
                                senha: _senhaController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Cadastrar",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
      },
    ),
        ));
  }

  @override
  void initState() {
    setState(() {
      senhaVisivel = true;
    });
  }

  void _onSuccess() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Home()));
    });
  }

  void _onFail() {
    _scaffolKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuario, confira os campos!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {});
  }
}
