import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../core/widgets/custom_button.dart';

class GeneAction extends StatelessWidget {
  const GeneAction({
    super.key,
    required this.geneController,
    required this.formkey,
  });

  final TextEditingController geneController;
  final GlobalKey<FormState> formkey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            backgroundColor: Colors.red,
            textColor: Colors.white,
            text: 'Reset'.toUpperCase(),
            onPressed: () {
              geneController.clear();
            },
          ),
        ),
        10.pw,
        Expanded(
          child: CustomButton(
            backgroundColor: kButtonColor,
            textColor: Colors.white,
            text: 'Submit'.toUpperCase(),
            onPressed: () {
              if (formkey.currentState!.validate()) {}
            },
          ),
        ),
      ],
    );
  }
}
