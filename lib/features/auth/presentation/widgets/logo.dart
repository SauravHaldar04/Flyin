import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 120,
      backgroundImage: AssetImage('assets/images/Flyin Logo.png'),
    );
  }
}