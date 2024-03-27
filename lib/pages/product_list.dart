import 'package:auth_firebase_application/authentication/login_authentication.dart';
import 'package:auth_firebase_application/authentication/product_list_authentication.dart';
import 'package:auth_firebase_application/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auth_firebase_application/pages/product_details.dart';
import 'package:auth_firebase_application/model/dummy_data.dart';

class ProductListPage extends StatefulWidget {
  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  String _searchText = '';
  void initState() {
    super.initState();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

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
          automaticallyImplyLeading: false,
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
              return Column(
                children: [
                  ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(product.name),
                        Text('Price: \$${product.price.toStringAsFixed(2)}'),
                      ],
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
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider(
          create: (context) => AuthBloc(),
          child: Login(),
        ),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sign out failed'),
      ));
    }
  }
}
