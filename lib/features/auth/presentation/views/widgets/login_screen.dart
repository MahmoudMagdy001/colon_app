// ignore_for_file: unused_local_variable

import 'package:colon_app/features/auth/presentation/views/widgets/reset_password.dart';
import 'package:colon_app/responsive.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../../../../constants.dart';
import '../../../../../core/utlis/assets.dart';
import '../../../../../core/utlis/styles.dart';
import '../../../../../core/widgets/custom_text_form_field.dart';
import 'create_account.dart';
import 'login_action.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPassword = true;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future signInGoogle(String key, String url) async {
    final supabase1 = SupabaseClient(url, key);
    await supabase.auth.signInWithOAuth(Provider.google);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: kPrimaryColor,
              elevation: 0.0,
            )
          : PreferredSize(preferredSize: const Size(0, 0), child: Container()),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
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
                              loginDetails(),
                              const ResetPassword(),
                              LoginAction(
                                emailController: emailController,
                                passwordController: passwordController,
                                formkey: formkey,
                              ),
                              const CreateAccount(),
                              const SizedBox(height: 10),
                              // const CustomDivider(),
                              // const SizedBox(height: 10),
                              // ElevatedButton(
                              //     onPressed: () async {
                              //       signInGoogle(
                              //           'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlyZ3djcWlneHZleGVyY3ZoaHpyIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODIwMTUwNzUsImV4cCI6MTk5NzU5MTA3NX0.n1jvJ8k-pUZtdA9OzrRyNBcJQ_FheFMoNTud3aBVK2Q',
                              //           'https://yrgwcqigxvexercvhhzr.supabase.co');
                              //     },
                              //     child: const Text("Sign in with Google"))
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

  Form loginDetails() {
    return Form(
      key: formkey,
      child: Column(
        children: [
          Text(
            'Sign in to start your tour',
            style: Styles.textStyle18.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 15),
          Text(
            'Enter your credentials',
            style: Styles.textStyle18.copyWith(fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 25),
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
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,

            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter the Password';
              }
              return null;
            },
            // isPassword: isPassword,

            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isPassword = !isPassword;
                });
              },
              icon: isPassword == false
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: Icons.lock,
            text: 'Password', obscureText: isPassword,
          ),
          const SizedBox(height: 15),
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
