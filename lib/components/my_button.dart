import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  String buttonName;
  void Function() onTapp;

  MyButton({super.key, required this.buttonName, required this.onTapp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapp,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(18),
        margin: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.secondary),
        child: Text(
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          buttonName,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
