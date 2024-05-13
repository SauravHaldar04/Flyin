import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  const BlackButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.height,
    this.width,
  });
  final Widget child;
  final VoidCallback onPressed;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          fixedSize: (width == null)
              ? (height == null)
                  ? Size(double.infinity, 70)
                  : Size(width!, height!)
              : Size(width!, 70)),
    );
  }
}
