// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utlis/app_router.dart';

part 'patient_tracking_state.dart';

final supabase = Supabase.instance.client;

class PatientTrackingCubit extends Cubit<PatientTrackingState> {
  PatientTrackingCubit() : super(PatientTrackingInitial());

  Future<void> addDrug(
    int? id,
    String? drug,
    double? dose,
    String? ajcc,
    String? tnm,
    String? grade,
    String? notes,
    BuildContext context,
  ) async {
    try {
      emit(AddLoading());
      final data = await supabase.rpc('add_drug_info', params: {
        'pnt_id_input': id,
        'drug_input': drug,
        'dose_input': dose,
        'ajcc_stage_input': ajcc,
        'tnm_input': tnm,
        'grade_input': grade,
        'notes_input': notes,
      });
      GoRouter.of(context).go(AppRouter.kPatientTrachingView);

      emit(AddSuccess(data));
    } catch (e) {
      emit(AddFailure(e.toString()));
    }
  }
}
