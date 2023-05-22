import 'package:colon_app/core/widgets/custom_sizedbox.dart';
import 'package:colon_app/features/auth/presentation/views/widgets/signup_action.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/assets.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import '../../../../../responsive.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPassword = true;

  @override
  void dispose() {
    displayNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final picker = ImagePicker();
  String? imagePath;

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
      body: Center(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            signupDetails(),
                            SignupAction(
                              displayNameController: displayNameController,
                              emailController: emailController,
                              passwordController: passwordController,
                              formkey: formkey,
                            ),
                            const SizedBox(height: 10),
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
    );
  }

  Form signupDetails() {
    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Create account to start your tour',
            style: Styles.textStyle18.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 15),
          Text(
            'Enter your credentials',
            style: Styles.textStyle18.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 25),
          CustomTextFormField(
            controller: displayNameController,
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please entre the Name';
              }
              return null;
            },
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: Icons.person,
            text: 'Your Name',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please entre the E-mail adress';
              } else if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: Icons.email,
            text: 'E-mail',
            obscureText: false,
          ),
          20.ph,
          CustomTextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please entre the Password';
              }
              return null;
            },
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPassword = !isPassword;
                });
              },
              icon: isPassword != false
                  ? const Icon(Icons.visibility_off)
                  : const Icon(Icons.visibility),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: Icons.lock,
            text: 'Password',
            obscureText: isPassword,
          ),
          const SizedBox(height: 20),
        ],
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
