import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent {}

class LoginWithEmailPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailPasswordEvent({required this.email, required this.password});
}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated({required this.user});
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<LoginWithEmailPasswordEvent>(_onLoginWithEmailPassword);
  }

  void _onLoginWithEmailPassword(
    LoginWithEmailPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user: userCredential.user!));
    } catch (e) {
      emit(AuthError(message: 'Failed to log in: $e'));
    }
  }
}
