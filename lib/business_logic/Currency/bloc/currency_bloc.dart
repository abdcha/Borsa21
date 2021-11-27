import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:central_borssa/data/model/Chart.dart';
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
          event.id,
          event.buy,
          event.sell,
          event.buystate,
          event.sellstate,
          event.type,
          event.close);
      yield* updatePriceResponse.fold((l) async* {
        print(l);
        yield UpdateBorssaError();
      }, (r) async* {
        print(r);
        yield UpdateBorssaSuccess();
      });
    } else if (event is ChartEvent) {
      yield ChartBorssaLoading();
      final chatResponse = await currencyRepository.drawChart(
          event.cityid, event.fromdate, event.type);
      yield* chatResponse.fold((l) async* {
        print(l);
        ChartBorssaError();
      }, (r) async* {
        print(r);
        yield ChartBorssaLoaded(dataChanges: r);
      });
    } else if (event is UndoEvent) {
      final chatResponse = await currencyRepository.undoLastChange(
        event.cityid,
        event.buy,
        event.sell,
        event.type,
        event.buystatus,
        event.sellstatus,
        event.close,
      );
      yield* chatResponse.fold((l) async* {
        print(l);
        UndoUpdateError();
      }, (r) async* {
        print(r);
        yield UndoUpdateLoading();
        yield UndoUpdateLoaded(status: r);
      });
    }
  }
}
