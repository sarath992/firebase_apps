import 'package:auth_firebase_application/common_widgets/common_widgets.dart';
import 'package:auth_firebase_application/pages/product_list.dart';
import 'package:auth_firebase_application/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_firebase_application/authentication/pin_login_authentication.dart'; // Import your AuthBloc_Pin

class Pingen extends StatefulWidget {
  const Pingen({Key? key});

  @override
  State<Pingen> createState() => _PingenState();
}

class _PingenState extends State<Pingen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final UserRepository _userRepository = UserRepository();

  bool _isNewUser = true;
  void initState() {
    super.initState();
    // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('MPIN-Setup/Login'),
      body: BlocConsumer<AuthBloc_Pin, AuthStatus_Pin>(
        listener: (context, state) {
          if (state == AuthStatus_Pin.pinAuthenticated) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (ctx) => ProductListPage()));
          } else {}
        },
        builder: (context, state) {
          if (state == AuthStatus_Pin.unauthenticated) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "PIN-Login",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    if (_isNewUser) ...[
                      CommonWidgets.buildTextFormField(
                          controller: _emailController,
                          labelText: 'E-mail',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter the mail-id';
                            }
                            return null;
                          }),
                      CommonWidgets.buildSizedBox(height: 20.0),
                      CommonWidgets.buildTextField(
                        controller: _pinController,
                        labelText: 'Create PIN',
                      ),
                      CommonWidgets.buildSizedBox(height: 20.0),
                      CommonWidgets.buildElevatedButton(
                          onPressed: () {
                            final pin = _pinController.text;
                            final email = _emailController.text;
                            if (pin.isNotEmpty) {
                              _userRepository.savePin(email, pin);
                              setState(() {
                                _isNewUser = false;
                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ProductListPage()));
                            }
                          },
                          text: 'Create PIN'),
                      CommonWidgets.buildSizedBox(height: 20.0),
                      CommonWidgets.buildTextButton(
                          onPressed: () {
                            setState(() {
                              _isNewUser = false;
                            });
                          },
                          text: 'Already have a PIN? Sign in'),
                    ] else ...[
                      CommonWidgets.buildTextFormField(
                          controller: _emailController,
                          labelText: 'E-mail',
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter the mail-id';
                            }
                            return null;
                          }),
                      CommonWidgets.buildSizedBox(height: 20.0),
                      CommonWidgets.buildTextField(
                        controller: _pinController,
                        labelText: 'Enter your PIN',
                      ),
                      CommonWidgets.buildSizedBox(height: 20.0),
                      CommonWidgets.buildElevatedButton(
                          onPressed: () async {
                            final pin = _pinController.text;
                            final email = _emailController.text;
                            final isPinValid =
                                await _userRepository.verifyPin(email, pin);
                            if (isPinValid) {
                              BlocProvider.of<AuthBloc_Pin>(context)
                                  .add(SignInWithPin(email: email, pin: pin));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ProductListPage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Pin for the registered mail id doesnot match")));
                            }
                          },
                          text: 'Submit'),
                      CommonWidgets.buildSizedBox(height: 20.0),
                      CommonWidgets.buildTextButton(
                          onPressed: () {
                            setState(() {
                              _isNewUser = true;
                            });
                          },
                          text: 'Create a new PIN'),
                    ],
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
