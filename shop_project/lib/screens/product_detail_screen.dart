import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/products.dart';



class ProductDetailScreen extends StatelessWidget {
// final String title;
// ProductDetailScreen(this.title);
static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
  final productId = ModalRoute.of(context).settings.arguments as String;
  final loadedProduct = Provider.of<Products>(context, listen:false).findById(productId);//this condition is use when you tap any product so the title of detail product set the names of product

    return Scaffold(
      appBar: AppBar(
    title: Text(loadedProduct.title),
      ),
    );
  }
}
