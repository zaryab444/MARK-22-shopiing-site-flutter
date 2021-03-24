import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/cart.dart';
import 'package:shop_project/providers/orders.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
        ChangeNotifierProvider(//this is a provider
      create:(ctx)=> Products(),
        ),
     ChangeNotifierProvider(
        create: (ctx)=> Cart(),
     ),
      ChangeNotifierProvider(create:  (ctx)=> Orders(),
      ),
    ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.deepOrange,


        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName:(ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),

        },
      ),
    );
  }
}


