// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:colon_app/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utlis/app_router.dart';
import '../../../../../core/widgets/custom_alert.dart';
import 'auth_state.dart';

final supabase = Supabase.instance.client;

class AuthCubit extends Cubit<SignupState> {
  AuthCubit() : super(AuthInitial());

  Future<void> signUpWithEmailAndPassword(
      {required String password,
      required String email,
      required String username,
      required BuildContext context}) async {
    try {
      emit(AuthLoading());
      await supabase.auth.signUp(
        password: password,
        email: email,
      );
      await supabase.rpc(
        'update_doctor_username',
        params: {
          'email_input': email,
          'username_input': username,
        },
      );
      emit(AuthSuccess());
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Signup'),
            content:
                const Text('Please check your email and confirm your account.'),
            actions: [
              TextButton(
                child: const Text(
                  "Ok",
                  style: TextStyle(color: kButtonColor),
                ),
                onPressed: () {
                  GoRouter.of(context).go(AppRouter.kLoginScreen);
                },
              ),
            ],
          );
        },
      );
    } on AuthException catch (e) {
      if (e.message == 'Password should be at least 8 characters') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: 'Signup',
              content: 'Password should be at least 8 characters.',
            );
          },
        );
        emit(const AuthError(
            errorMessage: 'Password should be at least 8 characters.'));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: 'Signup',
              content: 'An error occurred while signing up.',
            );
          },
        );
        emit(AuthError(errorMessage: e.message));
        if (kDebugMode) {
          print(e.message);
        }
      }
    }
  }
}
