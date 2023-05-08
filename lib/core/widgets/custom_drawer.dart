// ignore_for_file: use_build_context_synchronously

import 'package:colon_app/core/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/manager/login_cubit/login_cubit.dart';
import '../../features/auth/presentation/manager/login_cubit/login_state.dart';
import '../utlis/app_router.dart';
import 'custom_appbar_button.dart';

final supabase = Supabase.instance.client;

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

bool _newsSelected = true;
bool _endoscopySelected = false;
bool _histopathologySelected = false;
bool _recordsSelected = false;
bool _geneExpressionSelected = false;
bool _tumorMarkerSelected = false;
bool _patientTrackingSelected = false;

String? email = supabase.auth.currentUser!.email;
List<String> emailParts = email!.split("@");

String username = emailParts[0];

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4.0,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: ListView(
        children: <Widget>[
          DetailsUser(username: username),
          ListTile(
            leading: const Icon(Icons.newspaper),
            title: const Text('News'),
            selected: _newsSelected,
            onTap: () {
              setState(() {
                _newsSelected = true;
                _endoscopySelected = false;
                _histopathologySelected = false;
                _recordsSelected = false;
                _geneExpressionSelected = false;
                _tumorMarkerSelected = false;
                _patientTrackingSelected = false;
              });
              GoRouter.of(context).go(AppRouter.kNewsView);
            },
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: const Text('Endoscopy'),
            selected: _endoscopySelected,
            onTap: () {
              setState(() {
                _newsSelected = false;
                _endoscopySelected = true;
                _histopathologySelected = false;
                _recordsSelected = false;
                _geneExpressionSelected = false;
                _tumorMarkerSelected = false;
                _patientTrackingSelected = false;
              });
              GoRouter.of(context).go(AppRouter.kEndoscopyView);
            },
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: const Text('Histopathology'),
            selected: _histopathologySelected,
            onTap: () {
              setState(() {
                _newsSelected = false;
                _endoscopySelected = false;
                _histopathologySelected = true;
                _recordsSelected = false;
                _geneExpressionSelected = false;
                _tumorMarkerSelected = false;
                _patientTrackingSelected = false;
              });
              GoRouter.of(context).go(AppRouter.kHistopathologyView);
            },
          ),
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text('Records'),
            selected: _recordsSelected,
            onTap: () {
              setState(() {
                _newsSelected = false;
                _endoscopySelected = false;
                _histopathologySelected = false;
                _recordsSelected = true;
                _geneExpressionSelected = false;
                _tumorMarkerSelected = false;
                _patientTrackingSelected = false;
              });
              GoRouter.of(context).go(AppRouter.kRecordsView);
            },
          ),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text('Gene Expression'),
            selected: _geneExpressionSelected,
            onTap: () {
              setState(() {
                _newsSelected = false;
                _endoscopySelected = false;
                _histopathologySelected = false;
                _recordsSelected = false;
                _geneExpressionSelected = true;
                _tumorMarkerSelected = false;
                _patientTrackingSelected = false;
              });
              GoRouter.of(context).go(AppRouter.kGeneExpressionView);
            },
          ),
          ListTile(
            leading: const Icon(Icons.stacked_bar_chart),
            title: const Text('Tumor Marker'),
            selected: _tumorMarkerSelected,
            onTap: () {
              setState(() {
                _newsSelected = false;
                _endoscopySelected = false;
                _histopathologySelected = false;
                _recordsSelected = false;
                _geneExpressionSelected = false;
                _tumorMarkerSelected = true;
                _patientTrackingSelected = false;
              });
              GoRouter.of(context).go(AppRouter.kTumorMarkerView);
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_view),
            title: const Text('Patient Tracking'),
            selected: _patientTrackingSelected,
            onTap: () {
              setState(() {
                _newsSelected = false;
                _endoscopySelected = false;
                _histopathologySelected = false;
                _recordsSelected = false;
                _geneExpressionSelected = false;
                _tumorMarkerSelected = false;
                _patientTrackingSelected = true;
              });
              GoRouter.of(context).go(AppRouter.kPatientTrachingView);
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          BlocBuilder<LoginCubit, LoginState>(
            builder: (context, state) {
              if (state is LogoutLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                    strokeWidth: 13,
                  ),
                );
              }
              return CustomAppbarButton(
                icon: Icons.logout,
                color: Colors.red,
                text: 'Log out',
                textColor: Colors.red,
                onTap: () async {
                  await BlocProvider.of<LoginCubit>(context).signOut(context);
                  setState(() {
                    _newsSelected = true;
                    _endoscopySelected = false;
                    _histopathologySelected = false;
                    _recordsSelected = false;
                    _geneExpressionSelected = false;
                    _tumorMarkerSelected = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }
}