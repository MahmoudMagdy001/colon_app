import 'package:colon_app/features/patient_tracking/presentation/views/widgets/patient_tracking_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/widgets/custom_loading_indicator.dart';

final supabase = Supabase.instance.client;

class PatientTrackingDetails extends StatefulWidget {
  const PatientTrackingDetails({super.key});

  @override
  State<PatientTrackingDetails> createState() => _PatientTrackingDetailsState();
}

class _PatientTrackingDetailsState extends State<PatientTrackingDetails> {
  Future<List<dynamic>> getAllPatientsByDoctorEmail(String docEmail) async {
    final data = await supabase.rpc('get_patients_with_drug_info',
        params: {'doctor_email_input': docEmail});
    if (kDebugMode) {
      print(data);
    }
    return data;
  }

  Future<void> deleteDrug(int id) async {
    await supabase
        .rpc('delete_drug_info_for_patient', params: {'p_id_input': id});
  }
  // Future<List<dynamic>> getAllDrugsByDoctorEmail(String docEmail) async {
  //   final data = await supabase.rpc('get_all_drug_info_for_patients',
  //       params: {'doc_email_input': docEmail});
  //   if (kDebugMode) {
  //     print(data);
  //   }
  //   return data;
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getAllPatientsByDoctorEmail('${supabase.auth.currentUser?.email}');
  // }

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
          itemCount: data.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PatientTrackingInfo(
                      id: data[index]['p_id'], name: data[index]['p_name']),
                ));
              },
              child: Card(
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete Patient"),
                            content: Text(
                                "Are you sure you want to delete ${data[index]['p_name']} ?"),
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
                                  await deleteDrug(data[index]['p_id']);
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text('${data[index]['p_id']} - '),
                      Text(data[index]['p_name']),
                    ],
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
