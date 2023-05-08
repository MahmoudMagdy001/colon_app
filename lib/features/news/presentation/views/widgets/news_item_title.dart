import 'package:colon_app/responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utlis/styles.dart';

class NewsItemTitle extends StatelessWidget {
  const NewsItemTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        title,
        textScaleFactor: 1.15,
        style: Styles.textStyle18
            .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
        maxLines: Responsive.isMobile(context) ? 4 : 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
