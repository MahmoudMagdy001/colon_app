import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';

import 'package:process_run/shell_run.dart';

final supabase = Supabase.instance.client;

class GeneDetails extends StatefulWidget {
  const GeneDetails({super.key});

  @override
  State<GeneDetails> createState() => _GeneDetailsState();
}

class _GeneDetailsState extends State<GeneDetails> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController geneController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    geneController.dispose();
  }

  // Future<void> searchGene(String userInput) async {
  //   final url =
  //       Uri.parse('https://yrgwcqigxvexercvhhzr.functions.supabase.co/gene');

  //   final header = {
  //     'Content-Type': 'application/json',
  //     'Authorization':
  //         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlyZ3djcWlneHZleGVyY3ZoaHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODIwMTUwNzUsImV4cCI6MTk5NzU5MTA3NX0.n1jvJ8k-pUZtdA9OzrRyNBcJQ_FheFMoNTud3aBVK2Q'
  //   };

  //   final body = {'user_input_2': userInput};

  //   final http.Response response =
  //       await http.post(url, headers: header, body: json.encode(body));

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     if (kDebugMode) {
  //       print(data);
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print('Request failed with status: ${response.statusCode}.');
  //     }
  //   }
  // }

  // Future<String> invokeFunction() async {
  //   final shell = Shell();

  //   final result = await shell.run('assets/images/main2.py');

  //   final data = json.decode(result.outText);
  //   return data;
  //   //  else {
  //   //   throw Exception('Failed to invoke function: $result');
  //   // }
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

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
                          height: MediaQuery.of(context).size.height * 0.020),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              text: 'Reset'.toUpperCase(),
                              onPressed: () {
                                geneController.clear();
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
                                if (formkey.currentState!.validate()) {}
                              },
                            ),
                          ),
                        ],
                      )
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
