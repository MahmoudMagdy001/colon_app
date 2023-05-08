import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  // final User user;

  // const LoginSuccess(this.user);
}

class LoginFailure extends LoginState {
  const LoginFailure({required String errorMessage});
}

class LogoutSuccess extends LoginState {}

class LogoutLoading extends LoginState {}
