import 'package:colon_app/features/tumor_marker/presentation/views/widgets/tumor_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../../controllers/menu_app_controller.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../responsive.dart';

class TumorMarkerViewBody extends StatefulWidget {
  const TumorMarkerViewBody({Key? key}) : super(key: key);

  @override
  State<TumorMarkerViewBody> createState() => _TumorMarkerViewBodyState();
}

class _TumorMarkerViewBodyState extends State<TumorMarkerViewBody> {
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
              "Tumor Marker",
              style: Styles.textStyle20.copyWith(color: kTextColor),
            ),
          ],
        ),
      ),
      body: const TumorDetails(),
    );
  }
}
