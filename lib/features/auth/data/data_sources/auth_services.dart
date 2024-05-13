import 'dart:typed_data';

import 'package:blackcoffer_test_assignment/config/utils/utils.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/storage_methods.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/pages/otp_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/models/user_model.dart'
    as model;

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> verifyPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    String? verificationId1;
    await _auth.verifyPhoneNumber(
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException ex) {
          print(ex.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ex.toString(),
              ),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationId1 = verificationId;
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        phoneNumber: '+91$phoneNumber');
    return verificationId1!;
  }

  otpVerification(
    BuildContext context,
    String verificationId,
    String otp,
  ) async {
    try {
      PhoneAuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      await _auth.signInWithCredential(credential).then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/bottombar', (route) => false);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  createUserProfile(BuildContext context, String username,
      Uint8List profilepicfile, String email) async {
    try {
      if (username.isEmpty || profilepicfile.isEmpty || email.isEmpty) {
        showSnackBar(context, 'Please fill all the fields');
        return;
      } else {
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: username)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          showSnackBar(context,
              'Username already exists. Please choose a different username.');
          return;
        } else {
          String profilepic = await StorageMethods()
              .uploadItem('profilepics', profilepicfile, false);
          model.User user = model.User(
            uid: _auth.currentUser!.uid,
            email: email,
            username: username,
            profilepic: profilepic,
          );
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .set(user.toJson())
              .then((value) {
            showSnackBar(context, 'Profile Created Successfully!');
            Navigator.pushNamedAndRemoveUntil(
                context, '/bottombar', (route) => false);
          });
        }
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  signOut(BuildContext context) async {
    try {
      await _auth.signOut().then((value) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    print(currentUser.email);
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    // print((snap.data() as Map<String, dynamic>)['username'] as String);

    return model.User.fromSnap(snap);
  }
}
