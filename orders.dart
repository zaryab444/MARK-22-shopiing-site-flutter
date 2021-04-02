import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_project/models/http_exception.dart';
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

  Future<void> fetchAndSetOrders() async {
    var url = Uri.https('flutter-update-6f52d-default-rtdb.firebaseio.com', '/products.json');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
              id: item['id'],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title'],
            ),
          )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }


  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https('flutter-update-6f52d-default-rtdb.firebaseio.com', '/orders.json');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price,
        })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
  // void addOrder (List<CartItem> cartProducts, double total){
  //   _orders.insert(
  //     0,
  //     OrderItem(
  //       id: DateTime.now().toString(),
  //       amount: total,
  //       dateTime: DateTime.now(),
  //       products:  cartProducts,
  //     ),
  //
  //   );
  //   notifyListeners();
  // }






  void removeItem(String id){
    _orders.remove(id);
    notifyListeners();
  }
  Future <void> deleteProduct(String id) async{

    final url = Uri.https('flutter-update-6f52d-default-rtdb.firebaseio.com', '/orders/$id.json');
    final existingOrderIndex = _orders.indexWhere((ord) => ord.id == id);
    var existingOrder = _orders[existingOrderIndex];
    _orders.removeAt(existingOrderIndex);
    notifyListeners();
    final response = await http.delete(url);
    if(response.statusCode >=400) {
      _orders.insert(existingOrderIndex, existingOrder );
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingOrder = null;
    // _orders.removeWhere((ord) => ord.id == id);
    // notifyListeners();
  }



}