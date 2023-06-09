// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:colon_app/core/widgets/custom_button.dart';
import 'package:colon_app/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_divider.dart';

final supabase = Supabase.instance.client;

class PatientDetailsPage extends StatefulWidget {
  final int id;
  const PatientDetailsPage({Key? key, required this.id}) : super(key: key);
  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Future<List<dynamic>> getPatientData() async {
    try {
      final patientData = await supabase.rpc(
        'get_patient_data',
        params: {
          'p_id_input': widget.id,
          'dr_email_input': '${supabase.auth.currentUser?.email}',
        },
      );
      return patientData;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getTumorData() async {
    try {
      final tumorData = await supabase.rpc(
        'get_tumor_data',
        params: {
          'patient_id': widget.id,
          'doctor_email': '${supabase.auth.currentUser?.email}',
        },
      );
      return tumorData;
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteTumor() async {
    final deleteTumor = await supabase
        .rpc('delete_tumors_for_patient', params: {'p_id_input': widget.id});
    return deleteTumor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Information',
          style: Styles.textStyle20,
        ),
      ),
      body: Column(
        children: [
          information(),
          chart(),
        ],
      ),
    );
  }

  FutureBuilder<List<dynamic>> information() {
    return FutureBuilder(
      future: getPatientData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        final data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Name: ${data[0]['p_name']}',
                    style: Styles.textStyle20,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Date: ${data[0]['p_submit_date'].toString()}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Age: ${data[0]['age_years'].toString()}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Height: ${data[0]['p_height'].toString()}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Weight: ${data[0]['p_weight'].toString()}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Bsa: ${data[0]['p_bsa'].toString()}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              if (data[0]['p_gender'] == true)
                Text(
                  'Gender:  Male',
                  style: Styles.textStyle18
                      .copyWith(fontWeight: FontWeight.normal),
                )
              else
                Text('Gender:  Female',
                    style: Styles.textStyle18
                        .copyWith(fontWeight: FontWeight.normal)),
              const SizedBox(height: 8),
              if (data[0]['p_smoke'] == true)
                Text('Smoke: Smoker',
                    style: Styles.textStyle18
                        .copyWith(fontWeight: FontWeight.normal))
              else
                Text('Smoke : Not Smoker',
                    style: Styles.textStyle18
                        .copyWith(fontWeight: FontWeight.normal)),
              const SizedBox(height: 5),
              const CustomDivider(),
            ],
          ),
        );
      },
    );
  }

  FutureBuilder<List<dynamic>> chart() {
    return FutureBuilder(
      future: getTumorData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CustomLoadingIndicator(),
          );
        }
        final data = snapshot.data!;

        var dataLength = data.length;
        var startingIndex = max(
            0,
            dataLength -
                5); // Start from the last five values or from the beginning if the array length is less than five

        List<LineSeries<TumorData, String>> tumorData = [];

        final texts = ['cea', 'ca19', 'ca50', 'ca24', 'afp'];

        final tumorMarkersData = [
          'cea_data',
          'ca19_data',
          'ca50_data',
          'ca24_data',
          'afp_data',
        ];

        for (var j = 0; j < tumorMarkersData.length; j++) {
          final tumorMarkerData = <TumorData>[];

          for (var i = startingIndex; i < data.length; i++) {
            final tumorDataPoints =
                TumorData(data[i]['submit_date'], data[i][tumorMarkersData[j]]);
            tumorMarkerData.add(tumorDataPoints);
          }

          final lineSeries = LineSeries<TumorData, String>(
            name: texts[j],
            dataSource: tumorMarkerData,
            xValueMapper: (TumorData data, _) => data.date,
            yValueMapper: (TumorData data, _) => data.value,
          );
          tumorData.add(lineSeries);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SfCartesianChart(
                legend: Legend(
                  isVisible: true,
                  position: LegendPosition.top,
                ),
                title: ChartTitle(
                    text: 'Tumor Markers Chart', textStyle: Styles.textStyle18),
                primaryXAxis: CategoryAxis(),
                series: tumorData,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  backgroundColor: Colors.red,
                  text: 'Restart Chart'.toUpperCase(),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete Patient"),
                          content: const Text(
                              'Are you sure you want to delete Tumor for Patient'),
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
                                await deleteTumor();
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  textColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class TumorData {
  TumorData(this.date, this.value);
  final String date;
  final num value;
}
