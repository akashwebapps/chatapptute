// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chatapptute/routes/Routes.dart';
import 'package:flutter/material.dart';

import '../services/auth/AuthService.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    AuthService service = AuthService();
    service.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Icon(
                size: 40,
                Icons.message,
                color: Theme.of(context).primaryColor,
              )),
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
