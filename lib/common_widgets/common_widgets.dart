import 'package:flutter/material.dart';

class CommonWidgets {
  static AppBar buildAppBar(String title, {List<IconButton>? actions}) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue,
      automaticallyImplyLeading: false,
    );
  }

  static Widget buildTextFormField(
      {required TextEditingController controller,
      required String labelText,
      required FormFieldValidator<String> validator,
      bool obscureText = false,
      Widget? suffixIcon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validator,
      obscureText: obscureText,
    );
  }

  static Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  static Widget buildSizedBox({double height = 10.0, double width = 10.0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }

  static Widget buildTextButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  static Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    InputDecoration? decoration,
  }) {
    return TextField(
      obscureText: false,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}
