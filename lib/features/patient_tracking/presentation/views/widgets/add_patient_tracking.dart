// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'package:colon_app/core/utlis/app_router.dart';
import 'package:colon_app/core/widgets/custom_loading_indicator.dart';
import 'package:colon_app/features/patient_tracking/presentation/manager/cubit/patient_tracking_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';

final supabase = Supabase.instance.client;

class AddPatientTracking extends StatefulWidget {
  const AddPatientTracking({super.key});

  @override
  _AddPatientTrackingState createState() => _AddPatientTrackingState();
}

class _AddPatientTrackingState extends State<AddPatientTracking> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _drugController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  String? _ajccStage;
  String? _tnm;
  String? _grade;
  final TextEditingController _notesController = TextEditingController();

  final Map<String, List<String>> _tnmOptions = {
    '0': ['Tis, N0, M0', 'TX, NX, M0', 'T0, N0, M0'],
    'I': ['T1 or T2, N0, M0', 'TX, NX, M0'],
    'IIA': ['T3, N0, M0', 'TX, NX, M0'],
    'IIB': ['T4a, N0, M0', 'TX, NX, M0'],
    'IIC': ['T4b, N0, M0', 'TX, NX, M0'],
    'IIIA': ['T1 or T2, N1 or N1c, M0', 'T1, N2a, M0', 'TX, NX, M0'],
    'IIIB': [
      'T3 or T4a, N1 or N1c, M0',
      'T2 or T3, N2a, M0',
      'T1 or T2, N2b, M0',
      'TX, NX, M0'
    ],
    'IIIC': [
      'T4a, N2a, M0',
      'T3 or T4a, N2b, M0',
      'T4b, N1 or N2, M0',
      'TX, NX, M0'
    ],
    'IVA': ['any T, Any N, M1a', 'TX, NX, M0'],
    'IVB': ['any T, Any N, M1b', 'TX, NX, M0'],
    'IVC': ['any T, Any N, M1c', 'TX, NX, M0'],
  };

  @override
  void dispose() {
    _drugController.dispose();
    _doseController.dispose();
    _notesController.dispose();
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

  String? _selectedName;
  int? selectedAge;
  bool? selectedGender;
  int? selectedID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  GoRouter.of(context).go(AppRouter.kPatientTrachingView);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            const Text('Tracking Form'),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _drugController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  labelText: 'Drug',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a drug';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^[0-9.]*')),
                                ],
                                keyboardType: TextInputType.number,
                                controller: _doseController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  labelText: 'Dose',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a dose';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  labelText: 'AJCC Stage',
                                ),
                                value: _ajccStage,
                                onChanged: (newValue) {
                                  setState(() {
                                    _ajccStage = newValue!;
                                    _tnm = null;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select AJCC';
                                  }
                                  return null;
                                },
                                items: <String>[
                                  '0',
                                  'I',
                                  'IIA',
                                  'IIB',
                                  'IIC',
                                  'IIIA',
                                  'IIIB',
                                  'IIIC',
                                  'IVA',
                                  'IVB',
                                  'IVC'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  labelText: 'Grade',
                                ),
                                value: _grade,
                                onChanged: (newValue) {
                                  setState(() {
                                    _grade = newValue!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a grade';
                                  }
                                  return null;
                                },
                                items: <String>[
                                  'G1',
                                  'G2',
                                  'G3',
                                  'G4',
                                  'GX'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            labelText: 'TNM',
                          ),
                          value: _tnm,
                          onChanged: (newValue) {
                            setState(() {
                              _tnm = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a TNM';
                            }
                            return null;
                          },
                          items: _ajccStage == '0'
                              ? _tnmOptions['0']?.map<DropdownMenuItem<String>>(
                                  (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList()
                              : _tnmOptions[_ajccStage]
                                  ?.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    if (value == 'T0, N0, M0' &&
                                        _ajccStage != '0') {}
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  })
                                  .where((element) => element != null)
                                  .toList(),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _notesController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            labelText: 'Notes',
                          ),
                          minLines: 5,
                          maxLines: null,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                  backgroundColor: Colors.red,
                                  text: 'reset'.toUpperCase(),
                                  onPressed: () {
                                    clearTexts();
                                    setState(() {});
                                  },
                                  textColor: Colors.white),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: BlocBuilder<PatientTrackingCubit,
                                  PatientTrackingState>(
                                builder: (context, state) {
                                  if (state is AddLoading) {
                                    return const Center(
                                      child: CustomLoadingIndicator(),
                                    );
                                  }
                                  return CustomButton(
                                      backgroundColor: kButtonColor,
                                      text: 'submt'.toUpperCase(),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          await BlocProvider.of<
                                                  PatientTrackingCubit>(context)
                                              .addDrug(
                                            selectedID,
                                            _drugController.text.trim(),
                                            double.parse(
                                                _doseController.text.trim()),
                                            _ajccStage,
                                            _tnm,
                                            _grade,
                                            _notesController.text.trim(),
                                            context,
                                          );
                                        }
                                      },
                                      textColor: Colors.white);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  clearTexts() {
    _drugController.clear();
    _doseController.clear();
    _notesController.clear();
    _grade = null;
    _tnm = null;
    _ajccStage = null;
    _selectedName = null;
  }
}
