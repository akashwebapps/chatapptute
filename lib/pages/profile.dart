// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:io';

import 'package:chatapptute/components/my_button.dart';
import 'package:chatapptute/components/my_text_field.dart';
import 'package:chatapptute/helper/logger.dart';
import 'package:chatapptute/models/ProfileModel.dart';
import 'package:chatapptute/services/auth/AuthService.dart';
import 'package:chatapptute/services/profile/profile_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class MyProfile extends StatelessWidget {
  MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("My Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ProfileStream(),
    );
  }
}

class ProfileStream extends StatefulWidget {
  const ProfileStream({super.key});

  @override
  State<ProfileStream> createState() => _ProfileStreamState();
}

class _ProfileStreamState extends State<ProfileStream> {
  ProfileService _profileService = ProfileService();
  AuthService _authService = AuthService();

  String _gender = '';
  String? imagePath;
  bool isLoading = false;

  // Default selected value
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _aboutUsController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  void handleRadioButtonValueChange(String? value) {
    setState(() {
      _gender = value!;
    });
  }

  void updateUser() {
    _profileService.createProfileData(
        ProfileModel.updateDate(
                name: _nameController.text,
                aboutYou: _aboutUsController.text,
                gender: _gender)
            .toUpdateMap(),
        isUpdate: true);
  }

  void selectGalleryImage() async {
    Navigator.pop(context);
    // Pick singe image or video.
    final XFile? media = await picker.pickMedia();

    if (media != null) {
      setState(() {
        isLoading = true;
      });
      CustomLogger.debug("path is ${media.path}");
      final storageRef = FirebaseStorage.instance.ref();

      final mountainsRef =
          storageRef.child("Users").child(_authService.getCurrentUser().uid);

      File file = File(media.path);

      try {
        mountainsRef.putFile(file).whenComplete(() => null);

        mountainsRef.getDownloadURL().then((value) {
          CustomLogger.debug("Image path is ${value}");
          _profileService
              .createProfileData({'imageLink': value}, isUpdate: true);
          setState(() {
            isLoading = false;
          });
        });
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.message ?? ''),
          ),
        );
      }
    }
  }

  void selectCameraImage() async {
    Navigator.pop(context);
    // Pick singe image or video.
    final XFile? media = await picker.pickMedia();
    CustomLogger.debug("path is ${media?.path}");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _profileService.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error occured ${snapshot.error}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive();
        }
        if (isLoading) {
          return Center(child: CupertinoActivityIndicator());
        }

        _emailController.text = snapshot.data?['email'];
        _aboutUsController.text = snapshot.data?['aboutYou'];
        _nameController.text = snapshot.data?['name'];

        // handleRadioButtonValueChange(snapshot.data?['gender'].toString());

        _gender = snapshot.data?['gender'].toString() ?? '';
        imagePath = snapshot.data?['imageLink'];

        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 115,
                    width: 115,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: imagePath != null
                              ? NetworkImage(imagePath!)
                              : null,
                          child: imagePath == null
                              ? Icon(
                                  Icons.person_2_rounded,
                                )
                              : null,
                        ),
                        Positioned(
                            bottom: 0,
                            right: -25,
                            child: RawMaterialButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Choose File Using"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        onTap: selectCameraImage,
                                        title: Text("Camera"),
                                      ),
                                      ListTile(
                                        onTap: selectGalleryImage,
                                        title: Text("Gallery"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              elevation: 2.0,
                              fillColor: Color(0xFFF5F6F9),
                              padding: EdgeInsets.all(15.0),
                              shape: CircleBorder(),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.blue,
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  MyTextField(
                      hintText: "Please enter name",
                      controller: _nameController),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    hintText: "Please enter email",
                    controller: _emailController,
                    isEnabled: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                      hintText: "About you...", controller: _aboutUsController),
                  ListTile(
                    leading: Radio(
                        value: "M",
                        groupValue: _gender,
                        onChanged: handleRadioButtonValueChange),
                    title: Text(
                      "Male",
                    ),
                  ),
                  ListTile(
                    leading: Radio(
                        value: "F",
                        groupValue: _gender,
                        onChanged: handleRadioButtonValueChange),
                    title: Text(
                      "Female",
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  MyButton(
                    buttonName: "Save",
                    onTapp: updateUser,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
