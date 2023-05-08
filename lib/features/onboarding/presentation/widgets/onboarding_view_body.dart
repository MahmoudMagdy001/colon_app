import 'package:colon_app/features/onboarding/presentation/widgets/second_image.dart';
import 'package:colon_app/features/onboarding/presentation/widgets/second_text.dart';
import 'package:colon_app/features/onboarding/presentation/widgets/third_image.dart';
import 'package:colon_app/features/onboarding/presentation/widgets/third_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants.dart';
import '../../../../core/utlis/app_router.dart';
import '../../../../core/utlis/styles.dart';
import 'first_image.dart';
import 'first_text.dart';

class OnboardingViewBody extends StatelessWidget {
  const OnboardingViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        finishButtonText: 'LOGIN',
        onFinish: () {
          GoRouter.of(context).go(AppRouter.kAuthView);
        },
        finishButtonTextStyle: Styles.textStyle20.copyWith(color: Colors.white),
        skipTextButton: Text(
          'SKIP',
          style: Styles.textStyle18.copyWith(color: kTextColor),
        ),
        trailing: Text(
          'CREATE AN ACCOUNT',
          style: Styles.textStyle18.copyWith(color: kButtonColor),
        ),
        trailingFunction: () {
          GoRouter.of(context).go(AppRouter.kSignpScreen);
        },
        controllerColor: kButtonColor,
        totalPage: 3,
        headerBackgroundColor: kPrimaryColor,
        pageBackgroundColor: kPrimaryColor,
        background: const [
          FirstImage(),
          SecondImage(),
          ThirdImage(),
        ],
        speed: 1.2,
        pageBodies: const [
          FirstText(),
          SecondText(),
          ThirdText(),
        ],
      ),
    );
  }
}
