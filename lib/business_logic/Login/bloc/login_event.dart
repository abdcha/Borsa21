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

class MeInformationEvent extends LoginEvent {}

class FireBaseTokenEvent extends LoginEvent {
  final String? fcmToken;
  FireBaseTokenEvent({
    required this.fcmToken,
  });
}
