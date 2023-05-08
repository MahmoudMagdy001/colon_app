import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../core/utlis/styles.dart';

class SecondText extends StatelessWidget {
  const SecondText({
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
          const Text('Storage your Medical Records',
              textAlign: TextAlign.center, style: Styles.textStyle30),
          20.ph,
          const Opacity(
            opacity: 0.5,
            child: Text('Save your records and use it anytime',
                textAlign: TextAlign.center, style: Styles.textStyle20),
          ),
        ],
      ),
    );
  }
}
