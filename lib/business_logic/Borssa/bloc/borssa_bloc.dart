import 'package:central_borssa/business_logic/Borssa/bloc/borssa_event.dart';
import 'package:central_borssa/business_logic/Borssa/bloc/borssa_state.dart';
import 'package:central_borssa/data/model/Currency.dart';
import 'package:central_borssa/data/repositroy/CityRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BorssaBloc extends Bloc<BorssaEvent, BorssaState> {
  CityRepository cityrepository;
  BorssaBloc(BorssaState borssaState, this.cityrepository)
      : super(BorssaInitial());
  late List<CurrencyPrice> mycities = [];

  @override
  Stream<BorssaState> mapEventToState(
    BorssaEvent event,
  ) async* {
    //All City in Borssa
    if (event is AllCity) {
      final allCititesResponse = await cityrepository.allCity();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        yield BorssaErrorLoading();
        print('error');
      }, (r) async* {
        yield BorssaReloadingState();
        yield GetAllCityState(cities: r);
        print('get all');
      });
    }
    //Filter All Posts
    else if (event is AllCitiesList) {
      final allCititesResponse = await cityrepository.allCityName();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        print('from error');
        yield AllCitiesLoadingError();
      }, (r) async* {
        yield AllCitiesLoading();
        print(r);
        yield AllCitiesLoaded(cities: r);
        print('get all');
      });
    }
  }
}
