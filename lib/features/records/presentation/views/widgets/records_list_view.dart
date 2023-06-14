// ignore_for_file: use_build_context_synchronously

import 'package:colon_app/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../forum/presentation/manager/cubit/patient_cubit.dart';
import 'details_screen.dart';

final supabase = Supabase.instance.client;

class RecordsListView extends StatefulWidget {
  const RecordsListView({Key? key}) : super(key: key);

  @override
  State<RecordsListView> createState() => _RecordsListViewState();
}

class _RecordsListViewState extends State<RecordsListView> {
  Future<List<dynamic>> getAllPatientsByDoctorEmail(String doctorEmail) async {
    try {
      final data = await supabase.rpc(
        'get_all_patient_by_doctor_email',
        params: {'doc_email_input': doctorEmail},
      );
      return data;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future:
          getAllPatientsByDoctorEmail('${supabase.auth.currentUser?.email}'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'No Records Yet',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        final data = snapshot.data!;
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final doctor = data[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsPage(
                          id: doctor['p_id'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete Patient"),
                              content: Text(
                                  "Are you sure you want to delete ${doctor['p_name']} ?"),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    "No",
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    await context
                                        .read<PatientCubit>()
                                        .deletePatient(doctor['p_id']);
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        // setState(() {});
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          '${doctor['p_id'].toString()} - ',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          doctor['p_name'],
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      doctor['p_submit_date'],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
