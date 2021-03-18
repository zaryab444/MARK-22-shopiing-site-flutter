import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      //ClipRect help clipping rectangle round corner
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        //Grid tile is use as header card for display image

        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: id,
            );
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          //gridtile is a textbar of product name
          backgroundColor: Colors.black54,
          leading: IconButton(
            // leading make the icon left
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,

            onPressed: () {},
          ),

          trailing: IconButton(
            //trailing make the icon right
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
