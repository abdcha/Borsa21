part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class UpdatePriceEvent extends CurrencyEvent {
  late final int id;
  late final int buy;
  late final int sell;
  late final String status;
  UpdatePriceEvent({
    required this.id,
    required this.buy,
    required this.sell,
    required this.status,
  });
}

class ChartEvent extends CurrencyEvent {
  late final int cityid;
  late final String fromdate;
  late final String todate;
  ChartEvent({
    required this.cityid,
    required this.fromdate,
    required this.todate,
  });
}
