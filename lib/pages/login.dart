import 'package:auth_firebase_application/authentication/login_authentication.dart';
import 'package:auth_firebase_application/authentication/pin_login_authentication.dart';
import 'package:auth_firebase_application/authentication/signup_authentication.dart';
import 'package:auth_firebase_application/common_widgets/common_widgets.dart';
import 'package:auth_firebase_application/pages/pin_login.dart';
import 'package:auth_firebase_application/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  bool obscureText = true;

  void _passwordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  void initState() {
    super.initState();
    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: CommonWidgets.buildAppBar('Login'),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is Authenticated) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider(
                create: (context) => AuthBloc_Pin(),
                child: Pingen(),
              ),
            ));
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              CommonWidgets.buildSizedBox(height: 20.0),
              CommonWidgets.buildTextFormField(
                controller: _emailController,
                labelText: 'E-Mail',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your e-mail address';
                  }
                  return null;
                },
              ),
              CommonWidgets.buildSizedBox(height: 20.0),
              CommonWidgets.buildTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the password';
                    }
                    return null;
                  },
                  obscureText: obscureText,
                  suffixIcon: IconButton(
                      onPressed: _passwordVisibility,
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ))),
              CommonWidgets.buildSizedBox(height: 20.0),
              CommonWidgets.buildElevatedButton(
                  onPressed: () {
                    authBloc.add(LoginWithEmailPasswordEvent(
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    ));
                  },
                  text: "Login"),
              CommonWidgets.buildSizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CommonWidgets.buildTextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => BlocProvider(
                          create: (context) => AuthBloc_signup(),
                          child: SignInRegisterPage(),
                        ),
                      ));
                    },
                    text: "Don't have an account?",
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
