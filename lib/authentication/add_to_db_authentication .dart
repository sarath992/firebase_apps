import 'package:auth_firebase_application/model/dummy_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class AddProductToFirestore extends ProductDetailsEvent {
  final Product product;

  const AddProductToFirestore(this.product);

  @override
  List<Object> get props => [product];
}

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsSuccess extends ProductDetailsState {}

class ProductDetailsFailure extends ProductDetailsState {
  final String error;

  const ProductDetailsFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsInitial()) {
    on<AddProductToFirestore>(_onAddProductToFirestore);
  }

  void _onAddProductToFirestore(
    AddProductToFirestore event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userEmail = user.email ?? '';
        Map<String, dynamic> productData = {
          'user': userEmail,
          'productName': event.product.name,
        };
        await FirebaseFirestore.instance
            .collection('user-products')
            .add(productData);
        emit(ProductDetailsSuccess());
      } else {
        emit(ProductDetailsFailure('User not logged in'));
      }
    } catch (error) {
      emit(ProductDetailsFailure('Failed to add product: $error'));
    }
  }
}
