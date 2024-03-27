import 'package:auth_firebase_application/authentication/add_to_db_authentication%20.dart';
import 'package:auth_firebase_application/common_widgets/common_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase_application/model/dummy_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc(),
      child: _ProductDetailsUI(product: product),
    );
  }
}

class _ProductDetailsUI extends StatelessWidget {
  final Product product;

  const _ProductDetailsUI({required this.product});

  @override
  Widget build(BuildContext context) {
    String qrData =
        'Name: ${product.name}, Price: ${product.price}, Measurement: ${product.measurement}';
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
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
                CommonWidgets.buildSizedBox(height: 20.0),
                QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                CommonWidgets.buildSizedBox(height: 20.0),
                BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                  builder: (context, state) {
                    if (state is ProductDetailsLoading) {
                      return CircularProgressIndicator();
                    } else if (state is ProductDetailsFailure) {
                      return Text('Error: ${state.error}');
                    } else {
                      return ElevatedButton(
                        onPressed: () {
                          _addProductToFirestore(context, product);
                        },
                        child: Text('Add to Firebase'),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _addProductToFirestore(BuildContext context, Product product) {
    final user = "";

    Map<String, dynamic> productData = {
      'user': user,
      'productName': product.name,
    };

    FirebaseFirestore.instance
        .collection('user-products')
        .add(productData)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product added to firebase database'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add product: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }
}
