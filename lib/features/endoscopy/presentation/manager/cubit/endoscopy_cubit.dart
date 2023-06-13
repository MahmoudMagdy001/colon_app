// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

part 'endoscopy_state.dart';

class EndoscopyCubit extends Cubit<EndoscopyState> {
  EndoscopyCubit() : super(EndoscopyInitial());
  String error = '';
  bool loading = false;
  int clas = 0;
  double confidence = 0;
  String name = '';

  double xmax = 0;
  double xmin = 0;
  double ymax = 0;
  double ymin = 0;

  File? imageEndoscopy;

  Future<File?> pickImage(BuildContext context) async {
    emit(EndoscopyLoading());
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final file = File(pickedFile.path);

        final fileExtension = p.extension(file.path).toLowerCase();

        if (fileExtension == '.png' ||
            fileExtension == '.jpg' ||
            fileExtension == '.jpeg') {
          imageEndoscopy = file;
          emit(EndoscopySuccess());

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
    } catch (e) {
      emit(EndoscopyFailure());
    }
    return null;
  }

  Future<void> postImage() async {
    emit(PostLoading());
    try {
      final url = Uri.parse('http://10.0.2.2:5000/endoscopy/predict');
      final request = http.MultipartRequest('POST', url);
      request.headers['Connection'] = 'keep-alive'; // Add keep-alive header
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageEndoscopy!.path,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final jsonResponse = jsonDecode(utf8.decode(responseData));

        List<dynamic> data = jsonResponse;

        if (data[0].length > 1) {
          clas = data[0]['class'] ?? 0;
          confidence = data[0]['confidence'] ?? 0;
          name = data[0]['name'] ?? '';
          xmin = data[0]['xmin'] ?? 0;
          xmax = data[0]['xmax'] ?? 0;
          ymin = data[0]['ymin'] ?? 0;
          ymax = data[0]['ymax'] ?? 0;
        } else {
          error = data[0]['error'];
        }
        emit(PostSuccess());
      } else {
        emit(PostFailure());
        if (kDebugMode) {
          print('Image upload failed with status ${response.statusCode}');
        }
      }
    } catch (e) {
      emit(PostFailure());
      if (kDebugMode) {
        print('Caught error: $e');
      }
    }
  }

  Future<void> resetImageEndoscopy() async {
    imageEndoscopy = null;
    error = '';
    xmax = 0;
    xmin = 0;
    ymin = 0;
    ymax = 0;
    clas = 0;
    confidence = 0;
    name = '';
    emit(ResetEndocopy());
  }
}
