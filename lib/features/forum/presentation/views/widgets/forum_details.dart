import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/custom_text_form_field.dart';

class ForumDetails extends StatefulWidget {
  const ForumDetails({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.heightController,
    required this.weightController,
  });

  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;

  @override
  State<ForumDetails> createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: widget.nameController,
          keyboardType: TextInputType.name,
          prefixIcon: Icons.person,
          text: 'Patient Name',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Enter patient name';
            }
            return null;
          },
          onChanged: (value) {},
          obscureText: false,
        ),
        10.ph,
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: widget.heightController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefixIcon: Icons.height,
                text: 'Height',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter patient Height';
                  }
                  return null;
                },
                obscureText: false,
              ),
            ),
            10.pw,
            Expanded(
              child: CustomTextFormField(
                controller: widget.weightController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                prefixIcon: Icons.monitor_weight_outlined,
                text: 'Weight',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter patient Weight';
                  }
                  return null;
                },
                obscureText: false,
              ),
            ),
          ],
        ),
        10.ph,
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Enter Birth Date';
            }
            return null;
          },
          controller: widget.ageController,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.calendar_today),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              labelText: "Birth Date"),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2101));

            if (pickedDate != null) {
              if (kDebugMode) {
                print(pickedDate);
              }
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              if (kDebugMode) {
                print(formattedDate);
              }
              setState(() {
                widget.ageController.text = formattedDate;
              });
            } else {
              if (kDebugMode) {
                print("Date is not selected");
              }
            }
          },
        ),
      ],
    );
  }
}
