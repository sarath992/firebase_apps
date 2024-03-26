import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auth_firebase_application/model/dummy_data.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: ${product.name}'),
                Text('Price: \$${product.price.toStringAsFixed(2)}'),
                Text('Measurement: ${product.measurement}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _addProductToFirestore(scaffoldContext, product);
                  },
                  child: Text('Add to Firebase'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

void _addProductToFirestore(BuildContext context, Product product) {
    String userId = ''; // Replace this with the actual user ID
    
    // Create a map with product data
    Map<String, dynamic> productData = {
      'user': userId,
      'productName': product.name,
    };

    // Add product data to Firestore in the 'user-products' collection
    FirebaseFirestore.instance.collection('user-products').add(productData).then((value) {
      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product added to your products'),
      ));
    }).catchError((error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add product: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}
