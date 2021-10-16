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

class MeInformationState extends LoginState {}

//Fcm Token
class FcmTokenLoading extends LoginState {}

class FcmTokenError extends LoginState {}

class FcmTokenLoaded extends LoginState {}
