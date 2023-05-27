import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_indicator.dart';
import 'package:http/http.dart' as http;

class EndoscopyDetails extends StatefulWidget {
  const EndoscopyDetails({super.key});

  @override
  State<EndoscopyDetails> createState() => _EndoscopyDetailsState();
}

class _EndoscopyDetailsState extends State<EndoscopyDetails> {
  String result = '';
  bool loading = false;
  int? clas;
  double? confidence;
  String name = '';
  String error = '';
  double? xMax;
  double? xMin;
  double? yMax;
  double? yMin;

  String removeDoubleQuotes(String input) {
    return input.replaceAll('"', '');
  }

  Future<void> uploadImage(File imageFile) async {
    final url = Uri.parse('http://10.0.2.2:5000/endoscopy/predict');
    final request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );
    final response = await request.send();

    if (response.statusCode == 308) {
      final redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        // Make a new request to the redirect URL
        final redirectRequest =
            http.MultipartRequest('POST', Uri.parse(redirectUrl));
        redirectRequest.files
            .add(await http.MultipartFile.fromPath('image', imageFile.path));
        final redirectResponse = await redirectRequest.send();

        if (redirectResponse.statusCode == 200) {
          final responseData = await redirectResponse.stream.bytesToString();
          // Process the response data as needed
          if (kDebugMode) {
            print('Image uploaded successfully after redirection');
          }
          if (kDebugMode) {
            print(responseData[0]);
          }
          String result1 = removeDoubleQuotes(responseData);

          setState(() {
            result = result1;
          });
        } else {
          if (kDebugMode) {
            print(
                'Image upload failed with status ${redirectResponse.statusCode}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Redirect URL not found in headers');
        }
      }
    } else if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      // Process the response data as needed

      List<dynamic> responseList = jsonDecode(responseData);
      String result1 = removeDoubleQuotes(responseData);

      setState(() {
        clas = responseList[0]['class'];
        confidence = responseList[0]['confidence'];
        name = responseList[0]['name'];
        result = result1;
        xMax = responseList[0]['xmax'];
        xMin = responseList[0]['xmin'];
        yMax = responseList[0]['ymax'];
        yMin = responseList[0]['ymin'];
      });

      if (kDebugMode) {
        print('Image uploaded successfully');
      }
      if (kDebugMode) {
        print('Response: $responseData');
      }
    } else {
      if (kDebugMode) {
        print('Image upload failed with status ${response.statusCode}');
      }
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

  File? imageEndoscopy;
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageEndoscopy = File(pickedFile.path);
      });
      return File(pickedFile.path);
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
            return SingleChildScrollView(
              child: Container(
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
                              'Upload Endoscopy images here',
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
                    if (imageEndoscopy != null)
                      Image.file(
                        imageEndoscopy!,
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
                    if (result == '')
                      Container()
                    else
                      Text(
                        yMax.toString(),
                        style: Styles.textStyle25.copyWith(color: kTextColor),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Upload Image'.toUpperCase(),
                            backgroundColor: kButtonColor,
                            textColor: Colors.white,
                            onPressed: () {
                              pickImage();
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        if (imageEndoscopy != null)
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
                                          imageEndoscopy!,
                                        );
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
    );
  }

  void resetImage() {
    setState(() {
      imageEndoscopy = null;
      result = '';
      clas = null;
      confidence = null;
      name = '';
      xMax = null;
      xMin = null;
      yMax = null;
      yMin = null;
    });
  }
}
