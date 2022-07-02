import 'package:expofred_2022/model/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'CriarConta.dart';
import 'Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffolKey = GlobalKey<ScaffoldState>();
  bool senhaVisivel;

  @override
  void initState() {
    setState(() {
      senhaVisivel = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolKey,
      body: ScopedModelDescendant<UsuarioModel>(
        // ignore: missing_return
        builder: (context, child, model){
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );
          if(!model.isLoggedIn()){
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.teal, Colors.teal.shade200],
                              end: Alignment.bottomCenter,
                              begin: Alignment.topCenter),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              bottom: 20,
                              right: 20,
                              child: Text(
                                "Bem vindo",
                                style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                          Center(
                              child: Text("Expofred 2022", style: TextStyle(color: Colors.white, fontSize: 45),)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hoverColor: Colors.teal,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.teal
                                )
                            ),
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
                                borderSide: BorderSide(
                                    color: Colors.teal
                                )
                            ),
                            hintText: "Senha",
                            prefixIcon: Icon(Icons.vpn_key),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Não possui uma conta? ", style: TextStyle(fontSize: 16),),
                            GestureDetector(
                              child: Text("Cadastre-se", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 16),),
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CriarConta()));
                              },
                            )
                          ],
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
                      child: InkWell(
                        onTap: (){
                          if (_formKey.currentState.validate()) {}
                          model.signIn(
                              email: _emailController.text,
                              senha: _senhaController.text,
                              onSuccess: _onSuccess,
                              onFail: _onFail);
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
                            "Login",
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
          }
        }
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }

  void _onFail() {
    _scaffolKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao entrar! Verifique os campos e tente novamente"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
    });
  }

}
