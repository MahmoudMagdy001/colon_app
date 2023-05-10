// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'reset_state.dart';

final supabase = Supabase.instance.client;

class ResetCubit extends Cubit<ResetState> {
  ResetCubit() : super(ResetInitial());
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      emit(ResetLoading());
      await supabase.auth.resetPasswordForEmail(email);
      emit(ResetSuccess());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Reset"),
            content: const Text('Password reset email sent'),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      emit(ResetFailure(e.toString()));
    }
  }
}
