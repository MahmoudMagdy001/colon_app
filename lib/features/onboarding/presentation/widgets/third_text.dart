import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../core/utlis/styles.dart';

class ThirdText extends StatelessWidget {
  const ThirdText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 480,
          ),
          const Text('Discuss in the Forum',
              style: Styles.textStyle30, textAlign: TextAlign.center),
          20.ph,
          const Opacity(
            opacity: 0.5,
            child: Text(
              'know anything about patient',
              textAlign: TextAlign.center,
              style: Styles.textStyle20,
            ),
          ),
        ],
      ),
    );
  }
}
