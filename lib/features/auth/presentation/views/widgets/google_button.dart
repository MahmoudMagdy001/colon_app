// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// import '../../../../../core/utlis/app_router.dart';

// final supabase = Supabase.instance.client;

// class GoogleButton extends StatefulWidget {
//   const GoogleButton({super.key});

//   @override
//   State<GoogleButton> createState() => _GoogleButtonState();
// }

// class _GoogleButtonState extends State<GoogleButton> {
//   bool _isLoading = false;

//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       await supabase.auth.signInWithOAuth(Provider.google);
//       GoRouter.of(context).go(AppRouter.kNewsView);
//     } on AuthException catch (error) {
//       ScaffoldMessenger(child: SnackBar(content: Text(error.message)));
//     } catch (error) {
//       const ScaffoldMessenger(
//           child: SnackBar(content: Text('Unexpected error occurred')));
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _isLoading ? null : _signInWithGoogle,
//       child: Text(_isLoading ? 'Loading' : 'Sign in with Google'),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utlis/app_router.dart';

final supabase = Supabase.instance.client;

class GoogleButton extends StatefulWidget {
  const GoogleButton({super.key});

  @override
  _GoogleButtonState createState() => _GoogleButtonState();
}

class _GoogleButtonState extends State<GoogleButton> {
  bool _isLoading = false;
  bool _redirecting = false;
  late final TextEditingController _emailController;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithOtp(
        email: _emailController.text.trim(),
        emailRedirectTo:
            kIsWeb ? null : 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        // context.showSnackBar(message: 'Check your email for login link!');
        _emailController.clear();
      }
    } on AuthException {
      // context.showErrorSnackBar(message: error.message);
    } catch (error) {
      // context.showErrorSnackBar(message: 'Unexpected error occurred');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await supabase.auth.signInWithOAuth(Provider.google,);
      if (mounted) {
        GoRouter.of(context).go(AppRouter.kNewsView);
      }
    } on AuthException {
      // context.showErrorSnackBar(message: error.message);
    } catch (error) {
      // context.showErrorSnackBar(message: 'Unexpected error occurred');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        GoRouter.of(context).go(AppRouter.kNewsView);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signInWithGoogle,
      child: Text(_isLoading ? 'Loading' : 'Sign in with Google'),
    );
  }
}
