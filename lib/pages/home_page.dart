import 'package:chatapptute/components/user_tile.dart';
import 'package:chatapptute/routes/Routes.dart';
import 'package:chatapptute/services/auth/AuthService.dart';
import 'package:chatapptute/components/my_drawer.dart';
import 'package:chatapptute/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  ChatService chatService = ChatService();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: chatService.getUserStream(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error occured ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator.adaptive();
          }

          return ListView(
              children: snapshot.data!
                  .map<Widget>(
                      (userData) => _buildUserListItem(userData, context))
                  .toList());
        }));
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    return chatService.getCurrentUser().uid == userData['uid']
        ? Container()
        : MyUserTile(
            text: userData['email'],
            onTap: () {
              // tapped the user -> Navigate to chat screen
              Navigator.pushNamed(context, Routes.chatScreen, arguments: {
                'email': userData['email'],
                'receiverId': userData['uid'],
              });
            });
  }
}
