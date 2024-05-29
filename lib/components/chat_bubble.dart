import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({super.key, required this.isMyMessage, required this.message});

  bool isMyMessage;
  String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isMyMessage ? Colors.green.shade900 : Colors.grey.shade600,
      ),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
