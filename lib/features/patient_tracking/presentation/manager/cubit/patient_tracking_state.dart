part of 'patient_tracking_cubit.dart';

abstract class PatientTrackingState extends Equatable {
  const PatientTrackingState();

  @override
  List<Object> get props => [];
}

class PatientTrackingInitial extends PatientTrackingState {}

class AddLoading extends PatientTrackingState {}

class AddSuccess extends PatientTrackingState {
  final String drug;

  const AddSuccess(this.drug);
  @override
  List<Object> get props => [drug];
}

class AddFailure extends PatientTrackingState {
  final String error;

  const AddFailure(this.error);
  @override
  List<Object> get props => [error];
}
