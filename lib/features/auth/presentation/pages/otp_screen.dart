import 'package:blackcoffer_test_assignment/config/theme/colors.dart';
import 'package:blackcoffer_test_assignment/features/auth/data/data_sources/auth_services.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/black_button.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/login_textfield.dart';
import 'package:blackcoffer_test_assignment/features/auth/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OTPScreen extends StatefulWidget {
  static const String routeName = '/otp';
  const OTPScreen({super.key, required this.verificationId});
  final String verificationId;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  AuthServices authServices = AuthServices();
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldbg,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Logo(),
                SizedBox(
                  height: 50,
                ),
                LoginTextField(
                  keyboardType: TextInputType.number,
                  phoneController: otpController,
                  hintText: "Enter OTP",
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Did not get OTP?  ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                    Text('Resend OTP',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                BlackButton(
                    child: Text(
                      "Get Started",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      authServices.otpVerification(
                          context, widget.verificationId, otpController.text);
                    }),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.7,
                      MediaQuery.of(context).size.height * 0.2,
                      0,
                      0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        Text(
                          'Back',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
