// ignore_for_file: library_private_types_in_public_api

import 'package:colon_app/core/utlis/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/widgets/custom_loading_indicator.dart';

final supabase = Supabase.instance.client;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _redirectCalled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    final session = supabase.auth.currentSession;
    if (session != null) {
      GoRouter.of(context).go(AppRouter.kNewsView);
    } else {
      GoRouter.of(context).go(AppRouter.kLoginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CustomLoadingIndicator()),
    );
  }
}
