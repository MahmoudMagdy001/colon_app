import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../../controllers/menu_app_controller.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../responsive.dart';
import 'news_list_view.dart';

class NewsViewBody extends StatelessWidget {
  const NewsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kTextColor,
        title: Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: context.read<MenuAppController>().controlMenu,
              ),
            // if (!Responsive.isMobile(context))
            Text(
              "News",
              style: Styles.textStyle20.copyWith(color: kTextColor),
            ),
          ],
        ),
      ),
      body: const NewsListView(),
    );
  }
}
