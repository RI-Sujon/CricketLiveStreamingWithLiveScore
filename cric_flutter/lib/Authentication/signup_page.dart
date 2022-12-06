import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cric_flutter/Authentication/model/Creator.dart';
import 'package:cric_flutter/Pages/home_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glutton/glutton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cric_flutter/Authentication/common/page_header.dart';
import 'package:cric_flutter/Authentication/common/page_heading.dart';
import 'package:cric_flutter/Authentication/login_page.dart';

import 'package:cric_flutter/Authentication/common/custom_form_button.dart';
import 'package:cric_flutter/Authentication/common/custom_input_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  File? _profileImage;

  final _signupFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var firebaseUser;

  Future _pickProfileImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => _profileImage = imageTemporary);
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(children: [
          const PageHeader(),
          Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _signupFormKey,
                  child: Column(
                    children: [
                      const PageHeading(
                        title: 'Sign-up',
                      ),
                      // SizedBox(
                      //   width: 130,
                      //   height: 130,
                      //   child: CircleAvatar(
                      //     backgroundColor: Colors.grey.shade200,
                      //     backgroundImage: _profileImage != null
                      //         ? FileImage(_profileImage!)
                      //         : null,
                      //     child: Stack(
                      //       children: [
                      //         Positioned(
                      //           bottom: 5,
                      //           right: 5,
                      //           child: GestureDetector(
                      //             onTap: _pickProfileImage,
                      //             child: Container(
                      //               height: 50,
                      //               width: 50,
                      //               decoration: BoxDecoration(
                      //                 color: Colors.blue.shade400,
                      //                 border: Border.all(
                      //                     color: Colors.white, width: 3),
                      //                 borderRadius: BorderRadius.circular(25),
                      //               ),
                      //               child: const Icon(
                      //                 Icons.camera_alt_sharp,
                      //                 color: Colors.white,
                      //                 size: 25,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomInputField(
                          labelText: 'Name',
                          hintText: 'Your name',
                          controller: _nameController,
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Name field is required!';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomInputField(
                          labelText: 'Email',
                          hintText: 'Your email id',
                          controller: _emailController,
                          isDense: true,
                          validator: (textValue) {
                            if (textValue == null || textValue.isEmpty) {
                              return 'Email is required!';
                            }
                            if (!EmailValidator.validate(textValue)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 16,
                      ),
                      // CustomInputField(
                      //     labelText: 'Contact no.',
                      //     hintText: 'Your contact number',
                      //     isDense: true,
                      //     validator: (textValue) {
                      //       if (textValue == null || textValue.isEmpty) {
                      //         return 'Contact number is required!';
                      //       }
                      //       return null;
                      //     }),
                      // const SizedBox(
                      //   height: 16,
                      // ),
                      CustomInputField(
                        labelText: 'Password',
                        hintText: 'Your password',
                        controller: _passwordController,
                        isDense: true,
                        obscureText: true,
                        validator: (textValue) {
                          if (textValue == null || textValue.isEmpty) {
                            return 'Password is required!';
                          }
                          return null;
                        },
                        suffixIcon: true,
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      CustomFormButton(
                        innerText: 'Signup',
                        onPressed: _handleSignupUser,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account ? ',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff939393),
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()))
                              },
                              child: const Text(
                                'Log-in',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff748288),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              )),
        ]),
      ),
    );
  }

  void _handleSignupUser() {
    // signup user
    if (_signupFormKey.currentState!.validate()) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Submitting data..')),
      // );
      _sign_up();
    }
  }

  void _sign_up() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((auth) {
        firebaseUser = auth.user;
        _saveToFirebaseFirestore();
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("something wrong")),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something Wrong")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something wrong")),
      );
    }
  }

  void _saveToFirebaseFirestore() async {
    Creator creator =
        Creator(_nameController.text.trim(), _emailController.text.trim());

    await FirebaseFirestore.instance
        .collection("Creator")
        .doc(firebaseUser.uid)
        .set(creator.toJson());

    await Glutton.eat("Creator", creator.toJson());

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
