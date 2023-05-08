import 'package:flutter/material.dart';

class CustomAppbarButton extends StatelessWidget {
  const CustomAppbarButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.color,
    this.textColor,
  });

  final IconData icon;
  final String text;
  final void Function() onTap;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color ?? Colors.black,
      ),
      title: Text(
        text,
        style: TextStyle(color: textColor),
      ),
      onTap: onTap,
    );
  }
}
