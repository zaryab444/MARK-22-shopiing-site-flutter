


import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
   @required this.id,
   @required this.title,
   @required this.price,
   @required this.quantity
});


}

class Cart  with ChangeNotifier{
  Map<String, CartItem>  _items ={};

  Map<String, CartItem> get items{
    return {..._items};
  }
int get itemCount{
    return  _items.length;
}

double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
      total.toStringAsFixed(2); // for my output  will get the total with only two decimal numbers.
    });
    return total;

}

  void addItem(String productId, double price, String title,){
    if(_items.containsKey(productId)){
    //change quantity
      _items.update(productId, (existingCartItem) => CartItem(
        id: existingCartItem.id,
        title: existingCartItem.title,
        price: existingCartItem.price,
        quantity: existingCartItem.quantity + 1 ,
      ));
    }
      else{
 _items.putIfAbsent(productId, () => CartItem(
   id: DateTime.now().toString(),
   title: title,
   price: price,
   quantity: 1,
 ),
 );
    }
notifyListeners();
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }
  addOrRemoveQuantity(String productId, bool operators) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: operators
                ? existingCartItem.quantity + 1
                : existingCartItem.quantity - 1),
      );
    }
    notifyListeners();
  }

  //this condition is used when we pressed undo
void removeSingleItem(String productId){
    if (!_items.containsKey(productId)){
   return;
    }
    if (_items[productId].quantity>1){
      _items.update(productId, (existingCartItem) => CartItem(
          id:existingCartItem.id ,
          title:existingCartItem.title ,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
      ),);
    }
    else {
      _items.remove(productId);
    }
    notifyListeners();
}

  void clear(){
    //this condition when cart go to order section its clear cart
    _items = {};
    notifyListeners();
  }

}