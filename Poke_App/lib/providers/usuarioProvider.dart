import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioProvider{

  String _firebasetoken = 'AIzaSyCTc8YDcq_xy76I3a0naUQt6TK9U3uNVNQ';

  Future nuevoUsuario(String email, String password) async{
    final authData ={
      'email': email,
      'password' : password,
      'returnSecureToken' : true
    };

    final response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebasetoken',
       body: json.encode(authData)
    );

    Map<String,dynamic> decodeResponse = json.decode(response.body);
    print(decodeResponse);

    if ( decodeResponse.containsKey('idToken') ) {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', decodeResponse['idToken']);
      prefs.setString('uid', decodeResponse['localId']);

      return { 'ok': true, 'token': decodeResponse['idToken'] };
    } else {
      return { 'ok': false, 'mensaje': decodeResponse['error']['message'] };
    }
  }

  Future<Map<String, dynamic>> login( String email, String password) async {

    final authData = {
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebasetoken',
      body: json.encode( authData )
    );

    Map<String, dynamic> decodedResponse = json.decode( resp.body );

    print(decodedResponse);

    if ( decodedResponse.containsKey('idToken') ) {
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', decodedResponse['idToken']);
      prefs.setString('uid', decodedResponse['localId']);

      return { 'ok': true, 'token': decodedResponse['idToken'] };
    } else {
      return { 'ok': false, 'mensaje': decodedResponse['error']['message'] };
    }

  }


}