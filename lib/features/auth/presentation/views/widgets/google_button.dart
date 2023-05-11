// // ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

final supabase = Supabase.instance.client;

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  // Future<void> signInWithgoogle() async {
  //   final response = await supabase.auth.signInWithOAuth(
  //     Provider.google,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Login With Google'),
    );
  }
}
