import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/config/theme/routes.dart';
import 'package:blackcoffer_test_assignment/config/utils/bottom_bar.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/pages/login_screen.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/pages/signup_screen.dart';
import 'package:blackcoffer_test_assignment/features/home/presentation/pages/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserSignedUp = false;
  getUserStatus() async {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      final users = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (users.exists) {
        setState(() {
          isUserSignedUp = true;
        });
      } else {
        setState(() {
          isUserSignedUp = false;
        });
      }
    }
  }

  @override
  void initState() {
    getUserStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return MaterialApp(
      title: 'Flyin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: auth.currentUser != null
          ? isUserSignedUp
              ? const BottomBar()
              : SignUpScreen()
          : LoginScreen(),
      onGenerateRoute: ((settings) => generateRoute(settings)),
    );
  }
}
