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
        print('currency pricy bloc error');
      }, (r) async* {
        yield BorssaReloadingState();
        print('currency pricy bloc');
        yield GetAllCityState(cities: r);
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
    } else if (event is GetAllTransfersEvent) {
      final allCititesResponse = await cityrepository.alltransfer();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        print('transfer error');
        yield GetAllTransfersError();
      }, (r) async* {
        yield GetAllTransfersLoading();
        print('transfer ');
        yield GetAllTransfersLoaded(cities: r);
      });
    } else if (event is TraderCurrencyEvent) {
      final allCititesResponse = await cityrepository.traderCurrency();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        print('currency error');
        yield GetTraderCurrencyError();
      }, (r) async* {
        yield GetTraderCurrencyLoading();
        print(r);
        yield GetTraderCurrencyLoaded(cities: r);
        print('get all');
      });
    }
  }
}
