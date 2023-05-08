import 'package:flutter/material.dart';

import '../../../../core/utlis/assets.dart';

class ThirdImage extends StatelessWidget {
  const ThirdImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsData.third,
      fit: BoxFit.fitWidth,
      height: 400,
    );
  }
}
