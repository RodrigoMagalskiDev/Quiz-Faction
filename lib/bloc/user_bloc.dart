import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';


class UserBloc extends BlocBase {

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<bool> get outLoading => _loadingController.stream;
  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  DocumentSnapshot user;
  String uf;
  String cidade;
  String uid;
  Map<String, dynamic> unsavedData;

  UserBloc({this.user, this.uf, this.cidade}){
    if(user != null){
      unsavedData = Map.of(user.data);

      _createdController.add(true);
    } else {
      unsavedData = {
        "nome": null, "endereco": null,
      };
      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveNome(String nome){
    unsavedData["nome"] = nome;
  }

  void saveEndereco(String endereco){
    unsavedData["endereco"] = endereco;
  }

  void saveBairro(String bairro){
    unsavedData["bairro"] = bairro;
  }

  void saveTelefone(String telefone){
    unsavedData["telefone"] = telefone;
  }

  void saveDataNasc(String dataNasc){
    unsavedData["dataNasc"] = dataNasc;
  }

  void saveEmail(String email){
    unsavedData["email"] = email;
  }

  void saveCidade(String cidade){
    unsavedData["cidade"] = cidade;
  }

  void saveUf(String uf){
    unsavedData["uf"] = uf;
  }

  Future<bool> deleteUser() async{
    user.reference.delete();
    return true;
  }

  Future<bool> saveUser() async {
    _loadingController.add(true);

    try {
      if(user != null){
        await user.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance.collection("usuarios").add(Map.from(unsavedData)..remove("imagens"));
        await dr.updateData(unsavedData);
      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    } catch (e){
      _loadingController.add(false);
      return false;
    }
  }


  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }

}