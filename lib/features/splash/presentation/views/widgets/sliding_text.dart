import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';

class SlidingText extends StatelessWidget {
  const SlidingText({
    super.key,
    required this.slidingAnimation,
  });

  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slidingAnimation,
      builder: (context, _) {
        return SlideTransition(
          position: slidingAnimation,
          child: Text(
            'Colon Cancer Diagnosis',
            style: Styles.textStyle25.copyWith(color: kTextColor),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
