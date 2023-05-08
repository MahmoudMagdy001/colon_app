import 'package:colon_app/core/utlis/styles.dart';
import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_text_form_field.dart';

class Fields extends StatefulWidget {
  const Fields(
      {super.key,
      required this.oneController,
      required this.twoController,
      required this.threeController,
      required this.fourController,
      required this.fiveController});

  final TextEditingController oneController;
  final TextEditingController twoController;
  final TextEditingController threeController;
  final TextEditingController fourController;
  final TextEditingController fiveController;

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  bool result1 = false;
  bool result2 = false;
  bool result3 = false;
  bool result4 = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          onChanged: (value) {
            setState(() {
              result1 = (double.tryParse(value)! > 5);
            });
          },
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: widget.oneController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.numbers_rounded,
          text: 'CEA',
          obscureText: false,
          suffixText: 'IU/ml',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please entre CEA';
            }
            return null;
          },
        ),
        10.ph,
        result1 == true
            ? const Text(
                'Not Normal',
                style: Styles.textStyle15,
              )
            : const Text(
                'Normal',
                style: Styles.textStyle15,
              ),
        10.ph,
        CustomTextFormField(
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: widget.twoController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.numbers_rounded,
          text: 'CA19-9',
          obscureText: false,
          suffixText: 'IU/ml',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please entre CA19-9';
            }
            return null;
          },
        ),
        10.ph,
        CustomTextFormField(
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: widget.threeController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.numbers_rounded,
          onChanged: (value) {
            setState(() {
              result2 = double.tryParse(value)! > 25;
            });
          },
          text: 'CA50',
          obscureText: false,
          suffixText: 'IU/ml',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please entre CA50';
            }
            return null;
          },
        ),
        10.ph,
        result2 == true
            ? const Text(
                'Not Normal',
                style: Styles.textStyle15,
              )
            : const Text(
                'Normal',
                style: Styles.textStyle15,
              ),
        10.ph,
        CustomTextFormField(
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: widget.fourController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.numbers_rounded,
          text: 'CA24-2',
          obscureText: false,
          onChanged: (value) {
            setState(() {
              result3 = double.tryParse(value)! > 20;
            });
          },
          suffixText: 'IU/ml',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please entre CA24-2';
            }
            return null;
          },
        ),
        10.ph,
        result3 == true
            ? const Text(
                'Not Normal',
                style: Styles.textStyle15,
              )
            : const Text(
                'Normal',
                style: Styles.textStyle15,
              ),
        10.ph,
        CustomTextFormField(
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: widget.fiveController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.numbers_rounded,
          text: 'AFP',
          obscureText: false,
          onChanged: (value) {
            setState(() {
              result4 = double.tryParse(value)! > 15;
            });
          },
          suffixText: 'IU/ml',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please entre AFP';
            }
            return null;
          },
        ),
        10.ph,
        if (result4 == true)
          const Text(
            'Not Normal',
            style: Styles.textStyle15,
          )
        else
          const Text(
            'Normal',
            style: Styles.textStyle15,
          ),
        10.ph,
      ],
    );
  }
}
