import 'package:flutter/material.dart';

import '../../../../core/utlis/assets.dart';

class FirstImage extends StatelessWidget {
  const FirstImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AssetsData.first,
        scale: 0.65,
        fit: BoxFit.cover,
      ),
    );
  }
}
