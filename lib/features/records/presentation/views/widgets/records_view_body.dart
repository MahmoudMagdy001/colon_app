import 'package:colon_app/features/records/presentation/views/widgets/search_record.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../../controllers/menu_app_controller.dart';
import '../../../../../core/utlis/app_router.dart';
import '../../../../../core/utlis/assets.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../responsive.dart';
import 'records_list_view.dart';

class RecordsViewBody extends StatelessWidget {
  const RecordsViewBody({super.key});

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
            Text(
              'Records',
              style: Styles.textStyle20.copyWith(color: kTextColor),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PatientsList()));
              },
              icon: Image.asset(AssetsData.search,
                  height: 28, width: 30, color: kButtonColor),
            ),
          ],
        ),
      ),
      body: const RecordsListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kButtonColor,
        child: const Icon(Icons.add),
        onPressed: () {
          GoRouter.of(context).go(AppRouter.kForumView);
        },
      ),
    );
  }
}
