part of 'tumor_cubit.dart';

abstract class TumorState extends Equatable {
  const TumorState();

  @override
  List<Object> get props => [];
}

class TumorInitial extends TumorState {}

class AddLoading extends TumorState {}

class AddSuccess extends TumorState {
  final String patients;

  const AddSuccess(this.patients);

  @override
  List<Object> get props => [patients];
}

class AddFailure extends TumorState {
  final String error;

  const AddFailure(this.error);

  @override
  List<Object> get props => [error];
}
