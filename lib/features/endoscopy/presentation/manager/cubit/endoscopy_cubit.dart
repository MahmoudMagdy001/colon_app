// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

part 'endoscopy_state.dart';

class EndoscopyCubit extends Cubit<EndoscopyState> {
  EndoscopyCubit() : super(EndoscopyInitial());

  File? imageEndoscopy;
  Future pickImageEndoscopy(ImageSource source) async {
    emit(EndoscopyLoading());
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      imageEndoscopy = imageTemporary;
      emit(EndoscopySuccess());
    } on PlatformException {
      emit(EndoscopyFailure());
    }
  }

  Future resetImageEndoscopy() async {
    imageEndoscopy = null;
  }
}
