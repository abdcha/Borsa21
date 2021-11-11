import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class StartEvent extends LoginEvent {}

class LoginSubmite extends LoginEvent {
  final String phone;
  final String password;

  LoginSubmite({
    required this.phone,
    required this.password,
  });
}

class LoginTraderSubmite extends LoginEvent {
  final String phone;
  final String password;
  final String email;
  final String name;
  LoginTraderSubmite({
    required this.phone,
    required this.password,
    required this.email,
    required this.name,
  });
}

class MeInformationEvent extends LoginEvent {}

class FireBaseTokenEvent extends LoginEvent {
  final String? fcmToken;
  FireBaseTokenEvent({
    required this.fcmToken,
  });
}
