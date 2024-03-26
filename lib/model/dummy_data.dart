// // import 'package:cloud_firestore/cloud_firestore.dart';
// // class Product {
// //   final String name;
// //   final double price;
// //   final double measurement;

// //   Product({required this.name, required this.price,required this.measurement});

// //   Map<String, dynamic> toMap() {
// //     return {
// //       'name': name,
// //       'price': price,
// //       'measurement' :measurement,
// //     };
// //   }
// // }

// // List<Product> generateDummyData() {
// //   return [
// //     Product(name: 'Product 1', price: 10.99, measurement: 12),
// //     Product(name: 'Product 2', price: 20.49, measurement: 21),
// //     Product(name: 'Product 3', price: 15.79, measurement: 34),
// //     Product(name: 'Product 4', price: 10.99, measurement: 43),
// //     Product(name: 'Product 5', price: 20.49, measurement: 5),
// //     Product(name: 'Product 6', price: 15.79, measurement: 6),
// //     Product(name: 'Product 7', price: 10.99, measurement: 17),
// //     Product(name: 'Product 8', price: 20.49, measurement: 28),
// //     Product(name: 'Product 9', price: 15.79, measurement: 9),
// //     Product(name: 'Product 10', price: 10.99, measurement: 10),
// //     Product(name: 'Product 11', price: 20.49, measurement: 16),
// //     Product(name: 'Product 12', price: 15.79, measurement: 1),
// //     Product(name: 'Product 13', price: 10.99, measurement: 7),
// //     Product(name: 'Product 14', price: 20.49, measurement: 12),
// //     Product(name: 'Product 15', price: 15.79, measurement: 19),
// //   ];
// // }

// // void addDataToFirebase(List<Product> products) {
// //   CollectionReference reference = FirebaseFirestore.instance.collection('products');

// //   products.forEach((product) {
// //    reference.add(product.toMap()).then((value) {
// //       print('Product added with ID: ${value.id}');
// //     }).catchError((error) {
// //       print('Failed to add product: $error');
// //     });
// //   });
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Product List Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: ProductListPage(),
// //     );
// //   }
// // }

// class Product {
//   final String name;
//   final double price;
//   final double measurement;

//   Product({required this.name, required this.price, required this.measurement});

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'measurement': measurement,
//     };
//   }
// }

// // class ProductListPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Product List'),
// //       ),
// //       body: StreamBuilder<QuerySnapshot>(
// //         stream: FirebaseFirestore.instance.collection('products').snapshots(),
// //         builder: (context, snapshot) {
// //           if (snapshot.hasError) {
// //             return Center(
// //               child: Text('Error: ${snapshot.error}'),
// //             );
// //           }

// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return Center(
// //               child: CircularProgressIndicator(),
// //             );
// //           }

// //           List<Product> products = snapshot.data!.docs.map((doc) {
// //             return Product(
// //               name: doc['name'],
// //               price: doc['price'].toDouble(),
// //               measurement: doc['measurement'].toDouble(),
// //             );
// //           }).toList();

// //           return ListView.builder(
// //             itemCount: products.length,
// //             itemBuilder: (context, index) {
// //               Product product = products[index];
// //               return ListTile(
// //                 title: Text(product.name),
// //                 subtitle: Text('Price: \$${product.price.toStringAsFixed(2)}'),
// //                 trailing: Text('${product.measurement}'),
// //               );
// //             },
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// void addDummyDataToFirebase() {
//   List<Product> dummyProducts = generateDummyData();

//   CollectionReference reference = FirebaseFirestore.instance.collection('products');

//   dummyProducts.forEach((product) {
//     reference.add(product.toMap()).then((value) {
//       print('Product added with ID: ${value.id}');
//     }).catchError((error) {
//       print('Failed to add product: $error');
//     });
//   });
// }

// List<Product> generateDummyData() {
//   return [
//     Product(name: 'Product 1', price: 10.99, measurement: 12),
//     Product(name: 'Product 2', price: 20.49, measurement: 21),
//     Product(name: 'Product 3', price: 15.79, measurement: 34),
//     Product(name: 'Product 4', price: 10.99, measurement: 43),
//     Product(name: 'Product 5', price: 20.49, measurement: 5),
//     Product(name: 'Product 6', price: 15.79, measurement: 6),
//     Product(name: 'Product 7', price: 10.99, measurement: 17),
//     Product(name: 'Product 8', price: 20.49, measurement: 28),
//     Product(name: 'Product 9', price: 15.79, measurement: 9),
//     Product(name: 'Product 10', price: 10.99, measurement: 10),
//     Product(name: 'Product 11', price: 20.49, measurement: 16),
//     Product(name: 'Product 12', price: 15.79, measurement: 1),
//     Product(name: 'Product 13', price: 10.99, measurement: 7),
//     Product(name: 'Product 14', price: 20.49, measurement: 12),
//     Product(name: 'Product 15', price: 15.79, measurement: 19),
//   ];
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String name;
  final double price;
  final double measurement;

  Product({required this.name, required this.price, required this.measurement});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'measurement': measurement,
    };
  }
}

void addDummyDataToFirebase() {
  List<Product> dummyProducts = generateDummyData();

  CollectionReference reference = FirebaseFirestore.instance.collection('products');

  dummyProducts.forEach((product) {
    reference.add(product.toMap()).then((value) {
      print('Product added with ID: ${value.id}');
    }).catchError((error) {
      print('Failed to add product: $error');
    });
  });
}

List<Product> generateDummyData() {
  return [
    Product(name: 'Product 1', price: 10.99, measurement: 12),
    Product(name: 'Product 2', price: 20.49, measurement: 21),
    Product(name: 'Product 3', price: 15.79, measurement: 34),
    Product(name: 'Product 4', price: 10.99, measurement: 43),
    Product(name: 'Product 5', price: 20.49, measurement: 5),
    Product(name: 'Product 6', price: 15.79, measurement: 6),
    Product(name: 'Product 7', price: 10.99, measurement: 17),
    Product(name: 'Product 8', price: 20.49, measurement: 28),
    Product(name: 'Product 9', price: 15.79, measurement: 9),
    Product(name: 'Product 10', price: 10.99, measurement: 10),
    Product(name: 'Product 11', price: 20.49, measurement: 16),
    Product(name: 'Product 12', price: 15.79, measurement: 1),
    Product(name: 'Product 13', price: 10.99, measurement: 7),
    Product(name: 'Product 14', price: 20.49, measurement: 12),
    Product(name: 'Product 15', price: 15.79, measurement: 19),
  ];
}