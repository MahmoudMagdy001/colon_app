import 'package:colon_app/core/utlis/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                GoRouter.of(context).push(AppRouter.kResetPasswordrView);
              },
              child: Text(
                'Forget Your Password ?',
                style: Styles.textStyle15.copyWith(color: kButtonColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
