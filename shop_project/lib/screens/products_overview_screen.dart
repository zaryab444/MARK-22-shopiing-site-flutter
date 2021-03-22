import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/cart.dart';


import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

enum FilterOption {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
   var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOption selectedValue){
              setState(() {
                if (selectedValue == FilterOption.Favourites){
                  _showOnlyFavorites = true;
                }
                else{
                  _showOnlyFavorites = false;
                }
              });


            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) =>[
              PopupMenuItem(child: Text('Only favouite'), value: FilterOption.Favourites),
              PopupMenuItem(child: Text('Show all'), value: FilterOption.All,),
            ],
          ),
     Consumer<Cart>(builder: (_, cart, ch) => Badge(
       child: ch ,
       value: cart.itemCount.toString(),
     ),
     child:  IconButton(
         icon: Icon(
           Icons.shopping_cart,
         ),
         onPressed:(){
              Navigator.of(context).pushNamed(CartScreen.routeName);
         } ,
       ),
     ),
        ],
      ),

      body:  ProductsGrid(_showOnlyFavorites),



    );
  }
}