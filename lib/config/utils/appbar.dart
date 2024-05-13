import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/auth_services.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  AuthServices _authServices = AuthServices();
  return AppBar(
    title: const Text(
      'Flyin',
      style: TextStyle(
          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600),
    ),
    backgroundColor: Colors.transparent,
    actions: [
      Padding(
        padding: EdgeInsets.all(12.0),
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      Padding(
          padding: EdgeInsets.all(12.0),
          child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                              'Are you sure you want to logout?',
                              style: TextStyle(color: Colors.white)),
                          backgroundColor: scaffoldbg,
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                },
                                child: const Text('No')),
                            TextButton(
                                onPressed: () {
                                  _authServices.signOut(context);
                                },
                                child: const Text('Yes'))
                          ],
                        ));
              },
              icon: Icon(Icons.logout, color: Colors.white)))
    ],
  );
}
