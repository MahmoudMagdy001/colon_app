import 'package:flutter/material.dart';

import '../utlis/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    required this.textColor,
    this.borderRadius,
    this.fontSize,
  });
  final Color? backgroundColor;
  final Color textColor;
  final BorderRadius? borderRadius;
  final String text;
  final double? fontSize;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: Styles.textStyle18.copyWith(
          fontSize: 17,
          color: textColor,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
