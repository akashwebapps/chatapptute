// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapptute/routes/Routes.dart';
import 'package:chatapptute/services/profile/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/auth/AuthService.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  void logout() {
    AuthService service = AuthService();
    service.signOut();
  }

  ProfileService _profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              StreamBuilder(
                stream: _profileService.getUserData(),
                builder: (context, snapshot) {
                  String? imageLink = snapshot.data?['imageLink'];
                  return DrawerHeader(
                      child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 1)),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageLink == null || imageLink.isEmpty
                          ? null
                          : NetworkImage(imageLink),
                      child: imageLink == null || imageLink.isEmpty
                          ? Icon(Icons.person)
                          : null,
                    ),
                  ));
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text("H O M E"),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("S E T T I N G S"),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.settingsScreen);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("M Y  P R O F I L E"),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.profile);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("L O G O U T"),
                  onTap: logout,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
