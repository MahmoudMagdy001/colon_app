// ignore_for_file: avoid_print

import 'package:colon_app/constants.dart';
import 'package:colon_app/core/utlis/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../controllers/menu_app_controller.dart';
import '../../../../../responsive.dart';
import 'endoscopy_details.dart';

class EndoscopyViewBody extends StatelessWidget {
  const EndoscopyViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (!Responsive.isDesktop(context))
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: context.read<MenuAppController>().controlMenu,
              ),
            // if (!Responsive.isMobile(context))
            Text(
              "Endoscopy",
              style: Styles.textStyle20.copyWith(color: kTextColor),
            ),
          ],
        ),
      ),
      body: const EndoscopyDetails(),
    );
  }
}
