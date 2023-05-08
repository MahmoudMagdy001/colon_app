part of 'reset_cubit.dart';

abstract class ResetState extends Equatable {
  const ResetState();

  @override
  List<Object> get props => [];
}

class ResetInitial extends ResetState {}

class ResetLoading extends ResetState {}

class ResetSuccess extends ResetState {}

class ResetFailure extends ResetState {
  final String errMessage;

  const ResetFailure(this.errMessage);
}
