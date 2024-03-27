import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus_Pin { authenticated, pinAuthenticated, unauthenticated }

abstract class AuthEvent_Pin {}

class SignInWithPin extends AuthEvent_Pin {
  final String email;
  final String pin;

  SignInWithPin({required this.email, required this.pin});
}

class SignInWithEmailPassword extends AuthEvent_Pin {
  final String email;
  final String password;

  SignInWithEmailPassword({required this.email, required this.password});
}

class AuthBloc_Pin extends Bloc<AuthEvent_Pin, AuthStatus_Pin> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc_Pin() : super(AuthStatus_Pin.unauthenticated) {
    on<SignInWithPin>(_signInWithPin);
  }

  void _signInWithPin(SignInWithPin event, Emitter<AuthStatus_Pin> emit) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.pin,
      );
      if (userCredential.user != null) {
        emit(AuthStatus_Pin.pinAuthenticated);
      } else {
        emit(AuthStatus_Pin.unauthenticated);
      }
    } catch (e) {
      emit(AuthStatus_Pin.unauthenticated);
    }
  }
}
