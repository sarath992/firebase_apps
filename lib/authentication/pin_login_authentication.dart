// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// enum AuthStatus_Pin { authenticated, pinAuthenticated, unauthenticated }

// abstract class AuthEvent_Pin {}

// class SignInWithPin extends AuthEvent_Pin {
//   final String email;
//   final String pin;

//   SignInWithPin({required this.email, required this.pin});
// }

// class SignInWithEmailPassword extends AuthEvent_Pin {
//   final String email;
//   final String password;

//   SignInWithEmailPassword({required this.email, required this.password});
// }

// class SignOut extends AuthEvent_Pin {}

// class AuthBloc_Pin extends Bloc<AuthEvent_Pin, AuthStatus_Pin> {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   AuthBloc_Pin() : super(AuthStatus_Pin.unauthenticated);

//   @override
//   Stream<AuthStatus_Pin> mapEventToState(AuthEvent_Pin event) async* {
//     if (event is SignInWithPin) {
//       try {
//         final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
//           email: event.email,
//           password: event.pin,
//         );
//         if (userCredential.user != null) {
//           yield AuthStatus_Pin.pinAuthenticated;
//         } else {
//           yield AuthStatus_Pin.unauthenticated;
//         }
//       } catch (e) {
//         yield AuthStatus_Pin.unauthenticated;
//       }
//     } else if (event is SignInWithEmailPassword) {
//       try {
//         // Implement your regular email/password sign-in logic here
//       } catch (e) {
//         yield AuthStatus_Pin.unauthenticated;
//       }
//     } else if (event is SignOut) {
//       // Implement sign-out logic
//       yield AuthStatus_Pin.unauthenticated;
//     }
//   }
// }
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
