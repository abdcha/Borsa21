import 'package:central_borssa/data/model/Currency.dart';
import 'package:central_borssa/data/model/Transfer.dart' as tra;

import 'package:central_borssa/data/model/Post/Cities.dart';
import 'package:equatable/equatable.dart';

class BorssaState extends Equatable {
  const BorssaState();

  @override
  List<Object> get props => [];
}

class BorssaInitial extends BorssaState {}

class GetAllCityState extends BorssaState {
  late final List<CurrencyPrice> cities;

  GetAllCityState({
    required this.cities,
  });
}

//transferloaded

class GetAllTransfersLoading extends BorssaState {}

class GetAllTransfersError extends BorssaState {}

class GetAllTransfersLoaded extends BorssaState {
  late final List<tra.Transfer> cities;

  GetAllTransfersLoaded({
    required this.cities,
  });
}

class BorssaReloadingState extends BorssaState {}

class BorssaLoading extends BorssaState {}

class BorssaErrorLoading extends BorssaState {}

class UpdateBorssaLoading extends BorssaState {}

class UpdateBorssaError extends BorssaState {}

class UpdateBorssaSuccess extends BorssaState {}

//Filter All Posts

class AllCitiesLoading extends BorssaState {}

class AllCitiesLoadingError extends BorssaState {}

class AllCitiesLoaded extends BorssaState {
  late final List<list> cities;
  AllCitiesLoaded({
    required this.cities,
  });
}
