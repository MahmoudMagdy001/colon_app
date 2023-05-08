import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PatientState extends Equatable {
  const PatientState();

  @override
  List<Object> get props => [];
}

class PatientInitial extends PatientState {}

class AddLoading extends PatientState {}

class GetLoading extends PatientState {}

class AddSuccess extends PatientState {
  final String patients;

  const AddSuccess(this.patients);

  @override
  List<Object> get props => [patients];
}

class GetSuccess extends PatientState {
  final PostgrestFilterBuilder<List<Map<String, dynamic>>> patients;

  const GetSuccess(this.patients);

  @override
  List<Object> get props => [patients];
}

class DeleteSuccess extends PatientState {
  final String patients;

  const DeleteSuccess(this.patients);

  @override
  List<Object> get props => [patients];
}

class AddFailure extends PatientState {
  final String error;

  const AddFailure(this.error);

  @override
  List<Object> get props => [error];
}

class GetFailure extends PatientState {
  final String error;

  const GetFailure(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteFailure extends PatientState {
  final String error;

  const DeleteFailure(this.error);

  @override
  List<Object> get props => [error];
}
