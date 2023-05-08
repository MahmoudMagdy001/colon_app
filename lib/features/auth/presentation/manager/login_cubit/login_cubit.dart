// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, unused_field

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utlis/app_router.dart';
import '../../../../../core/widgets/custom_alert.dart';
import 'login_state.dart';

final supabase = Supabase.instance.client;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> signInWithEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    emit(LoginLoading());
    try {
      // final AuthResponse res =
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
        
      );
      emit(LoginSuccess());
      GoRouter.of(context).go(AppRouter.kNewsView);
    } on AuthException catch (e) {
      if (e.message == 'user_not_found') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: 'Login',
              content: 'user not found',
            );
          },
        );
        emit(const LoginFailure(errorMessage: 'No user found for that email.'));
      } else if (e.message == 'Invalid_credentials') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: 'Login',
              content: 'wrong password',
            );
          },
        );
        emit(const LoginFailure(
            errorMessage: 'Wrong password provided for that user.'));
      } else if (e.message == 'Email_not_confirmed') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: 'Login',
              content: 'Please confirm your account',
            );
          },
        );
        emit(const LoginFailure(errorMessage: 'Email not Confirmed'));
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CustomAlert(
              title: 'Login',
              content: 'An error occurred while signing up.',
            );
          },
        );
        emit(LoginFailure(errorMessage: e.message));
        if (kDebugMode) {
          print(e.message);
        }
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    emit(LogoutLoading());
    await supabase.auth.signOut();
    emit(LogoutSuccess());
    GoRouter.of(context).go(AppRouter.kAuthView);
  }
}
