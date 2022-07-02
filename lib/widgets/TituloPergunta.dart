import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_cidades/app/widgets/dropdown_cidades.widget.dart';
import 'package:expofred_2022/class/classResposta.dart';
import 'package:flutter/material.dart';

class TituloPergunta extends StatefulWidget {
  final String idPergunta;
  final String idPesquisa;
  final String text;
  final String tipoPergunta;
  final Function(String text) onFieldSubmitted;
  final Function(String value) onchangedRadio;
  final Function(String value) onchangedCheckBox;
  final Function(String value) onchangedListBox;
  final Function(String value) onChangedCidade;
  final Function(String value) onChangedEstado;
  const TituloPergunta(
        {this.idPergunta, this.idPesquisa, this.text, this.tipoPergunta,
        this.onFieldSubmitted, this.onchangedRadio, this.onchangedCheckBox,
        this.onchangedListBox, this.onChangedCidade, this.onChangedEstado});

  @override
  _TituloPerguntaState createState() => _TituloPerguntaState();
}

class _TituloPerguntaState extends State<TituloPergunta> {
  final TextEditingController _respostaController = TextEditingController();

  int valor = -1;
  bool valor1 = false;
  int resposta = 0;
  String valorSelecionado;
  final _cidadeController = TextEditingController();
  final _ufController = TextEditingController();

  Future<List<Resposta>> recupera() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("pesquisas")
        .document(widget.idPesquisa).collection("perguntas").document(widget.idPergunta)
        .collection("alternativas").getDocuments();

    List<Resposta> lista = List();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      Resposta p = Resposta();
      p.valor = dados["valor"];
      lista.add(p);
    }
    return lista;
  }

  /*
  escolha um valor  = permite escolher 1 opção de 0-10
  escolha um        = escolhe uma opçao com textos
  descritiva        = permite digitar a resposta
  multipla escolha  = permite marcar vários checkbox
  listbox           = escolhe uma opçao na listagem
  uf                = escolhe a UF do entrevistado
   */


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(widget.text,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
            ),
          ),
          FutureBuilder<List<Resposta>>(
              future: recupera(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      // ignore: missing_return
                      itemBuilder: (_, index){
                        List<Resposta> listaItens = snapshot.data;
                        Resposta resposta = listaItens[index];

                        if (widget.tipoPergunta == "descritiva") {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: EdgeInsets.only(top: 5),
                            child: TextFormField(
                              // ignore: missing_return
                              validator: (text) {
                                if (text.isEmpty) return "Preencha o campo";
                              },
                              controller: _respostaController,
                              onFieldSubmitted: (text) {
                                if(text.isNotEmpty){
                                  widget.onFieldSubmitted(text);
                                }
                                if(text.isEmpty) {
                                  widget.onFieldSubmitted(text);
                                }
                              },
                              decoration: InputDecoration(
                                hoverColor: Colors.teal,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.teal)),
                                hintText: "Digite a resposta",
                              ),
                            ),
                          );
                        }

                        if (widget.tipoPergunta == "escolha um valor") {
                          List<String> list = List.from(resposta.valor);
                          return Container(
                            height: 65,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: list.length.toInt(),
                              itemBuilder: (context, int index) {
                                return Column(
                                  children: [
                                    Radio(
                                      activeColor: Colors.teal,
                                      value: int.parse(list[index]),
                                      groupValue: valor,
                                      onChanged: (value) {
                                        setState(() {
                                          valor = value;
                                        });
                                        widget.onchangedRadio(valor.toString());
                                      },
                                    ),
                                    Text(list[index].toString())
                                  ],
                                );
                              },
                            ),
                          );
                        }

                        if (widget.tipoPergunta == "escolha um") {
                          List<String> list = List.from(resposta.valor);
                          return Container(
                            margin: EdgeInsets.all(0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length.toInt(),
                              itemBuilder: (context, int index) {
                                return Row(
                                  children: [
                                    Radio(
                                      activeColor: Colors.teal,
                                      value: index,
                                      groupValue: valor,
                                      onChanged: (value) {
                                        setState(() {
                                          valor = index;
                                        });
                                        widget.onchangedRadio(list[valor].toString());
                                      },
                                    ),
                                    Expanded(child: Text(list[index].toString()))
                                  ],
                                );
                              },
                            ),
                          );
                        }

                        if (widget.tipoPergunta == "listbox") {

                          List<String> list = List.from(resposta.valor);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButton<String>(
                              underline: SizedBox(),
                              hint: Text("Escolha uma opção"),
                              value: valorSelecionado,
                              items: list.map((especie) {
                                return DropdownMenuItem(
                                  child: new Text(especie),
                                  value: especie,
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  valorSelecionado = newValue;
                                  print(valorSelecionado);
                                });
                                widget.onchangedRadio(valorSelecionado);
                              },
                            ),
                          );
                        }

                        if (widget.tipoPergunta == "multiplaEscolha") {
                          String resultadoCheck = "";
                          List<String> list = List.from(resposta.valor);
                          return Container(
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: list.length.toInt(),
                              itemBuilder: (context, int index) {
                                List<CheckBoxModel> itens = [
                                  CheckBoxModel(
                                      texto: list[index],
                                      idPergunta: widget.idPergunta,
                                  )
                                ];
                                return CheckboxWidget(
                                  item: itens[0],
                                  onchangedCheck: (value, check){
                                    if(resultadoCheck == ""){
                                      resultadoCheck = "," + value;
                                      widget.onchangedCheckBox(resultadoCheck);
                                    } else{
                                      if(check == true){
                                        resultadoCheck = resultadoCheck.toString() + "," + value;
                                        widget.onchangedCheckBox(resultadoCheck);
                                      }else{
                                        resultadoCheck = resultadoCheck.replaceAll(',$value', '');
                                        widget.onchangedCheckBox(resultadoCheck);
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        }

                        if (widget.tipoPergunta == "cidade") {
                          String u;
                          String c;
                          return Container(
                            margin: EdgeInsets.only(top: 5),
                            height: 50,
                            width: 350,
                            color: Colors.white,
                            child: DropdownCidades(
                              widthDropdownCity: 150,
                              onChangedState: (_uf) {
                                setState(() {
                                  _ufController.text = _uf;
                                  u = _uf;
                                  widget.onChangedEstado(u);
                                });
                              },
                              onChangedCity: (cid) {
                                setState(() {
                                  _cidadeController.text = cid;
                                  c = cid;
                                  widget.onChangedCidade(c);
                                });
                              },
                            ),
                          );
                        }

                      }),
                );
              }),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

class CheckBoxModel {
  CheckBoxModel({this.texto, this.checked = false, this.idPergunta, this.onchangedCheckBox});

  String texto;
  bool checked;
  String idPergunta;
  String onchangedCheckBox;
}

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({Key key, this.item, this.onchangedCheck}) : super(key: key);

  final CheckBoxModel item;
  final Function(String value, bool check) onchangedCheck;

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.item.texto),
      value: widget.item.checked,
      activeColor: Theme.of(context).primaryColor,
      onChanged: (bool value) {
        setState(() {
          widget.item.checked = value;
          widget.item.onchangedCheckBox = widget.item.texto;
            widget.onchangedCheck(widget.item.texto, widget.item.checked);
        });
      },
    );
  }
}
