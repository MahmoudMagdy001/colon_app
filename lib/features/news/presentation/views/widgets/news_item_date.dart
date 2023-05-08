import 'package:flutter/material.dart';

import '../../../../../core/utlis/styles.dart';

class NewsItemDate extends StatelessWidget {
  const NewsItemDate({super.key, required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: Text(
        date,
        style: Styles.textStyle15
            .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
