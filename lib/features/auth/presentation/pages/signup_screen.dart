import 'dart:typed_data';

import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/config/utils/utils.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/auth_services.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/pages/login_screen.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/black_button.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/login_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AuthServices _authServices = AuthServices();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Uint8List? _image;

  setImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldbg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Profile Setup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Create your profile to continue',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Stack(children: [
                    _image == null
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundColor: tertiaryColor,
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: MemoryImage(_image!),
                          ),
                    Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: () {
                            setImage();
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ))
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  LoginTextField(
                      hintText: 'Username',
                      phoneController: usernameController,
                      prefixIcon: const Icon(Icons.person)),
                  const SizedBox(
                    height: 20,
                  ),
                  LoginTextField(
                      hintText: 'Email',
                      phoneController: emailController,
                      prefixIcon: const Icon(Icons.email)),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BlackButton(
                    child: Text(
                      'Create Profile',
                    ),
                    onPressed: () {
                      _authServices.createUserProfile(
                          context,
                          usernameController.text,
                          _image!,
                          emailController.text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
