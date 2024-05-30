// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MyTextField extends StatelessWidget {
  String hintText;
  bool obscureText;
  TextEditingController controller;
  FocusNode? focusNode;
  bool isEnabled;

  MyTextField(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      required this.controller,
      this.focusNode,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
          enabled: isEnabled,
          focusNode: focusNode,
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
              fillColor: Theme.of(context).colorScheme.secondary,
              filled: true,
              hintText: hintText,
              hintStyle:
                  TextStyle(color: Theme.of(context).colorScheme.primary))),
    );
  }
}
