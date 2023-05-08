import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_divider.dart';
import '../../../../../core/widgets/custom_gender_button.dart';
import 'forum_action.dart';
import 'forum_details.dart';

class ForumSection extends StatefulWidget {
  const ForumSection({super.key});

  @override
  State<ForumSection> createState() => _ForumSectionState();
}

class _ForumSectionState extends State<ForumSection> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
  }

  @override
  void initState() {
    heightController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    weightController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  bool isSelected = true;

  bool _firstRadioValue = true;
  bool _secondRadioValue = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  padding: const EdgeInsets.all(25),
                  width:
                      constraints.maxWidth < 550 ? constraints.maxWidth : 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      genderSelect(),
                      10.ph,
                      const CustomDivider(),
                      10.ph,
                      ForumDetails(
                          nameController: nameController,
                          ageController: ageController,
                          heightController: heightController,
                          weightController: weightController),
                      10.ph,
                      const CustomDivider(),
                      smokerSelect(),
                      const CustomDivider(),
                      10.ph,
                      ForumAction(
                        formkey: formkey,
                        nameController: nameController,
                        ageController: ageController,
                        heightController: heightController,
                        weightController: weightController,
                        isSelected: isSelected,
                        firstRadioValue: _firstRadioValue,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Row genderSelect() {
    return Row(
      children: [
        CustomGenderButton(
          icon: Icons.male,
          ontap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          text: 'Male',
          color: isSelected == true ? kButtonColor : Colors.white,
          textStyle: isSelected == true
              ? const TextStyle(color: Colors.white, fontSize: 18)
              : const TextStyle(color: kTextColor, fontSize: 18),
          iconColor: isSelected == true ? Colors.white : kTextColor,
        ),
        10.pw,
        CustomGenderButton(
          icon: Icons.female,
          ontap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          text: 'Female',
          color: isSelected == false ? kButtonColor : Colors.white,
          textStyle: isSelected == false
              ? const TextStyle(color: Colors.white, fontSize: 18)
              : const TextStyle(color: kTextColor, fontSize: 18),
          iconColor: isSelected == false ? Colors.white : kTextColor,
        ),
      ],
    );
  }

  Column smokerSelect() {
    return Column(
      children: [
        RadioListTile(
          title: const Text(
            "Smoker",
            style: Styles.textStyle20,
          ),
          value: true,
          groupValue: _firstRadioValue,
          onChanged: (value) {
            setState(() {
              _firstRadioValue = value!;
              _secondRadioValue = !value;
            });
          },
        ),
        RadioListTile(
          title: const Text(
            "Not Smoker",
            style: Styles.textStyle20,
          ),
          value: true,
          groupValue: _secondRadioValue,
          onChanged: (value) {
            setState(() {
              _firstRadioValue = !value!;
              _secondRadioValue = value;
            });
          },
        ),
      ],
    );
  }
}
