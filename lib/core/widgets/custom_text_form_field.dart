import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utlis/styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.prefixIcon,
    this.border,
    required this.text,
    this.hintText,
    this.validator,
    this.onChanged,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.suffixIcon,
    this.obscureText = false,
    this.suffixText,
    this.onSaved,
    this.onTap,
    this.onSubmitted,
  });

  final IconData prefixIcon;
  final InputBorder? border;
  final String text;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool? obscureText;
  final String? suffixText;
  final Function(String?)? onSaved;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      obscureText: obscureText!,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          label: Text(text),
          hintText: hintText),
      style: Styles.textStyle15.copyWith(
          color: Colors.black, fontWeight: FontWeight.normal, fontSize: 17),
      validator: validator,
      onChanged: onChanged,
      controller: controller,
      onSaved: onSaved,
      onFieldSubmitted: onSubmitted,
    );
  }
}
