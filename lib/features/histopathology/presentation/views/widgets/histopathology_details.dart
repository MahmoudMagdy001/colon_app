import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_button.dart';
import 'package:http/http.dart' as http;

class HistopathologyDetails extends StatefulWidget {
  const HistopathologyDetails({super.key});

  @override
  State<HistopathologyDetails> createState() => _HistopathologyDetailsState();
}

class _HistopathologyDetailsState extends State<HistopathologyDetails> {
  String result = '';

  String removeDoubleQuotes(String input) {
    return input.replaceAll('"', '');
  }

  Future<void> uploadImage(File imageFile) async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/histopathology/predict'); // Replace with your actual endpoint
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
            print(responseData);
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

  File? imageHistopathology;
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageHistopathology = File(pickedFile.path);
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
                        child: Text(
                          'Upload Histopathology images here',
                          style: Styles.textStyle25,
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
                  imageHistopathology != null
                      ? Image.file(
                          imageHistopathology!,
                          width: double.infinity,
                          height: 350,
                        )
                      : const Icon(
                          Icons.question_mark,
                          size: 250,
                          color: kTextColor,
                        ),
                  const SizedBox(height: 25),
                  result == ''
                      ? Text(
                          'Results Here..',
                          style: Styles.textStyle25.copyWith(color: kTextColor),
                        )
                      : Text(
                          result,
                          style: Styles.textStyle25.copyWith(color: kTextColor),
                        ),
                  const SizedBox(height: 10),
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
                      Expanded(
                        child: CustomButton(
                          backgroundColor: kButtonColor,
                          text: 'Submit'.toUpperCase(),
                          textColor: Colors.white,
                          onPressed: () {
                            uploadImage(imageHistopathology!);
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
