import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;


  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
class Orders with ChangeNotifier {
        List<OrderItem> _orders = [];
        List<OrderItem> get orders {
          return [..._orders];
        }
void addOrder (List<CartItem> cartProducts, double total){
          _orders.insert(
            0,
              OrderItem(
                  id: DateTime.now().toString(),
                  amount: total,
                  dateTime: DateTime.now(),
                   products:  cartProducts,
              ),

          );
          notifyListeners();
}
//   Future <void> addOrder(List<CartItem>, OrderItem orderItem) async{
//     var url = Uri.https('flutter-update-6f52d-default-rtdb.firebaseio.com', '/orders.json');
//     try {
//       final response = await http.post(url, body: json.encode({
//     _orders.insert(
//     0,
//         OrderItem(
//         id: orderItem.id,
//         amount: orderItem.amount,
//         'dateTime': orderItem.dateTime,
//         'products': orderItem.products,
//   ),
//   );
//       }),
//
//       );
//       final newOrder = OrderItem(
//
//         amount: orderItem.amount,
//         dateTime: orderItem.dateTime,
//         products: orderItem.products,
//
//         id: json.decode(response.body)['name'],
//       );
//       _orders.add(newOrder);
//       notifyListeners();
//
//     } catch (error){
//       print(error);
//       throw error;
//     }
//
//
//
//
//
//   }







        void removeItem(String id){
          _orders.remove(id);
          notifyListeners();
        }
        void deleteProduct(String id){

          _orders.removeWhere((prod) => prod.id == id);
          notifyListeners();
        }

}