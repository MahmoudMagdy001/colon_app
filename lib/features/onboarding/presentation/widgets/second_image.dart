import 'package:flutter/material.dart';

import '../../../../core/utlis/assets.dart';

class SecondImage extends StatelessWidget {
  const SecondImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AssetsData.second,
      fit: BoxFit.fitWidth,
      height: 450,
    );
  }
}
