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
  final int cityid;
  final double buy;
  final double sell;
  final String sellstatus;
  final String buystatus;
  final String type;
  final int close;

  UndoEvent({
    required this.cityid,
    required this.buy,
    required this.sell,
    required this.sellstatus,
    required this.buystatus,
    required this.type,
    required this.close,
  });
}
