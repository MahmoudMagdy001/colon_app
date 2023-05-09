// // ignore_for_file: library_private_types_in_public_api

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:supabase_auth_ui/supabase_auth_ui.dart';

// final supabase = Supabase.instance.client;

// class GoogleButton extends StatefulWidget {
//   const GoogleButton({super.key});

//   @override
//   _GoogleButtonState createState() => _GoogleButtonState();
// }

// class _GoogleButtonState extends State<GoogleButton> {
//   final bool _isLoading = false;
//   final bool _redirecting = false;
//   late final TextEditingController _emailController;
//   late final StreamSubscription<AuthChangeEvent> _authStateSubscription;

//   // Future<void> _signInWithGoogle() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   try {
//   //     final session = supabase.auth.currentSession;
//   //     if (session != null && !session.expired) {
//   //       // Use existing session if it's still valid
//   //       await supabase.auth.signIn(
//   //         Provider.google,
//   //         session.token,
//   //       );
//   //     } else {
//   //       // Get a new session and sign in
//   //       final refreshedSession = await supabase.auth.signIn(
//   //         Provider.google,
//   //         options: AuthOptions(
//   //           redirectTo: kIsWeb
//   //               ? null
//   //               : Uri.parse('io.supabase.flutterquickstart://login-callback/'),
//   //         ),
//   //       );
//   //       supabase.auth.storeSession(refreshedSession);
//   //     }
//   //     if (mounted) {
//   //       GoRouter.of(context).go(AppRouter.kNewsView);
//   //     }
//   //   } on AuthException {
//   //     // context.showErrorSnackBar(message: error.message);
//   //   } catch (error) {
//   //     // context.showErrorSnackBar(message: 'Unexpected error occurred');
//   //   }

//   //   setState(() {
//   //     _isLoading = false;
//   //   });
//   // }

//   Future signInGoogle() async {
//   }

//   Future<void> login() async {}

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _authStateSubscription.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(onPressed: onPressed, child: child)
//   }
// }
