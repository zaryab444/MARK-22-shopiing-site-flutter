import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';


class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(
      this.id,
      this.productId,
      this.price,
      this.quantity,
      this.title);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),


        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ) ,
      direction:  DismissDirection.endToStart,//right and left delete icon in dismissible
     confirmDismiss: (direction) {
       return showDialog(
            context: context,
            builder: (ctx)=> AlertDialog(
              title: Text('Are you sure ?'),
              content: Text('Do you want to remove the item of cart ?'),
              actions: <Widget> [
                FlatButton(
       child: Text('No'),
                  onPressed: (){
                   Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: (){
                   Navigator.of(ctx).pop(true);
                  },
                ),

              ],
            ),
        );
     },
      onDismissed: (direction){
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },

      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15,
            vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Container(
              child: Row(
                mainAxisSize:  MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: (quantity > 1)
                        ? () => {
                      Provider.of<Cart>(context, listen: false)
                          .addOrRemoveQuantity(productId, false)
                    }
                        : () => {
                      Provider.of<Cart>(context, listen: false)
                          .removeItem(productId)
                    },
                    icon: Icon(Icons.remove, color: Colors.black),
                  ),
                  Text('$quantity'),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .addOrRemoveQuantity(productId, true);
                    },
                  ),

                ],
              ),
            )

          ),
        ),
      ),
    );
  }
}