// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapptute/components/chat_bubble.dart';
import 'package:chatapptute/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/auth/AuthService.dart';
import '../services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatService chatService = ChatService();

  AuthService authService = AuthService();

  String receiverId = "";

  final TextEditingController messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          Duration(milliseconds: 500),
          () {
            scrollDown();
          },
        );
      }
    });

    Future.delayed(
      Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
  }

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      chatService.sendMessage(receiverId, messageController.text);
      messageController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    receiverId = arguments['receiverId'];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(arguments['email']),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          /* all messages */

          Expanded(child: _buildMessageList()),
          _buildSendMessageUi()

          /* user input */
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(receiverId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error occured ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive();
        }
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map<Widget>((doc) {
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot snapshot) {
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    final isMyMessage = data['senderId'] == chatService.getCurrentUser().uid;

    final alignment =
        isMyMessage ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubble(isMyMessage: isMyMessage, message: data['message'])
        ],
      ),
    );
  }

  Widget _buildSendMessageUi() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                  focusNode: myFocusNode,
                  hintText: "Enter message...",
                  controller: messageController)),
          Container(
              decoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: IconButton(
                  onPressed: sendMessage,
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}
