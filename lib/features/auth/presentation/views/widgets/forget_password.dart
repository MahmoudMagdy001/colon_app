import 'package:colon_app/constants.dart';
import 'package:colon_app/core/utlis/styles.dart';
import 'package:colon_app/core/widgets/custom_button.dart';
import 'package:colon_app/core/widgets/custom_loading_indicator.dart';
import 'package:colon_app/core/widgets/custom_text_form_field.dart';
import 'package:colon_app/features/auth/presentation/manager/reset_cubit/reset_cubit.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utlis/assets.dart';
import '../../../../../responsive.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: kPrimaryColor,
              foregroundColor: kTextColor,
              elevation: 0.0,
            )
          : PreferredSize(preferredSize: const Size(0, 0), child: Container()),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Logo(),
                  Center(
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          padding: const EdgeInsets.all(25),
                          width: constraints.maxWidth < 550
                              ? constraints.maxWidth
                              : 400,
                          // adjust the width based on the screen size
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
                              ForgetDetails(emailController: emailController),
                              BlocBuilder<ResetCubit, ResetState>(
                                builder: (context, state) {
                                  if (state is ResetLoading) {
                                    return const CustomLoadingIndicator();
                                  } else {
                                    return SizedBox(
                                      width: double.infinity,
                                      child: CustomButton(
                                        backgroundColor: kButtonColor,
                                        textColor: Colors.white,
                                        text: 'Reset Password'.toUpperCase(),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState?.save();
                                            BlocProvider.of<ResetCubit>(context)
                                                .resetPassword(
                                              emailController.text.trim(),
                                              context,
                                            );
                                            emailController.clear();
                                          }
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AssetsData.logo,
              height: 60,
              color: kButtonColor,
            ),
            Text(
              'COLON CANCER-APP',
              style: Styles.textStyle25.copyWith(color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class ForgetDetails extends StatelessWidget {
  const ForgetDetails({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Reset your password',
          style: Styles.textStyle18.copyWith(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 15),
        Text(
          'Enter your email',
          style: Styles.textStyle18.copyWith(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 25),
        CustomTextFormField(
          controller: emailController,
          prefixIcon: Icons.email,
          text: 'Email',
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your email';
            } else if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onSaved: (value) {
            value = emailController.text.trim();
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}
