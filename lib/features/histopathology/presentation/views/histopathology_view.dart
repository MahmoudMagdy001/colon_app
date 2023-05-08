import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../controllers/menu_app_controller.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../../../../responsive.dart';
import 'widgets/histopathology_view_body.dart';

class HistopathologyView extends StatelessWidget {
  const HistopathologyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MenuAppController(),
      child: Consumer<MenuAppController>(
        builder: (context, menuController, _) => Scaffold(
          key: menuController.scaffoldKey,
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
                  child: HistopathologyViewBody(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
