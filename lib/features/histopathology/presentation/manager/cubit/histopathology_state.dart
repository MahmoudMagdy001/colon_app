part of 'histopathology_cubit.dart';

abstract class HistopathologyState extends Equatable {
  const HistopathologyState();

  @override
  List<Object> get props => [];
}

class HistopathologyInitial extends HistopathologyState {}

class HistopathologyLoading extends HistopathologyState {}

class HistopathologySuccess extends HistopathologyState {}

class HistopathologyFailure extends HistopathologyState {}
