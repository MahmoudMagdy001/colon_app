import 'package:colon_app/core/utlis/app_router.dart';
import 'package:colon_app/features/forum/presentation/views/widgets/forum_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';

class ForumViewBody extends StatelessWidget {
  const ForumViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                GoRouter.of(context).go(AppRouter.kRecordsView);
              },
            ),
            Text(
              "Forum",
              style: Styles.textStyle20.copyWith(color: kTextColor),
            ),
          ],
        ),
      ),
      body: const ForumSection(),
    );
  }
}
