import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class UserLoginScreen extends LoginState {}

class ErrorLoginState extends LoginState {}

//me infirmation
class MeInformationLoading extends LoginState {}

class MeInformationError extends LoginState {}

class MeInformationLoaded extends LoginState {}

//login trader
class LoginTraderLoading extends LoginState {}

class LoginTraderError extends LoginState {}

class LoginTraderLoaded extends LoginState {}

//Fcm Token
class FcmTokenLoading extends LoginState {}

class FcmTokenError extends LoginState {}

class FcmTokenLoaded extends LoginState {}
