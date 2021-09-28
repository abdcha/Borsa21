// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:central_borssa/business_logic/bloc/authlogin_event.dart';
// import 'package:central_borssa/business_logic/bloc/authlogin_state.dart';
// import 'package:central_borssa/data/model/City.dart';
// import 'package:central_borssa/data/repositroy/CityRepository.dart';
// import 'package:central_borssa/data/repositroy/loginRepository.dart';

// class AuthloginBloc extends Bloc<AuthloginEvent, AuthloginState> {
//   LoginRepository repository;

//   AuthloginBloc(AuthloginEvent AuthloginEvent, this.repository)
//       : super(AuthloginInitial());

//   @override
//   Stream<AuthloginState> mapEventToState(
//     AuthloginEvent event,
//   ) async* {
//     if (event is StartEvent) {
//       yield AuthloginInitial();
//     } else if (event is LoginSubmite) {
//       yield LoginLoadingState();
//       var data = await repository.login(event.phone, event.password);
//       print(data);
//       if (data == "success") {
//         print('hi from condition');

//         yield UserLoginScreen();
//       }
//       // if(data[]) permission
//     } else if (event is )
//   }
// }

// class CityBloc extends Bloc<AuthloginEvent, AuthloginState> {
 
// }
