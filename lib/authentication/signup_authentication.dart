import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthEvent_SignUp {}

class SignUpWithEmailPasswordEvent extends AuthEvent_SignUp {
  final String username;
  final String email;
  final String password;

  SignUpWithEmailPasswordEvent({
    required this.username,
    required this.email,
    required this.password,
  });
}

// ignore: camel_case_types
abstract class AuthState_SignUp{}
class AuthInitial extends AuthState_SignUp {}

class AuthLoading extends AuthState_SignUp {}

// ignore: camel_case_types
class Authenticated_SignUp extends AuthState_SignUp {
  final User user;

  Authenticated_SignUp({required this.user});
}

class Unauthenticated extends AuthState_SignUp {}

class AuthError_SignUp extends AuthState_SignUp {
  final String message;

  AuthError_SignUp({required this.message});
}

class AuthBloc_signup extends Bloc<AuthEvent_SignUp, AuthState_SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc_signup() : super(AuthInitial()) {
    on<SignUpWithEmailPasswordEvent>(_onSignUpWithEmailPassword);
  }

  void _onSignUpWithEmailPassword(
    SignUpWithEmailPasswordEvent event,
    Emitter<AuthState_SignUp> emit,
  ) async {
    emit(AuthLoading()); // Emit loading state
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      await userCredential.user!.updateDisplayName(event.username);
      emit(Authenticated_SignUp(user: userCredential.user!)); 
    } catch (e) {
      emit(AuthError_SignUp(message: 'Failed to sign up: $e')); 
    }
  }
}
