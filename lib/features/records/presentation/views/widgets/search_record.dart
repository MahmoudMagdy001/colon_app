// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import 'details_screen.dart';

final supabase = Supabase.instance.client;

class PatientsList extends StatefulWidget {
  const PatientsList({Key? key}) : super(key: key);

  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  final TextEditingController _nameController = TextEditingController();
  List<dynamic> _patients = [];

  Future<List<dynamic>> _getAllPatientsByDoctorEmail(String docEmail) async {
    final data = await supabase.rpc('get_all_patient_by_doctor_email',
        params: {'doc_email_input': docEmail});
    if (kDebugMode) {
      print(data);
    }
    return data;
  }

  void _search(String query) {
    setState(
      () {
        _patients = _patients.where(
          (patient) {
            return patient['p_id'].toString().contains(query);
          },
        ).toList();
      },
    );
  }

  void _reset() {
    _getAllPatientsByDoctorEmail('${supabase.auth.currentUser?.email}')
        .then((data) {
      setState(() {
        _patients = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kTextColor,
        title: const Text(
          'Patients List',
          style: Styles.textStyle18,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextFormField(
              prefixIcon: Icons.search,
              text: 'Search by ID',
              onChanged: (query) {
                if (query.isEmpty) {
                  _reset();
                } else {
                  setState(() {
                    _search(query);
                  });
                }
              },
              onSubmitted: (query) {
                if (query.isEmpty) {
                  _reset();
                }
              },
              obscureText: false,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _patients.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final patient = _patients[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PatientDetailsPage(id: patient['p_id'])));
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          '${patient['p_id'].toString()} - ',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          patient['p_name'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      patient['p_submit_date'],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
