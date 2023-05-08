// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utlis/app_router.dart';
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
      GoRouter.of(context).go(AppRouter.kLoginScreen);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<void> signUpWithEmailAndPassword(
  //   String name,
  //   String email,
  //   String password,
  //   BuildContext context,
  // ) async {
  //   try {
  //     emit(AuthLoading());
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     User user = userCredential.user!;
  //     await user.updateDisplayName(name);
  //     emit(AuthSuccess());
  //     GoRouter.of(context).go(AppRouter.kLoginScreen);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return const CustomAlert(
  //             title: 'Sign up',
  //             content: 'weak password',
  //           );
  //         },
  //       );
  //       emit(const AuthError(
  //           errorMessage: 'The password provided is too weak.'));
  //     } else if (e.code == 'email-already-in-use') {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return const CustomAlert(
  //             title: 'Sign up',
  //             content: 'email already in use',
  //           );
  //         },
  //       );
  //       emit(const AuthError(
  //           errorMessage: 'The account already exists for that email.'));
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return const CustomAlert(
  //             title: 'Sign up',
  //             content: 'An error occurred while signing up.',
  //           );
  //         },
  //       );
  //       emit(const AuthError(
  //           errorMessage: 'An error occurred while signing up.'));
  //     }
  //   } catch (e) {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return const CustomAlert(
  //           title: 'Sign up',
  //           content: 'An error occurred while signing up.',
  //         );
  //       },
  //     );
  //     emit(
  //         const AuthError(errorMessage: 'An error occurred while signing up.'));
  //   }
  // }
}
