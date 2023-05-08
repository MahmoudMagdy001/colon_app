// ignore_for_file: use_build_context_synchronously

import 'package:colon_app/core/utlis/app_router.dart';
import 'package:colon_app/features/forum/presentation/manager/cubit/patient_cubit.dart';
import 'package:colon_app/features/forum/presentation/manager/cubit/patient_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../constants.dart';
import '../../../../../core/widgets/custom_button.dart';

class ForumAction extends StatelessWidget {
  const ForumAction({
    super.key,
    required this.formkey,
    required this.nameController,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.isSelected,
    required bool firstRadioValue,
  }) : _firstRadioValue = firstRadioValue;

  final GlobalKey<FormState> formkey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final bool isSelected;
  final bool _firstRadioValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<PatientCubit, PatientState>(
        builder: (context, state) {
          return CustomButton(
            backgroundColor: kButtonColor,
            textColor: Colors.white,
            text: 'Submit'.toUpperCase(),
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                await BlocProvider.of<PatientCubit>(context).addPatient(
                  nameController.text.trim(),
                  ageController.text.trim(),
                  int.parse(heightController.text),
                  int.parse(weightController.text),
                  isSelected,
                  _firstRadioValue,
                );
                GoRouter.of(context).go(AppRouter.kRecordsView);
                clearTexts();
              }
            },
          );
        },
      ),
    );
  }

  void clearTexts() {
    nameController.clear();
    ageController.clear();
    heightController.clear();
    weightController.clear();
  }
}
