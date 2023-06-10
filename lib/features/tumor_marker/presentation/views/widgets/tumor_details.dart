// ignore_for_file: use_build_context_synchronously

import 'package:colon_app/core/widgets/custom_loading_indicator.dart';
import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:colon_app/features/tumor_marker/presentation/manager/cubit/tumor_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';

final supabase = Supabase.instance.client;

class TumorDetails extends StatefulWidget {
  const TumorDetails({super.key});

  @override
  State<TumorDetails> createState() => _TumorDetailsState();
}

class _TumorDetailsState extends State<TumorDetails> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? _selectedName;
  int? selectedAge;
  bool? selectedGender;
  int? selectedID;

  TextEditingController nameController = TextEditingController();
  TextEditingController oneController = TextEditingController();
  TextEditingController twoController = TextEditingController();
  TextEditingController threeController = TextEditingController();
  TextEditingController fourController = TextEditingController();
  TextEditingController fiveController = TextEditingController();

  @override
  void initState() {
    oneController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    twoController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    threeController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    fourController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    fiveController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    // getAllPatientsByDoctorEmail('${supabase.auth.currentUser?.email}');
  }

  @override
  void dispose() {
    oneController.dispose();
    twoController.dispose();
    threeController.dispose();
    fourController.dispose();
    fiveController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> getAllPatientsByDoctorEmail(String docEmail) async {
    final data = await supabase.rpc('get_all_patient_by_doctor_email',
        params: {'doc_email_input': docEmail});
    if (kDebugMode) {
      print(data[0]);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  padding: const EdgeInsets.all(25),
                  width:
                      constraints.maxWidth < 550 ? constraints.maxWidth : 440,
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
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder<List<dynamic>>(
                          future: getAllPatientsByDoctorEmail(
                              '${supabase.auth.currentUser?.email}'),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: Text(
                                  'No Records Yet',
                                  style: Styles.textStyle25,
                                ),
                              );
                            }
                            final data = snapshot.data!;

                            return DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return 'Please Select Name First';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Select Name',
                                hintStyle: Styles.textStyle18.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[600],
                                ),
                              ),
                              isExpanded: true,
                              iconSize: 25.0,
                              iconEnabledColor: kButtonColor,
                              style: Styles.textStyle18.copyWith(fontSize: 16),
                              value: _selectedName,
                              items: data.map((document) {
                                String id = document['p_id'].toString();
                                String name = document['p_name'];
                                final String displayText = '$id - $name';
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Text(displayText),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    _selectedName = newValue;
                                    if (kDebugMode) {
                                      print(_selectedName);
                                    }
                                    Map<String, dynamic> selectedDocument =
                                        data.firstWhere(
                                      (document) =>
                                          document['p_name'] == _selectedName,
                                    );

                                    selectedID = selectedDocument['p_id'];
                                    if (kDebugMode) {
                                      print(selectedID);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          controller: oneController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.numbers_rounded,
                          text: 'CEA',
                          obscureText: false,
                          suffixText: 'IU/ml',
                        ),
                        10.ph,
                        if (_selectedName != null)
                          if (double.tryParse(oneController.text) != null)
                            if (double.tryParse(oneController.text)! > 5)
                              const Text(
                                'Not Normal',
                                style: Styles.textStyle15,
                              )
                            else
                              const Text(
                                'Normal',
                                style: Styles.textStyle15,
                              ),
                        10.ph,
                        CustomTextFormField(
                          controller: twoController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.numbers_rounded,
                          text: 'CA 19-9',
                          obscureText: false,
                          suffixText: 'IU/ml',
                        ),
                        10.ph,
                        if (_selectedName != null)
                          if (double.tryParse(twoController.text) != null)
                            if (selectedGender == true)
                              if (selectedAge! >= 20 && selectedAge! <= 50)
                                if (double.tryParse(twoController.text)! >=
                                        1.97 &&
                                    double.tryParse(twoController.text)! <=
                                        25.06)
                                  const Text(
                                    'Normal',
                                    style: Styles.textStyle15,
                                  )
                                else
                                  const Text(
                                    'Not Normal',
                                    style: Styles.textStyle15,
                                  )
                              else if (selectedAge! >= 50 && selectedAge! <= 60)
                                if (double.tryParse(twoController.text)! >=
                                        2.31 &&
                                    double.tryParse(twoController.text)! <=
                                        26.13)
                                  const Text(
                                    'Normal',
                                    style: Styles.textStyle15,
                                  )
                                else
                                  const Text(
                                    'Not Normal',
                                    style: Styles.textStyle15,
                                  )
                              else if (selectedAge! < 20 || selectedAge! > 60)
                                if (double.tryParse(twoController.text)! <= 37)
                                  const Text(
                                    'Normal',
                                    style: Styles.textStyle15,
                                  )
                                else
                                  const Text(
                                    'Not Normal',
                                    style: Styles.textStyle15,
                                  ),
                        if (selectedGender == false)
                          if (selectedAge! >= 20 && selectedAge! <= 60)
                            if (double.tryParse(twoController.text)! >= 2.36 &&
                                double.tryParse(twoController.text)! <= 29.29)
                              const Text(
                                'Normal',
                                style: Styles.textStyle15,
                              )
                            else
                              const Text(
                                'Not Normal',
                                style: Styles.textStyle15,
                              )
                          else if (selectedAge! < 20 || selectedAge! > 60)
                            if (double.tryParse(twoController.text)! <= 37)
                              const Text(
                                'Normal',
                                style: Styles.textStyle15,
                              )
                            else
                              const Text(
                                'Not Normal',
                                style: Styles.textStyle15,
                              ),
                        10.ph,
                        CustomTextFormField(
                          controller: threeController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.numbers_rounded,
                          text: 'CA 50',
                          obscureText: false,
                          suffixText: 'IU/ml',
                        ),
                        10.ph,
                        if (_selectedName != null)
                          if (double.tryParse(threeController.text) != null)
                            if (double.tryParse(threeController.text)! > 25)
                              const Text(
                                'Not Normal',
                                style: Styles.textStyle15,
                              )
                            else
                              const Text(
                                'Normal',
                                style: Styles.textStyle15,
                              ),
                        10.ph,
                        CustomTextFormField(
                          controller: fourController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.numbers_rounded,
                          text: 'CA 24-2',
                          obscureText: false,
                          suffixText: 'IU/ml',
                        ),
                        10.ph,
                        if (_selectedName != null)
                          if (double.tryParse(fourController.text) != null)
                            if (double.tryParse(fourController.text)! > 20)
                              const Text(
                                'Not Normal',
                                style: Styles.textStyle15,
                              )
                            else
                              const Text(
                                'Normal',
                                style: Styles.textStyle15,
                              ),
                        10.ph,
                        CustomTextFormField(
                          controller: fiveController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.numbers_rounded,
                          text: 'AFP',
                          obscureText: false,
                          suffixText: 'IU/ml',
                        ),
                        10.ph,
                        if (_selectedName != null)
                          if (double.tryParse(fiveController.text) != null)
                            if (double.tryParse(fiveController.text)! > 15)
                              const Text(
                                'Not Normal',
                                style: Styles.textStyle15,
                              )
                            else
                              const Text(
                                'Normal',
                                style: Styles.textStyle15,
                              ),
                        10.ph,
                        const SizedBox(height: 5),
                        tumorAction(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Row tumorAction() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            backgroundColor: Colors.red,
            textColor: Colors.white,
            text: 'Reset'.toUpperCase(),
            onPressed: () {
              setState(() {
                clearTexts();
              });
            },
          ),
        ),
        10.pw,
        Expanded(
          child: BlocBuilder<TumorCubit, TumorState>(
            builder: (BuildContext context, state) {
              if (state is AddLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              }

              return CustomButton(
                backgroundColor: kButtonColor,
                textColor: Colors.white,
                text: 'Submit'.toUpperCase(),
                onPressed: () async {
                  final one = oneController.text.trim();
                  double? result = one.isEmpty ? null : double.parse(one);
                  final two = twoController.text.trim();
                  double? result1 = two.isEmpty ? null : double.parse(two);
                  final three = threeController.text.trim();
                  double? result2 = three.isEmpty ? null : double.parse(three);
                  final four = fourController.text.trim();
                  double? result3 = four.isEmpty ? null : double.parse(four);
                  final five = fiveController.text.trim();
                  double? result4 = five.isEmpty ? null : double.parse(five);

                  if (formkey.currentState!.validate()) {
                    if (oneController.text == '' &&
                        twoController.text == '' &&
                        threeController.text == '' &&
                        fourController.text == '' &&
                        fiveController.text == '') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Tumor Validate"),
                            content: const Text("Please Add any value."),
                            actions: [
                              TextButton(
                                child: const Text(
                                  "OK",
                                ),
                                onPressed: () {
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      await BlocProvider.of<TumorCubit>(context).addTumor(
                        selectedID,
                        result,
                        result1,
                        result2,
                        result3,
                        result4,
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Add Tumor"),
                            content: const Text("Tumor Add Successfully."),
                            actions: [
                              TextButton(
                                child: const Text(
                                  "OK",
                                ),
                                onPressed: () {
                                  clearTexts();
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      setState(() {});
                    }
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void clearTexts() {
    oneController.clear();
    twoController.clear();
    threeController.clear();
    fourController.clear();
    fiveController.clear();
    _selectedName = null;
  }
}
