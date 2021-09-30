import 'package:equatable/equatable.dart';

import 'package:central_borssa/data/model/City.dart';

class BorssaEvent extends Equatable {
  const BorssaEvent();

  @override
  List<Object> get props => [];
}

class StartBorssaEvent extends BorssaEvent {}

class AllCity extends BorssaEvent {}

class AllCitiesList extends BorssaEvent {}
