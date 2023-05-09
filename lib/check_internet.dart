import 'package:colon_app/core/utlis/styles.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/utlis/app_router.dart';
import 'core/widgets/user_info.dart';

class CheckInternet extends StatefulWidget {
  const CheckInternet({super.key});

  @override
  _CheckInternetState createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _connectionStatus = 'No Internet';
      });
    } else {
      setState(() {
        _connectionStatus = 'Connected';
      });
      // Navigate to the home screen if there is a connection
      GoRouter.of(context).go(AppRouter.kSplashView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Logo(),
      ),
      body: Center(
        child: _connectionStatus == 'No Internet'
            ? const Text(
                'No Internet Connection',
                style: Styles.textStyle30,
              )
            : const Text(
                'Checking Internet Connection...',
                style: Styles.textStyle23,
              ),
      ),
    );
  }
}
