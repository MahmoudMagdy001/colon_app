import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

class CustomGenderButton extends StatelessWidget {
  const CustomGenderButton({
    super.key,
    required this.text,
    required this.icon,
    required this.ontap,
    this.color,
    this.textStyle,
    this.iconColor,
  });

  final String text;
  final IconData icon;
  final void Function() ontap;
  final Color? color;
  final TextStyle? textStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: ontap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 55.0, color: iconColor),
            5.ph,
            Text(text, style: textStyle),
            5.ph,
          ],
        ),
      ),
    );
  }
}
