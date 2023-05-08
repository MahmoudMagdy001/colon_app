import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../../controllers/menu_app_controller.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../responsive.dart';
import 'gene_expression_details.dart';


class GeneExpressionViewBody extends StatelessWidget {
  const GeneExpressionViewBody({super.key});

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
              "Gene Expression",
              style: Styles.textStyle20.copyWith(color: kTextColor),
            ),
          ],
        ),
      ),
      body: const GeneDetails(),
    );
  }
}
