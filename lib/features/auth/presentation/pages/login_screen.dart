import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/config/utils/appbar.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/auth_services.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/pages/otp_screen.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/black_button.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/login_textfield.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();
  AuthServices _authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldbg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Logo(),
                  const SizedBox(
                    height: 50,
                  ),
                  LoginTextField(
                    keyboardType: TextInputType.phone,
                    phoneController: phoneController,
                    hintText: 'Enter your mobile number',
                    prefixText: '+91',
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  BlackButton(
                    onPressed: () {
                      _authServices.verifyPhoneNumber(
                          context, phoneController.text);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
