import 'package:colon_app/core/utlis/app_router.dart';
import 'package:colon_app/features/patient_tracking/presentation/views/widgets/patient_tracking_details.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../../controllers/menu_app_controller.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../responsive.dart';

class PatientTrackingViewBody extends StatefulWidget {
  const PatientTrackingViewBody({super.key});

  @override
  State<PatientTrackingViewBody> createState() =>
      _PatientTrackingViewBodyState();
}

class _PatientTrackingViewBodyState extends State<PatientTrackingViewBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: kButtonColor,
          onPressed: () {
            GoRouter.of(context).go(AppRouter.kAddPatientTrachingView);
          },
          child: const Icon(Icons.add)),
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
              "Patient Tracking",
              style: Styles.textStyle20.copyWith(color: kTextColor),
            ),
          ],
        ),
      ),
      body: const PatientTrackingDetails(),
    );
  }
}
