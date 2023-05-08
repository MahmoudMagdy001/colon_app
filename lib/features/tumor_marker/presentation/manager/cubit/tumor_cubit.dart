// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'tumor_state.dart';

final supabase = Supabase.instance.client;

class TumorCubit extends Cubit<TumorState> {
  TumorCubit() : super(TumorInitial());

  Future<void> addTumor(
    int? id,
    double? cea,
    double? ca19,
    double? ca50,
    double? ca24,
    double? afp,
  ) async {
    try {
      emit(AddLoading());

      final data = await supabase.rpc(
        'add_tumor_data',
        params: {
          'pnt_id_input': id,
          'cea_input': cea,
          'ca19_input': ca19,
          'ca50_input': ca50,
          'ca24_input': ca24,
          'afp_input': afp,
        },
      );
      emit(AddSuccess(data));
    } catch (e) {
      emit(AddFailure(e.toString()));
    }
  }
}
