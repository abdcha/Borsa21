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
    if (event is AllCity) {
      yield BorssaReloadingState();

      final allCititesResponse = await cityrepository.allCity();
      yield* allCititesResponse.fold((l) async* {
        print(l);
        yield BorssaErrorLoading();
        print('error');
      }, (r) async* {
        yield GetAllCityState(cities: r);
        print('get all');
      });
    }
    // else if (event is UpdatePriceEvent) {
    //   final updatePriceResponse = await cityrepository.updatePrice(
    //       event.id, event.buy, event.sell, event.status);
    // }
  }
}
