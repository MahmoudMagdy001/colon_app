import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/app_router.dart';
import '../../../../../core/utlis/styles.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New User ?',
          style: Styles.textStyle15.copyWith(fontWeight: FontWeight.normal),
        ),
        10.pw,
        InkWell(
          child: Text('Create an Account',
              style: Styles.textStyle15.copyWith(color: kButtonColor)),
          onTap: () {
            GoRouter.of(context).push(AppRouter.kSignpScreen);
          },
        )
      ],
    );
  }
}
