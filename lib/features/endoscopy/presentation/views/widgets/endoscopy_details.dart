// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:colon_app/features/endoscopy/presentation/views/widgets/predict_endo_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../../../constants.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_alert.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_indicator.dart';

class EndoscopyDetails extends StatefulWidget {
  const EndoscopyDetails({super.key});

  @override
  State<EndoscopyDetails> createState() => _EndoscopyDetailsState();
}
//

class _EndoscopyDetailsState extends State<EndoscopyDetails> {
  String error = '';
  bool loading = false;
  int clas = 0;
  double confidence = 0;
  String name = '';

  double xmax = 0;
  double xmin = 0;
  double ymax = 0;
  double ymin = 0;

  String labelBinary = '';
  String toImage = '';

  String removeDoubleQuotes(String input) {
    return input.replaceAll('"', '');
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse('http://10.0.2.2:5000/endoscopy/predict');
      final request = http.MultipartRequest('POST', url);
      request.headers['Connection'] = 'keep-alive'; // Add keep-alive header
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final jsonResponse = jsonDecode(utf8.decode(responseData));

        List<dynamic> data = jsonResponse;

        if (data[0].length > 1) {
          setState(() {
            labelBinary = data[0]['label_binary'].toString();
            toImage = data[0]['to_image'];
          });
        } else {
          error = data[0]['error'];
        }
      } else {
        if (kDebugMode) {
          print('Image upload failed with status ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Caught error: $e');
      }
    }
  }

  ////////////////////////////////////////////////////

  Future<void> adenoOrHyper(File imageFile) async {
    await uploadImage(imageFile);
    if (error == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Predicted $toImage'.split(":")[0]),
            content: const Text('Do you want to Proceed to polyp detection?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                child: const Text(
                  'NO',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                child: const Text("YES"),
                onPressed: () async {
                  if (labelBinary == '0') {
                    final url = Uri.parse('http://10.0.2.2:5000/hyper');
                    final request = http.MultipartRequest('POST', url);
                    request.headers['Connection'] =
                        'keep-alive'; // Add keep-alive header
                    request.files.add(await http.MultipartFile.fromPath(
                      'image',
                      imageFile.path,
                    ));

                    final response = await request.send();

                    if (response.statusCode == 200) {
                      final responseData = await response.stream.toBytes();
                      final jsonResponse =
                          jsonDecode(utf8.decode(responseData));

                      List<dynamic> data = jsonResponse;
                      setState(() {
                        confidence = data[0]['conf'] ?? 0;
                        name = data[0]['class_name'] ?? '';
                        xmax = data[0]['bbox_list'][0] ?? 0;
                        ymax = data[0]['bbox_list'][1] ?? 0;
                        xmin = data[0]['bbox_list'][2] ?? 0;
                        ymin = data[0]['bbox_list'][3] ?? 0;
                      });
                      if (kDebugMode) {
                        print(xmax);
                        print(ymax);
                        print(xmin);
                        print(ymin);
                        print(name);
                        print(confidence);
                      }

                      Rect rect = Rect.fromPoints(
                          Offset(xmin, ymin), Offset(xmax, ymax));

                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageBox(
                            clss: name.toString(),
                            confidence: confidence,
                            imagePath: imageEndoscopy!,
                            rect: rect,
                          ),
                        ),
                      );
                      reset();
                    } else {
                      if (kDebugMode) {
                        print(
                            'Image upload failed with status ${response.statusCode}');
                      }
                    }
                  } else if (labelBinary == '1') {
                    final url = Uri.parse('http://10.0.2.2:5000/adeno');
                    final request = http.MultipartRequest('POST', url);
                    request.headers['Connection'] =
                        'keep-alive'; // Add keep-alive header
                    request.files.add(await http.MultipartFile.fromPath(
                      'image',
                      imageFile.path,
                    ));

                    final response = await request.send();

                    if (response.statusCode == 200) {
                      final responseData = await response.stream.toBytes();
                      final jsonResponse =
                          jsonDecode(utf8.decode(responseData));

                      List<dynamic> data = jsonResponse;
                      setState(() {
                        confidence = data[0]['conf'] ?? 0;
                        name = data[0]['class_name'] ?? '';
                        xmax = data[0]['bbox_list'][0] ?? 0;
                        ymax = data[0]['bbox_list'][1] ?? 0;
                        xmin = data[0]['bbox_list'][2] ?? 0;
                        ymin = data[0]['bbox_list'][3] ?? 0;
                      });
                      if (kDebugMode) {
                        print(xmax);
                        print(ymax);
                        print(xmin);
                        print(ymin);
                        print(name);
                        print(confidence);
                      }
                      Rect rect = Rect.fromPoints(
                          Offset(xmin, ymin), Offset(xmax, ymax));

                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageBox(
                            clss: name.toString(),
                            confidence: confidence,
                            imagePath: imageEndoscopy!,
                            rect: rect,
                          ),
                        ),
                      );
                      reset();
                    } else {
                      if (kDebugMode) {
                        print(
                            'Image upload failed with status ${response.statusCode}');
                      }
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  //////////////////////////////

  Future<void> addphoto(File imageFile) async {
    setState(() {
      loading = true;
    });
    await adenoOrHyper(imageEndoscopy!);
    setState(() {
      loading = false;
    });
  }

  File? imageEndoscopy;

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
          imageEndoscopy = file;
        });
        final image = await decodeImageFromList(await file.readAsBytes());
        final width = image.width;
        final height = image.height;

        if (kDebugMode) {
          print('Selected image size: width $width height $height');
        }
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
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
                              'Upload Endoscopic images here',
                              style: Styles.textStyle25,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 58,
                          child: IconButton(
                            onPressed: () {
                              reset();
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
                      Stack(
                        children: [
                          Image.file(
                            imageEndoscopy!,
                          ),
                        ],
                      )
                    else
                      const Icon(
                        Icons.image_not_supported_outlined,
                        size: 250,
                        color: kTextColor,
                      ),
                    if (toImage != '') const SizedBox(height: 10),
                    if (toImage != '')
                      Text(
                        toImage,
                        style: Styles.textStyle20,
                      ),
                    if (error != '')
                      const SizedBox(
                        height: 10,
                      ),
                    Text(
                      error,
                      style: Styles.textStyle20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const SizedBox(height: 15),
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
                              getImageSize(imageEndoscopy!);
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        loading == true
                            ? const Center(child: CustomLoadingIndicator())
                            : Expanded(
                                child: CustomButton(
                                  backgroundColor: kButtonColor,
                                  text: 'Submit'.toUpperCase(),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (imageEndoscopy != null) {
                                      await addphoto(
                                        imageEndoscopy!,
                                      );
                                      if (error == '') {}
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const CustomAlert(
                                            title: 'Endoscopy',
                                            content:
                                                'Please Upload Image First.',
                                          );
                                        },
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
    );
  }

  void reset() {
    setState(() {
      imageEndoscopy = null;
      error = '';
      xmax = 0;
      xmin = 0;
      ymin = 0;
      ymax = 0;
      clas = 0;
      confidence = 0;
      name = '';
      toImage = '';
      labelBinary = '';
    });
  }

  Future<Size?> getImageSize(File imageFile) async {
    if (await imageFile.exists()) {
      final image = Image.file(imageFile);
      final completer = Completer<Size>();
      image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(
              Size(
                info.image.width.toDouble(),
                info.image.height.toDouble(),
              ),
            );
          },
        ),
      );

      return completer.future;
    } else {
      if (kDebugMode) {
        print('Image file does not exist.');
      }
      return null;
    }
  }
}
