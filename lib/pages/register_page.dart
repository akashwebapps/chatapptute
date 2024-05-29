// ignore_for_file: prefer_const_constructors

import 'package:chatapptute/components/my_button.dart';
import 'package:chatapptute/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../services/auth/AuthService.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTogglePress});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  void Function()? onTogglePress;

  Future signUp(BuildContext context) async {
    try {
      AuthService service = AuthService();
      await service.signUpWithEmailPassword(
          emailController.text, passwordController.text);
      print("Login success");
    } catch (e) {
      print("Login failure $e");

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* app logo */
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              height: 50,
            ),

            /* welcome text */
            Text(
              "Let's create an account for you!",
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(
              height: 50,
            ),
            /* email and password */
            MyTextField(
              hintText: "Email",
              controller: emailController,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(
              height: 10,
            ),
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: passwordController,
            ),
            SizedBox(
              height: 25,
            ),
            MyButton(
                buttonName: "Register",
                onTapp: () {
                  signUp(context);
                }),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member?",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: onTogglePress,
                  child: Text(
                    "Register Now",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )

            /* register button */

            /* login button */
          ],
        ),
      ),
    );
  }
}
