import 'package:colon_app/core/utlis/styles.dart';
import 'package:colon_app/core/widgets/custom_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/widgets/custom_loading_indicator.dart';

final supabase = Supabase.instance.client;

class PatientTrackingInfo extends StatefulWidget {
  const PatientTrackingInfo({super.key, required this.iD, required this.name});

  final int iD;
  final String name;

  @override
  State<PatientTrackingInfo> createState() => _PatientTrackingInfoState();
}

class _PatientTrackingInfoState extends State<PatientTrackingInfo> {
  Future<List<dynamic>> getAllDrugsByDoctorEmail(
      String docEmail, int id) async {
    final data = await supabase.rpc(
      'get_drug_info_for_patient_and_doctor',
      params: {
        'd_pnt_id_input': id,
        'doc_email_input': docEmail,
      },
    );
    if (kDebugMode) {
      print(data);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Text(
              '${widget.iD} - ',
              style: Styles.textStyle25,
            ),
            Text(
              widget.name,
              style: Styles.textStyle25,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getAllDrugsByDoctorEmail(
            '${supabase.auth.currentUser?.email}', widget.iD),
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
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Submit Date: ${data[index]['info_submit_date']}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const CustomDivider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Drug',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            data[index]['drug'],
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Dose',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            data[index]['dose'].toString(),
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'AJCC Stage',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            data[index]['ajcc_stage'],
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TNM',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            data[index]['tnm'],
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Grade',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            data[index]['grade'],
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (data[index]['notes'] != '')
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notes:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                data[index]['notes'],
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        )
                      else
                        Container()
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
