import 'package:colon_app/core/widgets/custom_divider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/widgets/custom_loading_indicator.dart';

final supabase = Supabase.instance.client;

class PatientTrackingInfo extends StatefulWidget {
  const PatientTrackingInfo({super.key, required this.id, required this.name});

  final int id;
  final String name;

  @override
  State<PatientTrackingInfo> createState() => _PatientTrackingInfoState();
}

class _PatientTrackingInfoState extends State<PatientTrackingInfo> {
  Future<List<dynamic>> getAllDrugsByDoctorEmail(String docEmail) async {
    final data = await supabase.rpc('get_all_drug_info_for_patients',
        params: {'doc_email_input': docEmail});
    if (kDebugMode) {
      print(data);
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getAllDrugsByDoctorEmail('${supabase.auth.currentUser?.email}'),
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
          return ListView.separated(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(data[index]['info_submit_date']),
                    Text(data[index]['drug']),
                    Text(data[index]['dose'].toString()),
                    Text(data[index]['ajcc_stage']),
                    Text(data[index]['tnm']),
                    Text(data[index]['grade']),
                    Text(data[index]['notes']),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const CustomDivider();
            },
          );
        },
      ),
    );
  }
}
