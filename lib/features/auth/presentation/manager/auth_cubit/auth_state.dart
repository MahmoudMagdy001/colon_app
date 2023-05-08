import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends SignupState {}

class AuthLoading extends SignupState {}

class AuthSuccess extends SignupState {
  // final User user;

  // const AuthSuccess({required this.user});
}

class AuthError extends SignupState {
  const AuthError({required String errorMessage});
}
