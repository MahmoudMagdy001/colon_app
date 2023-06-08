// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import 'package:colon_app/core/widgets/custom_loading_indicator.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';

class HistopathologyDetails extends StatefulWidget {
  const HistopathologyDetails({super.key});

  @override
  State<HistopathologyDetails> createState() => _HistopathologyDetailsState();
}

class _HistopathologyDetailsState extends State<HistopathologyDetails> {
  String result = '';
  bool loading = false;

  String removeDoubleQuotes(String input) {
    return input.replaceAll('"', '');
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse('http://10.0.2.2:5000/histopathology/predict');
      var request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();

        // Process the response data as needed
        if (kDebugMode) print('Image uploaded successfully');

        setState(() => result = removeDoubleQuotes(responseData));
        if (kDebugMode) print('Response: $responseData');
      } else {
        if (kDebugMode) {
          print('Image upload failed with status ${response.statusCode}');
        }
      }
    } on Exception catch (e) {
      if (kDebugMode) print('Caught error: $e');
    }
  }

  Future<void> addphoto(File imageFile) async {
    setState(() {
      loading = true;
    });
    await uploadImage(imageFile);
    setState(() {
      loading = false;
    });
  }

  File? imageHistopathology;

  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileExtension = p.extension(file.path).toLowerCase();

      if (fileExtension == '.png' ||
          fileExtension == '.jpg' ||
          fileExtension == '.jpeg') {
        setState(() {
          imageHistopathology = file;
        });
        return file;
      } else {
        // Show an error message or perform necessary actions for invalid image types.
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Invalid Image type'),
            content: const Text('Selected file is not a PNG or JPG.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          ),
        );
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Upload Histopathology images here',
                            style: Styles.textStyle25,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 58,
                        child: IconButton(
                          onPressed: () {
                            resetImage();
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.restart_alt,
                            size: 50,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  if (imageHistopathology != null)
                    Image.file(
                      imageHistopathology!,
                      width: double.infinity,
                      fit: BoxFit.fitHeight,
                      height: 250,
                    )
                  else
                    const Icon(
                      Icons.question_mark,
                      size: 250,
                      color: kTextColor,
                    ),
                  const SizedBox(height: 25),
                  if (result != '')
                    Text(
                      result,
                      style: Styles.textStyle20.copyWith(color: kTextColor),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Upload Image'.toUpperCase(),
                          backgroundColor: kButtonColor,
                          textColor: Colors.white,
                          onPressed: () async {
                            await pickImage();

                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      if (imageHistopathology != null)
                        if (result == '')
                          loading == true
                              ? const Center(child: CustomLoadingIndicator())
                              : Expanded(
                                  child: CustomButton(
                                    backgroundColor: kButtonColor,
                                    text: 'Submit'.toUpperCase(),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      addphoto(
                                        imageHistopathology!,
                                      );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void resetImage() {
    setState(() {
      imageHistopathology = null;
      result = '';
    });
  }
}
