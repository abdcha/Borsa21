part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class UpdatePriceEvent extends CurrencyEvent {
  final int id;
  final double buy;
  final double sell;
  final String buystate;
  final String sellstate;
  final String type;

  UpdatePriceEvent({
    required this.id,
    required this.buy,
    required this.sell,
    required this.buystate,
    required this.sellstate,
    required this.type,
  });
}

class ChartEvent extends CurrencyEvent {
  late final int cityid;
  late final String fromdate;
  ChartEvent({
    required this.cityid,
    required this.fromdate,
  });
}
