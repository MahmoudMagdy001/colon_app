// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

part 'histopathology_state.dart';

class HistopathologyCubit extends Cubit<HistopathologyState> {
  HistopathologyCubit() : super(HistopathologyInitial());

  File? imageHistopathology;
  Future pickImageHistopathology(ImageSource source) async {
    emit(HistopathologyLoading());
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      imageHistopathology = File(image.path);
      // imageHistopathology = imageTemporary;
      emit(HistopathologySuccess());
    } on PlatformException {
      emit(HistopathologyFailure());
    }
  }
}
