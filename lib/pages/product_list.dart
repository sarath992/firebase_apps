import 'package:auth_firebase_application/authentication/product_list_authentication.dart';
import 'package:auth_firebase_application/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_firebase_application/pages/product_details.dart';
import 'package:auth_firebase_application/model/dummy_data.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchText = '';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductListBloc(firestore: FirebaseFirestore.instance)
            ..add(LoadProducts()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _signOut(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ProductListLoaded) {
              return _buildProductList(state.products);
            } else if (state is ProductListError) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    List<Product> filteredProducts = products.where((product) {
      return product.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search by product name',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              Product product = filteredProducts[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
                trailing: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: QrImageView(
                    data: _generateQrData(product),
                    version: QrVersions.auto,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsPage(product: product),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _generateQrData(Product product) {
    return 'Name: ${product.name}\nPrice: ${product.price}\nMeasurement: ${product.measurement}';
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign out failed'),
      ));
    }
  }
}
