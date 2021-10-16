import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_event.dart';
import 'package:central_borssa/business_logic/Login/bloc/login_state.dart';
import 'package:central_borssa/data/repositroy/loginRepository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository repository;

  LoginBloc(LoginState loginInitialState, this.repository)
      : super(loginInitialState);

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is StartEvent) {
      yield LoginInitialState();
    } else if (event is LoginSubmite) {
      print('Login bloc');
      var data = await repository.login(event.phone, event.password);
      yield* data.fold((l) async* {
        print(l);
        yield ErrorLoginState();
      }, (r) async* {
        print(r);
        yield LoginLoadingState();

        yield UserLoginScreen();  
      });
    } else if (event is FireBaseTokenEvent) {
      print('Login bloc');
        yield FcmTokenLoading();
      var data = await repository.fcmToken(event.fcmToken);
      yield* data.fold((l) async* {
        print(l);
        yield FcmTokenError();
      }, (r) async* {
        print(r);
        yield FcmTokenLoaded();
      });
    }
  }
}
