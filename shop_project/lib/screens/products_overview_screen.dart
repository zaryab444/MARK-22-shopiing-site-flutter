import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/cart.dart';
import '../widgets/app_drawer.dart';


import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../providers/products.dart';

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
   var _isInit = true;
   var _isloading = false;


   @override
  void initState() {
// Provider.of<Products>(context).fetchAndSeetProducts(); wont work
//    Future.delayed(Duration.zero).then((_){
//      Provider.of<Products>(context).fetchAndSeetProducts();
//    }); This method also work you dont need didchange dependencies method but your wish which you want to use

    super.initState();
  }
  @override
  void didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isloading = true;
      });

     /// Provider.of<Products>(context).fetchAndSetProducts();
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
setState(() {
  _isloading =false;

});
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      drawer: AppDrawer(),

      body:  //ProductsGrid(_showOnlyFavorites),
    _isloading ? Center(child: CircularProgressIndicator(),
    )
        : ProductsGrid(_showOnlyFavorites),



    );
  }
}