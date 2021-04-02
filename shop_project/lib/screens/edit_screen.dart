import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id:null,
      title:  ' ',
      price: 0,
      description: '',
      imageUrl: ''
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isinit = true;
  var _isLoading = false;

  @override

  void initState() {
    // TODO: implement initState
    _imageUrlController.addListener(() {
      setState((){});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isinit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null){
        _editedProduct =  Provider.of<Products>(context, listen: false).findById(productId);


        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl':'',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }


    }
    _isinit = false;
    super.didChangeDependencies();
  }
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

 Future <void> _saveForm() async{
   final isvalid =  _form.currentState.validate();
   if(!isvalid){
     return;
   }
      _form.currentState.save();
   setState(() {
     _isLoading = true;

   });
     if (_editedProduct.id  != null){

      await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id , _editedProduct);
     setState(() {
       _isLoading= false;
     });
       Navigator.of(context).pop();


     } else {
       try{
         await  Provider.of<Products>(context, listen: false)
             .addProduct(_editedProduct);
       } catch (error){
      await   showDialog<Null>(
             context: context,
             builder: (ctx) => AlertDialog(
               title: Text( 'An error occured'),
               content: Text('Something went wrong'),
               actions: <Widget>[
                 FlatButton(
                     onPressed: (){
                       Navigator.of(context).pop();
                     },
                     child: Text('Okay'))
               ],

             ),
         );
       } finally {
         setState(() {
           _isLoading = false;
         });
         Navigator.of(context).pop(); //we use then because we use loader in app for post a product

       }






     }

       // Navigator.of(context).pop();
  }

  void _updateImageUrl(){
    if (_imageUrlController.text.isEmpty ||
        ( !_imageUrlController.text.startsWith('http') &&
            !_imageUrlController.text.startsWith('https'))||
        (!_imageUrlController.text.endsWith('.png') &&
            !_imageUrlController.text.endsWith('.jpg') &&
            !_imageUrlController.text.endsWith('.jpeg'))) {
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        actions: <Widget> [
          IconButton(icon: Icon(Icons.save),

              onPressed:_saveForm ,
          ),
        ],
      ),
      body:_isLoading ? Center(child: CircularProgressIndicator(),
      )

          :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,

          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'] ,
                decoration: InputDecoration(labelText: 'Title',),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator:(value){
                  if (value.isEmpty){
                    return 'Please provide the value';
    }
                  return null;
                  },

                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(title: value,
                  id: _editedProduct.id,
                  isFavorite: _editedProduct.isFavorite
                  );

                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value){
                  if (value.isEmpty){
                       return 'Please enter the price';
                  }
                  if(double.tryParse(value) == null){
                    return ' Please enter the valid number';
                  }
                   if (double.parse(value) <= 0){
                     return ' Please enter a number greater than zero ';
                   }
                   return null;
                },
                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(price: double.parse(value),
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                    validator: (value){
                  if (value.isEmpty){
                    return 'Please enter a description';
                  }
                  if (value.length < 10){
                    return 'Should be at least 10 character long';
                  }
                  return null;
                    },

                onSaved: (value) {
                  _editedProduct = _editedProduct.copyWith(description: value,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(

                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) =>{
                        _saveForm(),
                      },

                      validator: (value){
                        if (value.isEmpty){
                          return 'Please enter an image URL';
                        }
                        // if (!value.startsWith('http') && !value.startsWith('https')){
                        //   return 'Please enter a valid URL';
                        // }
                        // if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')) {
                        //   return 'Please enter a valid image URL';
                        // }
                        return null;
                          } ,
                      onSaved: (value) {
                        _editedProduct = _editedProduct.copyWith(imageUrl: value,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
