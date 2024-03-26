import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase_application/model/dummy_data.dart';

abstract class ProductListEvent {}

class LoadProducts extends ProductListEvent {}

class SearchProducts extends ProductListEvent {
  final String searchText;

  SearchProducts(this.searchText);
}

abstract class ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;

  ProductListLoaded(this.products);
}

class ProductListError extends ProductListState {
  final String error;

  ProductListError(this.error);
}

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final FirebaseFirestore firestore;

  ProductListBloc({required this.firestore}) : super(ProductListLoading()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
  }

  void _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    try {
      QuerySnapshot querySnapshot = await firestore.collection('products').get();
      final List<Product> products = querySnapshot.docs.map((doc) {
        return Product(
          name: doc['name'],
          price: doc['price'].toDouble(),
          measurement: doc['measurement'].toDouble(),
        );
      }).toList();
      emit(ProductListLoaded(products));
    } catch (e) {
      emit(ProductListError('Failed to load products: $e'));
    }
  }

  void _onSearchProducts(
    SearchProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());
    try {
      QuerySnapshot querySnapshot = await firestore.collection('products').where('name', isGreaterThanOrEqualTo: event.searchText).get();
      final List<Product> products = querySnapshot.docs.map((doc) {
        return Product(
          name: doc['name'],
          price: doc['price'].toDouble(),
          measurement: doc['measurement'].toDouble(),
        );
      }).toList();
      emit(ProductListLoaded(products));
    } catch (e) {
      emit(ProductListError('Failed to search products: $e'));
    }
  }
}
