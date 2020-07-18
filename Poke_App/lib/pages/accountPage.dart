import 'package:flutter/material.dart';
import 'package:flutte_pokedex/widgets/customWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = new GlobalKey<FormState>();
  String _userName;
  String _fullName;
  String _age;
  String _avatar;
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _topRightPokeball(),
          _showForm()
        ],
      ),
    );
  }

  Widget _topRightPokeball() {
    return Positioned(
      right: 0,
      top: 0,
      child: Align(
        heightFactor: fullWidth(context) <= 360 ?  getDimention(context, 1.03) : .74,
        widthFactor:  fullWidth(context) <= 360 ?  getDimention(context,.98) : .69,
        alignment: Alignment.bottomLeft,
        child: Image.asset(
          'assets/images/pokeball.png',
          color: Color(0xffe3e3e3).withAlpha(100),
          height: getDimention(context, 250),    
        ),
      )
    );
  }


   Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _title(),
              _userNameInput(),
              _fullNameInput(),
              _ageInput(),
              _showPrimaryButton()
            ],
          ),
        )
    );
  }

  Widget _userNameInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'User Name',
            icon: new Icon(
              Icons.account_circle,
              color: Colors.grey,
            )),
        onSaved: (value) => _userName = value.trim(),
      ),
    );
  }


  Widget _fullNameInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Full name',
            icon: new Icon(
              Icons.supervised_user_circle,
              color: Colors.grey,
            )),
        onSaved: (value) => _fullName = value.trim(),
      ),
    );
  }

  Widget _ageInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Edad',
            icon: new Icon(
              Icons.accessibility,
              color: Colors.grey,
            )),
        onSaved: (value) => _age = value.trim(),
      ),
    );
  }

  Widget _title(){
    return  Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          BackButton(color: Colors.black,),
          Text('Complete su registro', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      ]
    );
  }


   Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Finalizar',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit(){
    if(validateAndSave()){
      final personalData = {
        'age': _age,
        'fullName': _fullName,
        'userName': _userName,
        'favorites' : [],
        'friends' : []
      };
      createData(personalData);
      Navigator.pushNamed(context, '/principalPage');
    }
  }

  void createData (Map<String,dynamic> data) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid');
    await databaseReference.collection('usuarios').document(uid).setData(data);
  }
}