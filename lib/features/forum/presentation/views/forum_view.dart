import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/menu_app_controller.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../responsive.dart';
import 'widgets/forum_view_body.dart';

class ForumView extends StatelessWidget {
  const ForumView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuAppController(),
      child: Consumer<MenuAppController>(
        builder: (context, menuAppController, _) {
          return Scaffold(
            key: menuAppController.scaffoldKey,
            drawer: const MyDrawer(),
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // We want this side menu only for large screen
                  if (Responsive.isDesktop(context))
                    const Expanded(
                      // default flex = 1
                      // and it takes 1/6 part of the screen
                      child: MyDrawer(),
                    ),
                  const Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    child: ForumViewBody(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
