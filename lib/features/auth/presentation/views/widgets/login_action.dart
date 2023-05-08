import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/custom_loading_indicator.dart';
import '../../manager/login_cubit/login_cubit.dart';
import '../../manager/login_cubit/login_state.dart';

class LoginAction extends StatelessWidget {
  const LoginAction({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formkey,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formkey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        if (state is LoginLoading) {
          return const CustomLoadingIndicator();
        } else {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  backgroundColor: kButtonColor,
                  text: 'LOGIN',
                  textColor: Colors.white,
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      BlocProvider.of<LoginCubit>(context)
                          .signInWithEmailPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        context: context,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        }
      },
    );
  }
}
