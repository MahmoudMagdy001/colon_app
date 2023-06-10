// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:colon_app/core/utlis/functions/launch_url.dart';
import 'package:colon_app/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

final supabase = Supabase.instance.client;

class GeneDetails extends StatefulWidget {
  const GeneDetails({super.key});

  @override
  State<GeneDetails> createState() => _GeneDetailsState();
}

class _GeneDetailsState extends State<GeneDetails> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController geneController = TextEditingController();
  String geneName = '';
  String ccsid = '';
  String geneType = '';
  String geneUrl = '';
  String originalGene = '';
  String lines = '';
  String targetGene = '';
  String finalScore = '';
  String maxScore = '';
  String matchScore = '';
  String mismatchScore = '';
  String gapOpeningScore = '';
  String gapExtensionScore = '';
  String seqError = '';
  String mutationType = '';
  bool loading = false;

  Future<List<dynamic>> makePostRequest(String gene) async {
    final url = Uri.parse('http://10.0.2.2:5000/gene_search');
    final header = {"Content-type": "application/json"};
    final body = {'gene': gene};
    final response =
        await http.post(url, headers: header, body: jsonEncode(body));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(data);
      }
      setState(() {
        geneName = data[0]['gene_name'] ?? '';
        ccsid = data[0]['ccs_id'] ?? '';
        geneType = data[0]['gene_type'] ?? '';
        geneUrl = data[0]['gene_url'] ?? '';
        originalGene = data[0]['original_gene'] ?? '';
        lines = data[0]['lines'] ?? '';
        targetGene = data[0]['target_gene'] ?? '';
        finalScore = data[0]['final_score'] ?? '';
        maxScore = data[0]['max_score'] ?? '';
        matchScore = data[0]['match_score'] ?? '';
        mismatchScore = data[0]['mismatch_score'] ?? '';
        gapOpeningScore = data[0]['gap_opening_score'] ?? '';
        gapExtensionScore = data[0]['gap_extension_score'] ?? '';
        seqError = data[0]['error'] ?? '';
        mutationType = data[0]['Mutation_Type'] ?? '';
      });
    } else {
      if (kDebugMode) {
        print('error');
      }
    }
    return data;
  }

  Future<void> postGene(String gene) async {
    setState(() {
      loading = true;
    });
    await makePostRequest(gene);
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    geneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Container(
                padding: const EdgeInsets.all(25),
                width: constraints.maxWidth < 550 ? constraints.maxWidth : 440,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Opacity(
                        opacity: 0.7,
                        child: Text(
                          'Enter Protein or Nucleotide Gene Sequence Here',
                          style: Styles.textStyle23,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: geneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Entre Gene Sequence';
                          }
                          return null;
                        },
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          labelText: 'Gene Sequence',
                          hintStyle: Styles.textStyle18
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.020,
                      ),
                      Row(
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
                          const SizedBox(width: 10),
                          if (loading == true)
                            const Center(
                              child: CustomLoadingIndicator(),
                            )
                          else
                            Expanded(
                              child: CustomButton(
                                backgroundColor: kButtonColor,
                                textColor: Colors.white,
                                text: 'Submit'.toUpperCase(),
                                onPressed: () async {
                                  if (formkey.currentState!.validate()) {
                                    await postGene(
                                      geneController.text.replaceAll(
                                        RegExp(r'\s+'),
                                        '',
                                      ),
                                    );
                                    resultDialog(context);
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> resultDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Gene Expression result"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (geneName != '')
                  Text(
                    geneName,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (geneName != '') const SizedBox(height: 8),
                if (ccsid != '')
                  Text(
                    ccsid,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (ccsid != '') const SizedBox(height: 8),
                if (geneType != '')
                  Text(
                    geneType,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (geneType != '') const SizedBox(height: 8),
                if (mutationType != '')
                  Text(
                    mutationType,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (mutationType != '') const SizedBox(height: 8),
                if (originalGene != '')
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          targetGene,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          lines,
                          style: const TextStyle(
                              fontSize: 15, letterSpacing: 1.19),
                        ),
                        Text(
                          originalGene,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                if (originalGene != '') const SizedBox(height: 8),
                if (finalScore != '')
                  Text(
                    'Alignment ${finalScore.trim()}',
                    style: const TextStyle(fontSize: 18),
                  ),
                if (finalScore != '') const SizedBox(height: 8),
                if (maxScore != '')
                  Text(
                    maxScore,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (maxScore != '') const SizedBox(height: 8),
                if (matchScore != '')
                  Text(
                    matchScore,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (matchScore != '') const SizedBox(height: 8),
                if (mismatchScore != '')
                  Text(
                    mismatchScore,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (mismatchScore != '') const SizedBox(height: 8),
                if (gapOpeningScore != '')
                  Text(
                    gapOpeningScore,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (gapOpeningScore != '') const SizedBox(height: 8),
                if (gapExtensionScore != '')
                  Text(
                    gapExtensionScore,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (gapExtensionScore != '') const SizedBox(height: 8),
                if (seqError != '')
                  Text(
                    seqError,
                    style: const TextStyle(fontSize: 18),
                  ),
                if (seqError != '') const SizedBox(height: 8),
                if (geneUrl != '')
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WebViewScreen(
                            geneUrl
                                .substring(geneUrl.indexOf((':')) + 1)
                                .trim(),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      geneUrl.split(": ")[1],
                      style: const TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ),
                  ),
                if (geneUrl != '') const SizedBox(height: 8),
              ],
            ),
          ),
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
  }

  void clearTexts() {
    geneController.clear();
    originalGene = '';
    seqError = '';
    geneName = '';
    finalScore = '';
    mutationType = '';
  }
}
