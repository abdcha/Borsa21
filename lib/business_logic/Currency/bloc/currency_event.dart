part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

//update value and close
class UpdatePriceEvent extends CurrencyEvent {
  final int id;
  final double buy;
  final double sell;
  final String buystate;
  final String sellstate;
  final int close;
  final String type;

  UpdatePriceEvent({
    required this.id,
    required this.buy,
    required this.sell,
    required this.buystate,
    required this.sellstate,
    required this.close,
    required this.type,
  });
}

class ChartEvent extends CurrencyEvent {
  final int cityid;
  final String fromdate;
  final String type;
  ChartEvent({
    required this.cityid,
    required this.fromdate,
    required this.type,
  });
}

//undo update
class UndoEvent extends CurrencyEvent {
  late final int cityid;
  late final String fromdate;
  UndoEvent({
    required this.cityid,
    required this.fromdate,
  });
}
