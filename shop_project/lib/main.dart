import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/auth.dart';
import 'package:shop_project/providers/cart.dart';
import 'package:shop_project/providers/orders.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_screen.dart';
import './screens/auth_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (_) => Auth(),
        // ),
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
        //  create: (_) => Products(null, []),//error here saying 3 positional arguments expected,but 0 found.
          update: (ctx, auth, previousProducts) => Products(auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
     ChangeNotifierProvider(
        create: (ctx)=> Cart(),
     ),
      ChangeNotifierProxyProvider<Auth, Orders>(
       update: (ctx, auth, previousOrder) => Orders(
         auth.token,
         previousOrder == null ? [] : previousOrder.orders,
       ),
      )
    ],
      //we use consumer because  we use auth changes in login so we not build entire app we only build material app
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),

          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}


