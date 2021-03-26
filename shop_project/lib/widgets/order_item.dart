
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  //we use intl package to use Dateformat
import 'package:provider/provider.dart';
import 'package:shop_project/providers/orders.dart';
import '../providers/orders.dart' as ord;
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order );

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {


  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.order.id),
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
       // onDismissed: (direction){
       //  Provider.of<ord.OrderItem>(context, listen: false).id;
       // },

      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: IconButton(
                  icon: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more
                  ),
                  onPressed: (){
                       setState(() {
                         _expanded = ! _expanded;
                       });
                  },
                ),
              ),
          leading:    IconButton(
                icon: Icon(Icons.delete),
                onPressed: (){
                  Provider.of <Orders>(context,listen: false).deleteProduct(widget.order.id);
                },
                color: Theme.of(context).errorColor,

              ),
            ),
            if (_expanded) Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100) , //for sizing when we press the epand button it show order items so we set these sizes
              child: ListView(
                children: widget.order.products.map((prod)=>
                    Row(
                      mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children:<Widget> [
                    Text(
                      prod.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${prod.quantity}x \$${prod.price}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                )).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
