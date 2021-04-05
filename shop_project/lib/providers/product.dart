import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product  with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;



  //constructor
  Product(
      {
        @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false,

      });


  //choose favourite products method
  Future <void> toggleFavoriteStatus(String token, String userId) async{
   final oldStatus = isFavorite;
   isFavorite = !isFavorite;
    notifyListeners();
   // final url = Uri.https('flutter-update-6f52d-default-rtdb.firebaseio.com', '/products/$id.json',{'auth':token});
                                                                                        //first is userid second is product id
   final url = Uri.https('flutter-update-6f52d-default-rtdb.firebaseio.com', '/userFavorites/$userId/$id.json',{'auth':token});
   try{
   final response =   await  http.put(url,
       body: json.encode(
        isFavorite,
       ),


     );
    if(response.statusCode>=400){
      isFavorite = oldStatus;
      notifyListeners();
    }
   } catch(error){
       isFavorite = oldStatus;
       notifyListeners();
   }
  }


  //this method use in to overcome repetetive code in validators
  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
