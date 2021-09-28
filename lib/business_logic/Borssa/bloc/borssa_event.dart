import 'package:equatable/equatable.dart';

class BorssaEvent extends Equatable {
  const BorssaEvent();

  @override
  List<Object> get props => [];
}

class StartBorssaEvent extends BorssaEvent {}

class AllCity extends BorssaEvent {}

// class UpdatePriceEvent extends BorssaEvent {
//   late final int id;
//   late final int buy;
//   late final int sell;
//   late final String status;
//   UpdatePriceEvent({
//     required this.id,
//     required this.buy,
//     required this.sell,
//     required this.status,
//   });
// }
