import 'dart:convert';

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
  String originalGene = '';
  String targetGene = '';
  String lines = '';
  String seqError = '';
  String finalScore = '';
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
        originalGene = data[0]['original_gene'] ?? '';
        targetGene = data[0]['target_gene'] ?? '';
        geneName = data[0]['gene_name'] ?? '';
        lines = data[0]['lines'] ?? '';
        finalScore = data[0]['final_score'] ?? '';
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
                          'Enter Gene Sequence Here',
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
                        minLines: 5,
                        maxLines: null,
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: originalGene != ''
                            ? Column(
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
                              )
                            : const SizedBox(),
                      ),
                      mutationType != ''
                          ? Text(
                              mutationType,
                              style: const TextStyle(fontSize: 18),
                            )
                          : Container(),
                      finalScore != ''
                          ? Text(
                              finalScore,
                              style: const TextStyle(fontSize: 20),
                            )
                          : Container(),
                      geneName != ''
                          ? Text(
                              geneName,
                              style: const TextStyle(fontSize: 20),
                            )
                          : const SizedBox(),
                      seqError != ''
                          ? Text(
                              seqError,
                              style: const TextStyle(fontSize: 20),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 20),
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
                          loading == true
                              ? const Center(
                                  child: CustomLoadingIndicator(),
                                )
                              : Expanded(
                                  child: CustomButton(
                                    backgroundColor: kButtonColor,
                                    textColor: Colors.white,
                                    text: 'Submit'.toUpperCase(),
                                    onPressed: () async {
                                      if (formkey.currentState!.validate()) {
                                        postGene(
                                          geneController.text.replaceAll(
                                            RegExp(r'\s+'),
                                            '',
                                          ),
                                        );
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

  void clearTexts() {
    geneController.clear();
    originalGene = '';
    seqError = '';
    geneName = '';
    finalScore = '';
    mutationType = '';
  }
}
