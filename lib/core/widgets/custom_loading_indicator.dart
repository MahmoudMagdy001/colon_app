import 'package:flutter/material.dart';

import '../../constants.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            color: kButtonColor,
            strokeWidth: 13.0,
          ),
        ],
      ),
    );
  }
}
