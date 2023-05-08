import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';

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

  Future<String> callMyFunction(String input) async {
    final dio = Dio();
    final response = await dio.post(
      'https://yrgwcqigxvexercvhhzr.functions.supabase.co/gene',
      data: {'input_string': input},
    );
    // print(response.data);
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    // callMyFunction();
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
