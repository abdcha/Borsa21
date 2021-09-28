import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Chat.dart';
import 'package:equatable/equatable.dart';

import 'package:central_borssa/data/repositroy/CurrencyRepository.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyRepository currencyRepository;

  CurrencyBloc(
    CurrencyState currencyEvent,
    this.currencyRepository,
  ) : super(CurrencyInitial());

  @override
  Stream<CurrencyState> mapEventToState(
    CurrencyEvent event,
  ) async* {
    if (event is UpdatePriceEvent) {
      final updatePriceResponse = await currencyRepository.updatePrice(
          event.id, event.buy, event.sell, event.status);
      yield* updatePriceResponse.fold((l) async* {
        print(l);
        yield UpdateBorssaError();
      }, (r) async* {
        print(r);
        yield UpdateBorssaSuccess();
      });
    } else if (event is ChartEvent) {
      final chatResponse = await currencyRepository.DrawChart(
          event.cityid, event.fromdate, event.todate);
      yield* chatResponse.fold((l) async* {
        print(l);
        ChartBorssaError();
      }, (r) async* {
        print(r);
        yield ChartBorssaLoading();
        yield ChartBorssaLoaded(dataChanges: r);
      });
    }
  }
}
