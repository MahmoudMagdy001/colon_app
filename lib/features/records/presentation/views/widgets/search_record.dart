// ignore_for_file: library_private_types_in_public_api, unused_field

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import 'details_screen.dart';
import 'package:flutter/services.dart';

final supabase = Supabase.instance.client;

class PatientsList extends StatefulWidget {
  const PatientsList({Key? key}) : super(key: key);

  @override
  _PatientsListState createState() => _PatientsListState();
}

class _PatientsListState extends State<PatientsList> {
  final TextEditingController _nameController = TextEditingController();
  List<dynamic> _patients = [];
  String _searchQuery = '';

  Future<List<dynamic>> _getAllPatientsByDoctorEmail(String docEmail) async {
    final data = await supabase.rpc('get_all_patient_by_doctor_email',
        params: {'doc_email_input': docEmail});
    if (kDebugMode) {
      print(data);
    }
    return data;
  }

  void getData() {
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
    getData();
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              prefixIcon: Icons.search,
              text: 'Search by ID',
              obscureText: false,
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _patients.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final patient = _patients[index];
                if (_searchQuery.isNotEmpty &&
                    !patient['p_id'].toString().contains(_searchQuery)) {
                  return const SizedBox.shrink();
                }

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
