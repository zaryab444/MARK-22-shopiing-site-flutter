

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth{
    return token !=null;
  }
  String get token{
    if(_expiryDate !=null && _expiryDate.isAfter(DateTime.now()) && _token!=null){
        return _token;
    }
    return null;
  }



 Future <void> __authenticate(String email , String password, String urlSegment) async {
   final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCsopRW7-dmjBMw8QDGiqx-vFIR37ngT70');
   try{
     final response = await http.post(
       url,
       body: json.encode(
         {
           'email': email,
           'password': password,
           'returnSecureToken': true,
         },
       ),
     );
     final responseData = json.decode(response.body);
     if(responseData['error'] !=null){
      throw HttpException(responseData['error']['message']);
     }
     _token = responseData['idToken']; //idToken check the firebase response you actually get back idToken check officical firebase url auth docs
     _userId = responseData['localId'];
     _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'] )),
     );
   notifyListeners();
   } catch(error){
  throw error;
   }

 }
  Future<void> signup(String email, String password) async {

   return __authenticate(email, password, 'signUp');
  }

  Future <void> login(String email, String password) async{
   return __authenticate(email, password, 'signInWithPassword');

  }


}