import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_indicator.dart';
import '../../manager/auth_cubit/auth_cubit.dart';
import '../../manager/auth_cubit/auth_state.dart';

class SignupAction extends StatelessWidget {
  const SignupAction({
    super.key,
    required this.displayNameController,
    required this.emailController,
    required this.passwordController,
    required this.formkey,
  });

  final TextEditingController displayNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formkey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, SignupState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CustomLoadingIndicator();
        }
        return SizedBox(
          width: double.infinity,
          child: CustomButton(
            backgroundColor: kButtonColor,
            text: 'Create Account',
            textColor: Colors.white,
            onPressed: () {
              if (formkey.currentState!.validate()) {
                BlocProvider.of<AuthCubit>(context).signUpWithEmailAndPassword(
                    password: passwordController.text.trim(),
                    email: emailController.text.trim(),
                    username: displayNameController.text.trim(),
                    context: context);
              }
            },
          ),
        );
      },
    );
  }
}
