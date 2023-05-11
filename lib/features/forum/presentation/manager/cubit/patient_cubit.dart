// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:colon_app/features/forum/presentation/manager/cubit/patient_state.dart';

final supabase = Supabase.instance.client;

class PatientCubit extends Cubit<PatientState> {
  PatientCubit() : super(PatientInitial());

  Future<void> addPatient(
    String username,
    String date,
    int height,
    int weight,
    bool gender,
    bool smoke,
  ) async {
    try {
      emit(AddLoading());
      final data = await supabase.rpc(
        'add_patient_data',
        params: {
          'p_name_input': username,
          'p_date_input': date,
          'p_height_input': height,
          'p_weight_input': weight,
          'p_gender_input': gender,
          'p_smoke_input': smoke,
          'doc_email_input': supabase.auth.currentUser?.email,
        },
      );
      emit(AddSuccess(data));
      if (kDebugMode) {
        print(data);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(AddFailure(e.toString()));
    }
  }

  // Future<List<dynamic>> getData(String docEmail) async {
  //   final data = await supabase.rpc('get_all_patient_by_doctor_email',
  //       params: {'doc_email_input': docEmail});
  //   if (kDebugMode) {
  //     print(data);
  //   }
  //   return data;
  // }

  // Future<List<Map<String, dynamic>>>? getData() async {
  //   emit(GetLoading());
  //   final future = supabase
  //       .from('patients')
  //       .select<List<Map<String, dynamic>>>()
  //       .eq('doc_email', supabase.auth.currentUser?.email);
  //   emit(GetSuccess(future));
  //   return future;
  // }

  Future<void> deletePatient(int id) async {
    try {
      final data =
          await supabase.rpc('delete_patient', params: {'p_id_input': id});
      emit(DeleteSuccess(data));
    } catch (e) {
      emit(DeleteFailure(e.toString()));
    }
  }
}
