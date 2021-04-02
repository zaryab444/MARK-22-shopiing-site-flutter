import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_project/providers/products.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text('\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,

              ),
            ),
            SizedBox(height: 10),
             Container(
               padding: EdgeInsets.symmetric(horizontal: 10),
               width: double.infinity,
               child: Text(
                 loadedProduct.description,
                 textAlign: TextAlign.center,
                 softWrap: true,),
             ),
            SizedBox(height: 50,),
        RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),

        onRatingUpdate: (rating) {
          print(rating);
        },
      ),

          ],
        ),

      )
    );
  }
}
