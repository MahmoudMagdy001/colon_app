import 'dart:convert';

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
  String? seq;

  Future<List<dynamic>> makePostRequest(String gene) async {
    final url = Uri.parse('http://10.0.2.2:5000/gene_search');
    final header = {"Content-type": "application/json"};
    final body = {'gene': gene};
    final response =
        await http.post(url, headers: header, body: jsonEncode(body));
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(data[0]['protein_alignment']);
      }
      setState(() {
        seq = data[0]['protein_alignment'];
      });
    } else {
      if (kDebugMode) {
        print('error');
      }
    }
    return data;
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
                      TextFormField(
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
                        child: seq != null
                            ? Text(
                                seq.toString(),
                                style: const TextStyle(
                                    fontSize: 20, letterSpacing: 5),
                              )
                            : const SizedBox(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              text: 'Reset'.toUpperCase(),
                              onPressed: () {
                                geneController.clear();
                                seq = '';
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              backgroundColor: kButtonColor,
                              textColor: Colors.white,
                              text: 'Submit'.toUpperCase(),
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  makePostRequest(geneController.text.trim());
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
}
